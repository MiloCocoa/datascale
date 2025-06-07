import re
import json
from typing import Dict

def read_codebase(file_path: str) -> str:
    """
    Read the codebase (mock as a single file)
    """
    try:
        with open(file_path, 'r') as file:
            content = file.read()
        return content

    except Exception as e:
        print(f"An error occurred while reading the file: {e}")
        return None


def parse_planner_response(response: str) -> Dict:
    """
    Parse the planner response and return the chapters
    """
    pattern = r"```json\s*(.*?)```"
    matches = re.findall(pattern, response, re.DOTALL)
    json_blocks = [match.strip() for match in matches]
    result = "\n".join(json_blocks)
    chapters = json.loads(result)

    return chapters


def write_planner_response(response: str):
    """
    Write the planner response to a file.
    """
    with open("output/planner_response.json", "w") as f:
        json.dump(response, f, indent=2)