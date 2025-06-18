import os
import json
import asyncio
import argparse
from typing import Dict
from loguru import logger
from dotenv import load_dotenv

from google.adk.sessions import InMemorySessionService

from config import APP_NAME, USER_ID, SESSION_ID
from src.utils import read_codebase_file, read_codebase_directory, write_json_response
from src.planner import create_documentation_outline
from src.writer import sequential_writing_pipeline

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
    docs_plan: Dict = dict()

    # Check if docs_plan.json exists
    if os.path.exists("output/docs_plan.json"):
        logger.info("Found existing docs_plan.json, skipping planner step")
        with open("output/docs_plan.json", "r") as f:
            docs_plan = json.load(f)
    else:
        docs_plan = await create_documentation_outline(
            session_service = session_service,
            initial_content = initial_content,
            USER_ID         = USER_ID,
            SESSION_ID      = SESSION_ID
        )
        if not docs_plan: return

        write_json_response("docs_plan", docs_plan)


    # 3. Writer Sub-agents
    # ====================================================================
    await sequential_writing_pipeline(
        session_service = session_service,
        initial_content = initial_content,
        docs_plan       = docs_plan,
        USER_ID         = USER_ID,
        SESSION_ID      = SESSION_ID
    )


def parse_arguments():
    """
    Parse command line arguments
    """
    parser = argparse.ArgumentParser(description="Documentation builder for codebases")
    parser.add_argument(
        "--path",
        type=str,
        default="./data",
        help="Path to a file or directory containing the codebase to document"
    )
    parser.add_argument(
        "--max-size",
        type=int,
        default=1000000,
        help="Maximum content size in characters (default: 1,000,000)"
    )
    return parser.parse_args()


# Run the Agent
async def main():
    logger.info("Running documentation builder")

    # Parse command line arguments
    args = parse_arguments()
    path = args.path
    max_size = args.max_size

    logger.info(f"Processing path: {path}")
    logger.info(f"Maximum content size: {max_size:,} characters")

    # 1. Read contents
    # ====================================================================
    content = None
    if os.path.isdir(path):
        logger.info(f"Reading directory: {path}")
        content = read_codebase_directory(path, max_size)
    elif os.path.isfile(path):
        logger.info(f"Reading single file: {path}")
        content = read_codebase_file(path)
    else:
        logger.error(f"Path does not exist: {path}")
        return

    # 2. Log contents
    # ====================================================================
    with open("output/content.txt", "w") as f:
        f.write(content)

    # 3. Agent Workflow
    # ====================================================================
    if not content:
        logger.error("Content not found!")
    else:
        await call_agents(content)


if __name__ == "__main__":
    asyncio.run(main())