import os
from typing import Dict, List
from loguru import logger
from config import GEMINI_MODEL

from google.adk import Runner
from google.adk.agents import LlmAgent, SequentialAgent
from google.adk.sessions import InMemorySessionService
from google.genai import types

from config import APP_NAME, GEMINI_MODEL
from src.prompt import WRITER_INSTRUCTIONS


def _construct_writer_agents(
    initial_content: str,
    docs_plan      : Dict
) -> List[LlmAgent]:

    sub_agents = []
    chapter_ids = []

    for idx, chapter in enumerate(docs_plan.get("chapters", [])):

        chapter_name = chapter.get("name")
        chapter_content = chapter.get("content")

        if not chapter_name or not chapter_content:
            logger.warning(f"Skipping chapter {idx + 1} because it has no name or content.")
            continue

        # Check if the chapter has already been written
        if os.path.exists(f"./output/chapter_{idx + 1}.md"):
            logger.info(f"Skipping chapter {idx + 1} because it already exists.")
            continue

        write_report_agent = LlmAgent(
            name             = "WriterAgent",
            model            = WRITER_MODEL,
            include_contents = "none",
            instruction      = WRITER_INSTRUCTIONS.format(
                initial_content = initial_content,
                chapter_name    = chapter_name,
                chapter_content = chapter_content
            ),
            description      = "Writes a detailed documentation from an outline",
            output_key       = f'STATE_REPORT_{idx + 1}',
        )

        sub_agents.append(write_report_agent)
        chapter_ids.append(idx + 1)
        logger.info(f"Set up writer agent for: {chapter_name}...")

    return sub_agents, chapter_ids


async def sequential_writing_pipeline(
    session_service: InMemorySessionService,
    initial_content: str,
    docs_plan      : Dict,
    USER_ID        : str,
    SESSION_ID     : str
):
    sub_agents, chapter_ids = _construct_writer_agents(initial_content, docs_plan)

    # Use SequentialAgent to prevent rate limiting
    writer_agent = SequentialAgent(
        name        = "SequentialWritingPipeline",
        sub_agents  = sub_agents,
        description = "Writes a detailed documentation from an outline"
    )
    writer_agent_runner = Runner(
        agent           = writer_agent,
        app_name        = APP_NAME,
        session_service = session_service
    )

    content = types.Content(role='user', parts=[types.Part(text="")])
    events = writer_agent_runner.run(
        user_id     = USER_ID,
        session_id  = SESSION_ID,
        new_message = content
    )

    # Sequential agent response
    logger.info("Writing chapters...")

    for idx, event in enumerate(events):
        if event.is_final_response() and event.content and event.content.parts:
            logger.info(f"Finished chapter {chapter_ids[idx]}.")

            with open(f"./output/chapter_{chapter_ids[idx]}.md", "w") as f:
                f.write(event.content.parts[0].text)
