# Running Your Agent

<img src="_static/robots/operator.png" alt="Klondike 5, 4 6 5 2. On the double, we gotta 23 skidoo!" style="float:right;max-width:300px;margin:25px;" />

We've done our part, its time to put this agent to work! In this excercise, we will start the agent and ask it a few questions. We will learn the tricks of the trade used by developers to test and debug agents.

<!-- fold:break -->

## Start the Agent Service

LangGraph offers a convenient CLI that launches a web server to host your agent behind an API. This allows you to interact with your agent programmatically by sending user prompts and receiving responses. While other frameworks may provide different ways to deploy agents, the core idea is the same: your agent runs as a service accessible via an API endpoint.

To get started, start a new <button onclick="openNewTerminal();"><i class="fas fa-terminal"></i> terminal</button> here in Jupyter.

Change to the `code` directory:

```bash
cd code
```

And start your Agent API with the LangGraph CLI.

```bash
langgraph dev \
  --config rag_agent.json \
  --host 0.0.0.0 \
  --port 2024
```

Will auto reload on changes. Example error log:

    2025-09-09T04:33:07.173253Z [info     ] Reading knowledge base data from /project/data/it-knowledge-base [__rag_agent] api_variant=local_dev langgraph_api_version=0.4.11 thread_name=asyncio_0
    92%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████▏           | 12/13 [00:00<00:00, 11963.79it/s]
    2025-09-09T04:33:07.179200Z [info     ] Ingesting 12 documents into FAISS vector database. [__rag_agent] api_variant=local_dev langgraph_api_version=0.4.11 thread_name=asyncio_0
    2025-09-09T04:33:07.179588Z [info     ] Shutting down remote graphs    [langgraph_api.graph] api_variant=local_dev langgraph_api_version=0.4.11 thread_name=MainThread
    2025-09-09T04:33:07.183624Z [error    ] Traceback (most recent call last):
      File "/home/workbench/.local/lib/python3.12/site-packages/starlette/routing.py", line 694, in lifespan
        async with self.lifespan_context(app) as maybe_state:
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/usr/lib/python3.12/contextlib.py", line 210, in __aenter__
        return await anext(self.gen)
              ^^^^^^^^^^^^^^^^^^^^^
      File "/home/workbench/.local/lib/python3.12/site-packages/langgraph_runtime_inmem/lifespan.py", line 79, in lifespan
        await graph.collect_graphs_from_env(True)
      File "/home/workbench/.local/lib/python3.12/site-packages/langgraph_api/graph.py", line 421, in collect_graphs_from_env
        graph = await run_in_executor(None, _graph_from_spec, spec)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/home/workbench/.local/lib/python3.12/site-packages/langgraph_api/utils/config.py", line 144, in run_in_executor
        return await asyncio.get_running_loop().run_in_executor(
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/usr/lib/python3.12/concurrent/futures/thread.py", line 59, in run
        result = self.fn(*self.args, **self.kwargs)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "/home/workbench/.local/lib/python3.12/site-packages/langgraph_api/utils/config.py", line 135, in wrapper
        return func(*args, **kwargs)
              ^^^^^^^^^^^^^^^^^^^^^
      File "/home/workbench/.local/lib/python3.12/site-packages/langgraph_api/graph.py", line 468, in _graph_from_spec
        modspec.loader.exec_module(module)  # type: ignore[possibly-unbound-attribute]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      File "<frozen importlib._bootstrap_external>", line 999, in exec_module
      File "<frozen importlib._bootstrap>", line 488, in _call_with_frames_removed
      File "/project/code/rag_agent.py", line 37, in <module>
        chunks = splitter.split_documents(docs)
                ^^^^^^^^^^^^^^^^^^^^^^^^
    AttributeError: 'ellipsis' object has no attribute 'split_documents'

<!-- fold:break -->

## Chat with the Agent

<button onclick="launch('Simple Agents Client');"><i class="fa-solid fa-rocket"></i> Simple Agents Client</button>

1. run the studio ui

1. interact

<!-- fold:break -->

## Examine Traces

1. check langsmith

<!-- fold:break -->

## next

next