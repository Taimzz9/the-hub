# Installing Ollama and Choosing Business Models

## Install Ollama

**Windows / Mac**
Download the installer from [ollama.com/download](https://ollama.com/download) and run it. That's it, no config needed.

**Linux**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Once installed, check it's running:
```bash
ollama --version
```

Pull and run a model with:
```bash
ollama run <model name>
```

That downloads the model on first run, then drops you into a chat prompt.

## Three Models Worth Using for Business Work

**1. Llama 3.1 8B**
```bash
ollama run llama3.1:8b
```
Solid general purpose model. Good balance of speed and quality for drafting emails, summarizing documents, answering internal questions. Runs fine on a decent laptop, doesn't need a beefy GPU. This is the one to default to if you just need "a good assistant" and don't want to think too hard about it.

**2. Qwen2.5 14B (or 32B if you have the hardware)**
```bash
ollama run qwen2.5:14b
```
Punches above its size, especially on reasoning and coding tasks. Given you're already exploring Qwen models locally, this is a natural fit. The 32B version is noticeably better if your workstation has the VRAM for it (24GB+ recommended), but 14B is a good starting point.

**3. Mistral Small (22B) or Mistral Nemo (12B)**
```bash
ollama run mistral-small
```
Good at structured business writing, i.e. reports, policy documents, that kind of thing. Nemo is the lighter option if hardware is a constraint.

## Realistic Notes

- Hardware matters more than model choice. An 8B model on a decent GPU will outperform a 32B model that's swapping to disk because it doesn't fit in VRAM. Check your RAM/VRAM before picking a model size.
- None of these will match Claude on complex reasoning or long context tasks. The point of running local models is data control and offline use, not raw capability. Don't expect parity.
- If your actual bottleneck is "which model is smartest," that's the wrong question for a security policy scenario. The right question is "which model can I run reliably within the hardware I'm willing to allocate, that's good enough for the task." Worth deciding that before you spend time benchmarking three models against each other.
