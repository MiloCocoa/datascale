import json
from loguru import logger
from pydantic import BaseModel, Field

from google.adk import Runner
from google.adk.agents import LlmAgent
from google.adk.sessions import InMemorySessionService
from google.genai import types

from config import APP_NAME, USER_ID, SESSION_ID, GEMINI_MODEL
from src.prompt import PLANNER_INSTRUCTIONS
from src.utils import parse_planner_response

# Input Schema
class PlannerModel(BaseModel):
    initial_content: str = Field(description="Initial content")


async def create_documentation_outline(
    session_service: InMemorySessionService,
    initial_content: str,
    USER_ID        : str,
    SESSION_ID     : str
):
    plan_agent = LlmAgent(
        name             = "PlannerAgent",
        model            = GEMINI_MODEL,
        include_contents = 'none',
        instruction      = PLANNER_INSTRUCTIONS.format(initial_content=initial_content),
        description      = "Writes an outline of a documentation from the given content",
        input_schema     = PlannerModel
    )
    plan_agent_runner = Runner(
        agent           = plan_agent,
        app_name        = APP_NAME,
        session_service = session_service
    )

    content = types.Content(role='user', parts=[types.Part(text="")])
    events = plan_agent_runner.run_async(
        user_id     = USER_ID,
        session_id  = SESSION_ID,
        new_message = content
    )

    planner_response = None
    logger.info("Creating the documentation outline...")
    async for event in events:
        if event.is_final_response() and event.content and event.content.parts:
            planner_response = event.content.parts[0].text

    if not planner_response:
        logger.warning("Failed to plan the documentation.")
        return

    # Parse the response
    try:
        chapters = parse_planner_response(planner_response)
        logger.info(f"Finished planner agent response with {len(chapters.get('chapters', []))} chapters.")
        return chapters
    except Exception as e:
        logger.error(f"Failed to parse the planner response: {e}")
        return


