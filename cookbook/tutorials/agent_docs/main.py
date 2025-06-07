import json
import asyncio
from loguru import logger
from dotenv import load_dotenv

from google.adk import Runner
from google.adk.agents import LlmAgent, SequentialAgent
from google.adk.sessions import InMemorySessionService
from google.genai import types

from config import APP_NAME, USER_ID, SESSION_ID
from src.utils import read_codebase, write_planner_response
from src.planner import create_documentation_outline

load_dotenv()


# Agent Workflow
async def call_agents(initial_content: str):
    """
    Sends an initial content to the agent and runs the workflow.
    """

    # 1. Create Session
    # ====================================================================
    session_service = InMemorySessionService()
    current_session = await session_service.create_session(
        app_name   = APP_NAME,
        user_id    = USER_ID,
        session_id = SESSION_ID,
    )
    if not current_session:
        logger.warning("Session not found!")
        return

    # 2. Planner Agent
    # ====================================================================
    chapters = await create_documentation_outline(
        session_service = session_service,
        initial_content = initial_content,
        USER_ID         = USER_ID,
        SESSION_ID      = SESSION_ID
    )
    if not chapters: return

    write_planner_response(chapters)



# Run the Agent
async def main():
    logger.info("Running documentation builder")

    content = read_codebase("data/gitlab_crm.sql")

    if not content: print("Content not found!")
    else: await call_agents(content)


if __name__ == "__main__":
    asyncio.run(main())