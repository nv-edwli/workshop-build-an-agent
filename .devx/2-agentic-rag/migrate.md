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

### Let's go!

Light the fires with this Docker run command! This command will pull the NIM container image and model data files before hosting the model behind a local OpenAI compliant API. *Expect it to take a few minutes to stabilize.*

```bash
docker run -it --rm \
    --gpus all \
    --shm-size=16GB \
    -e NGC_API_KEY=$NVIDIA_API_KEY \
    -v nim-cache:/opt/nim/.cache \
    -u $(id -u) \
    -p 8000:8000 \
    nvcr.io/nim/nvidia/nvidia-nemotron-nano-9b-v2:latest
```

<!-- fold:break -->

## Test the NIM

As the NIM container is starting, the logs allow you to observe that it is:

1. Finding the most optimized profile for your hardware
2. Downloading the model files
3. Loading the model, and finally
4. Starting the model

<!-- fold:break -->

## Update the Code

change agentic_rag.py ro use local NIM

<!-- fold:break -->

## Test the Results

use langgraph cli, check in playground

<!-- fold:break -->

## Keep Going!

encourage user to continue by migrating the reranking and embedding models
give links to the rerank and embedding build pages for help
