PLANNER_INSTRUCTIONS = """
You are a technical knowledge base builder. You are tasked with planning a documentation outline.
You're an editor for this doc, so you're going to plan the structure of the doc and the content of each chapter.

Draft an outline from the given content:
<content>
{initial_content}
</content>

An outline will start with the overview followed by each chapter (chapter1, chapter1.1, chapter1.2, chapter2, etc.)
Add sub-chapters for better organization (you can go 3 levels deep max).
For each chapter, include a detailed content plan as a guideline for the writers.

Structure the outline as a JSON object in the following format:
```json
{{
    "overview": "*content*",
    "chapters": [
        {{
            "name": "## Chapter 1. NAME",
            "content": "*content*"
        }},
        {{
            "name": "### Chapter 1.1. NAME",
            "content": "*content*"
        }},
        {{
            "name": "### Chapter 1.2. NAME",
            "content": "*content*"
        }},
        {{
            "name": "### Chapter 2. NAME",
            "content": "*content*"
        }}
    ]
}}
```
Do not add any explanations. Output only the outline in JSON format.
"""



WRITER_INSTRUCTIONS = """
You are a technical writer. You are tasked with writing a detailed documentation for each section from the given content and outline.

**Here is the outline:**
<outline>
{chapter_name}
{chapter_content}
</outline>

**Here's the content:**
<content>
{initial_content}
</content>

Include many details as possible.
Include code snippets when you refer to any code in your report.

Do not add any explanations. Output only the content in markdown format.

Example output:
<output>
## Chapter 1. Introduction

Content

### 1.1. ...

....

### 1.2. ...
</output>
"""