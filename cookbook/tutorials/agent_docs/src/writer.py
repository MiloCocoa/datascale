import os
import re
from typing import Dict, List, Optional
from loguru import logger

from google.adk import Runner
from google.adk.agents import LlmAgent, SequentialAgent
from google.adk.sessions import InMemorySessionService
from google.genai import types

from config import APP_NAME, WRITER_MODEL, WRITER_BATCH_SIZE
from src.prompt import WRITER_INSTRUCTIONS


def parse_chapter_number(chapter_name: str) -> Optional[str]:
    """
    Parse chapter number from table of contents name using regex.

    Examples:
        "## 4.1. CRM" -> "4.1"
        "### 3.2.1. CRM Person Dimension" -> "3.2.1"
        "## Introduction" -> None

    Args:
        chapter_name: The chapter name from table of contents

    Returns:
        The parsed chapter number as string, or None if no number found
    """
    # Regex to match chapter numbers: one or more digits followed by optional .digit patterns
    pattern = r'^#+\s*(\d+(?:\.\d+)*)\.'
    match = re.match(pattern, chapter_name)
    return match.group(1) if match else None


def chapter_number_to_filename(chapter_number: str) -> str:
    """
    Convert chapter number to 3-digit filename format.

    Examples:
        "1" -> "chapter_100.md"
        "1.1.1" -> "chapter_111.md"
        "2.1" -> "chapter_210.md"

    Args:
        chapter_number: Chapter number string (e.g., "4.1", "3.2.1")

    Returns:
        Formatted filename
    """
    parts = chapter_number.split('.')

    # Pad with zeros to ensure we have 3 parts
    while len(parts) < 3:
        parts.append('0')

    # Take only first 3 parts and convert to integers
    major = int(parts[0])
    minor = int(parts[1])
    patch = int(parts[2])

    # Format as 3-digit number
    chapter_id = f"{major}{minor}{patch}"

    return f"chapter_{chapter_id}.md"


def construct_writer_agents(
    initial_content: str,
    docs_plan      : Dict
) -> List[LlmAgent]:

    sub_agents  = []
    chapter_filenames = []
    table_of_contents = docs_plan.get("table_of_contents", [])

    k = 0
    for idx, chapter in enumerate(table_of_contents):

        chapter_name = chapter.get("name")
        chapter_content = chapter.get("content")

        if not chapter_name or not chapter_content:
            logger.warning(f"Skipping chapter {idx + 1} because it has no name or content.")
            continue

        # Parse chapter number from name
        chapter_number = parse_chapter_number(chapter_name)
        if chapter_number:
            filename = chapter_number_to_filename(chapter_number)
        else:
            # Fallback to sequential numbering for chapters without numbers
            filename = f"chapter_{idx + 1:03d}.md"

        filepath = f"./output/{filename}"

        # Check if the chapter has already been written
        if os.path.exists(filepath):
            logger.info(f"Skipping {filename} because it already exists.")
            continue

        if k == WRITER_BATCH_SIZE:
            return sub_agents, chapter_filenames

        write_report_agent = LlmAgent(
            name             = "WriterAgent",
            model            = WRITER_MODEL,
            include_contents = "none",
            instruction      = WRITER_INSTRUCTIONS.format(
                table_of_contents = table_of_contents,
                initial_content   = initial_content,
                chapter_name      = chapter_name,
                chapter_content   = chapter_content
            ),
            description      = "Writes a detailed documentation from an outline",
            output_key       = f'STATE_REPORT_{filename.replace(".md", "")}',
        )

        sub_agents.append(write_report_agent)
        chapter_filenames.append(filename)
        logger.info(f"Set up a writing agent for: {chapter_name} -> {filename}")

        k += 1

    return sub_agents, chapter_filenames


async def sequential_writing_pipeline(
    session_service: InMemorySessionService,
    initial_content: str,
    docs_plan      : Dict,
    USER_ID        : str,
    SESSION_ID     : str
):
    sub_agents, chapter_filenames = construct_writer_agents(initial_content, docs_plan)

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
            filename = chapter_filenames[idx]
            logger.info(f"Finished {filename}.")

            with open(f"./output/{filename}", "w") as f:
                f.write(event.content.parts[0].text)
