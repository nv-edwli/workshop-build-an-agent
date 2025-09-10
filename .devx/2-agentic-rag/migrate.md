# Migrate to Local NIM Microservices

<img src="_static/robots/relocate.png" alt="Box 'em up and bring 'em home. " style="float:right;max-width:300px;margin:25px;" />

[NVIDIA's API Catalog](https://build.nvidia.com) is an excellent resource for discovering and evaluating many different Generative AI models. There is a wide breadth of available models, and getting started is free.

These APIs are useful for fast starts and experiments. However, for the unlimited performance and control needed in production, deploy models locally with NVIDIA NIM microservice containers.

In this excercise, we will run our LLM model locally and transition our code to our private model.

<!-- fold:break -->

## Find Deployment Instructions

We've been using the [nvidia-nemotron-nano-9b-v2](https://build.nvidia.com/nvidia/nvidia-nemotron-nano-9b-v2) LLM from NVIDIA's API Catalog. For any model you want to run locally, look for the *Deploy* tab on its API Catalog page. Here you can find step-by-step instructions for running the model as a container.

For our model, you can find the relevant details on the [deployment page](https://build.nvidia.com/nvidia/nvidia-nemotron-nano-9b-v2/deploy), including Docker commands and environment setup.

Whenever you want to deploy a new model, check its *Deploy* tab for reference instructions. We'll be closely following these directions, with slight modifications, to run our LLM locally.

<!-- fold:break -->

## Pull and Run the NIM

<img src="_static/robots/startup.png" alt="It's alive!" style="float:right;max-width:300px;margin:25px;" />

Start by opening a new <button onclick="openNewTerminal();"><i class="fas fa-terminal"></i> terminal</button> tab in Jupyter. We'll use this dedicated terminal to launch the NIM container.

In a typical development workflow, both your agent and NIM containers would run in the background, allowing you to multitask and iterate quickly. For this exercise, it's perfectly fine to run the NIM in the foreground so you can easily monitor its output and ensure everything starts up correctly.

<!-- fold:break -->

### Login to NGC

Login to the NVIDIA GPU Cloud (NGC) container registry.

```bash
echo $NVIDIA_API_KEY | \
  docker login nvcr.io \
  --username '$oauthtoken' \
  --password-stdin
```
<!-- fold:break -->

### Create your NIM Cache

Create a location for NIM containers to save their downloaded model files.

```bash
docker volume create nim-cache
```

<!-- fold:break -->

### 🔥 Let's go!

Light the fires with this Docker run command! This command will pull the NIM container image and model data files before hosting the model behind a local OpenAI compliant API. Start this command and go on to the next step.

```bash
docker run -it --rm \
    --name nemotron \
    --network workbench \
    --gpus 1 \
    --shm-size=16GB \
    -e NGC_API_KEY=$NVIDIA_API_KEY \
    -v nim-cache:/opt/nim/.cache \
    -u $(id -u) \
    -p 8000:8000 \
    nvcr.io/nim/nvidia/nvidia-nemotron-nano-9b-v2:latest
```

<!-- fold:break -->

As the NIM container is starting, the log allows you to observe that it is:

1. Finding the most optimized profile for your hardware
2. Downloading the model files
3. Loading the model, and finally
4. Starting the model

*Expect everything to take a few minutes to stabilize.*

You'll know the NIM is ready for inference when it says `Application startup complete`, runs a built-in smoke test, then starts logging metrics.

<details>

<summary>📜 If you're curious, it looks like this.</summary>

```
INFO 2025-09-10 16:31:52.7 on.py:48] Waiting for application startup.
INFO 2025-09-10 16:31:52.239 on.py:62] Application startup complete.
INFO 2025-09-10 16:31:52.240 server.py:214] Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO 2025-09-10 16:31:55.944 api_server.py:516] An example cURL request:
curl -X 'POST' \
  'http://0.0.0.0:8000/v1/chat/completions' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "nvidia/nvidia-nemotron-nano-9b-v2",
    "messages": [
      {
        "role":"user",
        "content":"Hello! How are you?"
      },
      {
        "role":"assistant",
        "content":"Hi! I am quite well, how can I help you today?"
      },
      {
        "role":"user",
        "content":"Can you write me a song?"
      }
    ],
    "top_p": 1,
    "n": 1,
    "max_tokens": 15,
    "stream": true,
    "frequency_penalty": 1.0,
    "stop": ["hello"]
  }'

INFO 2025-09-10 16:31:55.944 api_server.py:524] Responses API examples:
curl -X 'POST' \
  'http://0.0.0.0:8000/v1/responses' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "nvidia/nvidia-nemotron-nano-9b-v2",
    "input": "Hello, how are you?",
    "max_output_tokens": 128,
    "stream": false
  }'


curl -X 'GET' \
  'http://0.0.0.0:8000/v1/responses/resp_123456' \
  -H 'accept: application/json'


curl -X 'POST' \
  'http://0.0.0.0:8000/v1/responses/resp_123456/cancel' \
  -H 'accept: application/json'

INFO 2025-09-10 16:32:05.957 metrics.py:386] Avg prompt throughput: 0.2 tokens/s, Avg generation throughput: 1.1 tokens/s, Running: 0 reqs, Swapped: 0 reqs, Pending: 0 reqs, GPU KV cache usage: 0.0%, CPU KV cache usage: 0.0%.
```

</details>

<!-- fold:break -->

## Test the NIM

Before moving on, let's verify that the NIM is running correctly by sending it a test request.

Open a new <button onclick="openNewTerminal();"><i class="fas fa-terminal"></i> terminal</button> tab, and run the following test command:

```bash
curl -X 'POST' \
  'http://nemotron:8000/v1/chat/completions' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
      "model": "nvidia/nvidia-nemotron-nano-9b-v2",
      "messages": [{"role":"user", "content":"Which number is larger, 9.11 or 9.8?"}],
      "max_tokens": 64
  }'
```

You should see the model start to answer the question, then get cut off after 64 tokens.

<!-- fold:break -->

## Reconfigure the Agent

We can now point our agent at our locally running NIM.

Recall that back in our agent's code, we defined the `llm` using the <button onclick="goToLineAndSelect('code/rag_agent.py', '= ChatNVIDIA(');"><i class="fas fa-code"></i> ChatNVIDIA</button> class. We need to reconfigure this object to use `http://nemotron:8000/v1` as a base URL.

Check out the [official docs](https://python.langchain.com/docs/integrations/chat/nvidia_ai_endpoints/#working-with-nvidia-nims) to see how this code should be updated to point to the local NIM. Make that change now.

<details>
<summary>🆘 Need some help?</summary>

```python
# Define the LLM model to be used for this agent
llm = ChatNVIDIA(
    base_url="http://nemotron:8000/v1",
    model=LLM_MODEL,
    temperature=0.6,
    top_p=0.95,
    max_tokens=8192
)
```

</details>

<!-- fold:break -->

## Test the Results

use langgraph cli, check in playground

<!-- fold:break -->

## Keep Going!

encourage user to continue by migrating the reranking and embedding models
give links to the rerank and embedding build pages for help
