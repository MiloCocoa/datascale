# Agentic Documentation Writer

Build modular agents that plan and write documentation for your projects.

## Commands

```bash
python -m venv venv
pip install -r requirements.txt

python main.py
```

## Process log

Example result:

```bash
| INFO     | __main__:main:72 - Running documentation builder
| INFO     | __main__:call_agents:44 - Found existing docs_plan.json, skipping planner step
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 1 because it already exists.
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 2 because it already exists.
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 3 because it already exists.
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 4 because it already exists.
| INFO     | src.writer:_construct_writer_agents:52 - Set up writer agent for: ## Chapter 5. Restricted Safe Preparation Tables...
| INFO     | src.writer:_construct_writer_agents:52 - Set up writer agent for: ## Chapter 6. SFDC Preparation Tables...
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 7 because it already exists.
| INFO     | src.writer:_construct_writer_agents:34 - Skipping chapter 8 because it already exists.
| INFO     | src.writer:sequential_writing_pipeline:86 - Writing chapters...
| INFO     | src.writer:sequential_writing_pipeline:90 - Finished chapter 5.
| INFO     | src.writer:sequential_writing_pipeline:90 - Finished chapter 6.
```


## References

* [Gemini Models](https://ai.google.dev/gemini-api/docs/models)
* [Agent Development Kit](https://google.github.io/adk-docs/)
* [Multi-agent System](https://google.github.io/adk-docs/agents/multi-agents/)