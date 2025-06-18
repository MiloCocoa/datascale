import re
import json
import os
from typing import Dict
from config import MAX_CONTENT_SIZE


METADATA_BLOCK = """// ===========================
// filepath: {file_path}
// size: {line_count:,} lines, {char_count:,} characters

{file_content}

"""

def read_codebase_file(file_path: str) -> str:
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


def read_codebase_directory(directory_path: str, max_content_size: int = MAX_CONTENT_SIZE) -> str:
    """
    Read all files in a directory and concatenate them with metadata
    """
    if not os.path.exists(directory_path):
        print(f"Directory does not exist: {directory_path}")
        return None

    if not os.path.isdir(directory_path):
        print(f"Path is not a directory: {directory_path}")
        return None

    content_parts = []
    total_size = 0

    # 50K characters for system prompt overhead
    max_content_size = max_content_size - 50_000

    # Get all files in directory (including subdirectories)
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            file_path = os.path.join(root, file)

            # Skip binary files and common non-text files
            if file.endswith(('.pyc', '.png', '.jpg', '.jpeg', '.gif', '.pdf', '.exe', '.bin')):
                continue

            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    file_content = f.read()

                # Check if adding this file would exceed the limit
                metadata_overhead = 200  # Approximate overhead for metadata
                if total_size + len(file_content) + metadata_overhead > max_content_size:
                    print(f"Reached maximum content size limit ({max_content_size:,} characters). Stopping at file: {file_path}")
                    break

                # Calculate metadata
                line_count = len(file_content.splitlines())
                char_count = len(file_content)

                # Format with metadata
                metadata_block = METADATA_BLOCK.format(
                    file_path   = file_path,
                    line_count  = line_count,
                    char_count  = char_count,
                    file_content = file_content
                )

                content_parts.append(metadata_block)
                total_size += len(metadata_block) + len(file_content)

            except Exception as e:
                print(f"Error reading file {file_path}: {e}")
                continue

        # Break outer loop if we hit the size limit
        if total_size >= max_content_size:
            break

    if not content_parts:
        print(f"No readable files found in directory: {directory_path}")
        return None

    print(f"Total content size: {total_size:,} characters from {len(content_parts)} files")
    return "".join(content_parts)


def parse_planner_response(response: str) -> Dict:
    """
    Parse the planner response and return the table of contents
    """
    pattern = r"```json\s*(.*?)```"
    matches = re.findall(pattern, response, re.DOTALL)
    json_blocks = [match.strip() for match in matches]
    result = "\n".join(json_blocks)
    chapters = json.loads(result)

    return chapters


def write_json_response(file_name: str, response: Dict):
    """
    Write the response to a file.
    """
    with open(f"output/{file_name}.json", "w") as f:
        json.dump(response, f, indent=2)
