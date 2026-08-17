# Urasis Agro: Swahili-first offline agricultural assistance

## 1. Problem and African context

Many smallholder farmers and agricultural extension workers operate with intermittent connectivity, limited budgets and shared or entry-level computers. Cloud AI can be useful, but its recurring API cost and dependence on a stable connection make it unreliable at the moment advice is needed. Language is a second barrier: an answer that is technically correct but available only in formal English is not always actionable for a farmer who normally communicates in Kiswahili.

Urasis Agro is an offline agricultural assistant designed for the laptop Africa already has. It gives practical, cautious guidance in Kiswahili, French or English. It helps the user structure field observations, prioritize low-cost actions, reduce unsafe pesticide use and recognise when a local extension officer, veterinarian or other qualified professional is needed.

The current prototype focuses on crop observation, integrated pest management, soil and water stewardship, post-harvest handling and the responsible handling of time-sensitive information. It does not claim to replace field inspection. Prices, weather, outbreaks and national pesticide registrations are explicitly treated as information that may become stale offline.

## 2. Technical design

### Base model and runtime

The submission uses Qwen2.5-3B-Instruct, quantized by the Qwen team as GGUF Q4_K_M. The model file is approximately 2.1 GB and is downloaded from the public official Qwen Hugging Face repository. Inference uses `llama.cpp` only, in accordance with the ADTC runtime requirement. Qwen2.5-3B is provided under the Qwen Research License and is used here only for the non-commercial research and evaluation activities of the challenge. A commercial Urasis release would require separate permission from the model owner or a commercially compatible replacement model.

Qwen2.5 3B was selected as a balance between multilingual capability, instruction following, CPU throughput and memory use. A 7B model can offer stronger answers but creates substantially higher memory pressure and slower generation on the target four-core, 8 GB machine. Smaller models improve speed but showed a higher risk of shallow agronomic reasoning and weaker Kiswahili. Q4_K_M preserves more quality than aggressive Q2 quantization while remaining comfortably below the model-size budget.

### Agricultural safety behaviour

The Urasis Agro system behaviour uses a repeatable decision structure:

1. restate the observed situation and identify missing facts;
2. separate possible explanations from a confirmed diagnosis;
3. prioritize safe, affordable actions;
4. state what the farmer should monitor;
5. define when local professional help is needed;
6. ask one high-value follow-up question.

The assistant must not invent pesticide names or doses, current prices, weather, outbreak alerts or regulations. Pesticide guidance is limited to label compliance, local registration, protective equipment and escalation to an extension service.

### Cross-disciplinary pairing

The core pairing is local language modelling plus offline agricultural extension knowledge. A dependency-free lexical retriever selects relevant notes from a small bilingual corpus before local inference. This retrieval layer is load-bearing in the product demonstrator: it supplies traceable, conservative agronomic context without contacting an external service. The full Urasis interface adds a human-facing 3D agricultural avatar, voice interaction and visual explanations, helping users who have limited literacy or little familiarity with text chat.

The ADTC automated audit evaluates the GGUF inference process itself. The RAG and avatar layers are therefore documented and demonstrated separately; they are not included in model-only RAM or throughput claims.

## 3. Constraints and design decisions

| Constraint | Design response |
|---|---|
| 8 GB total RAM; 7 GB scoring ceiling | 3B Q4_K_M model; 4,096-token context; four CPU threads by default |
| Integrated graphics only | CPU-first `llama.cpp`; no GPU dependency |
| No network during evaluation | Public one-time model download followed by fully local inference |
| Limited and shared hardware | Shell-based reproducible setup for Ubuntu 22.04 |
| African-language accessibility | Kiswahili is a first-class response language, not a translated UI label |
| Risk of unsafe agricultural certainty | Observation-first prompt, uncertainty statements and escalation rules |
| Time-sensitive market/weather data | No invented live values; reconnect or consult a trusted local source |

The public Urasis application can use Gemini in online mode and WebLLM in local browser mode. Neither technology is used in the ADTC runtime. This separate competition package exists to prevent an accidental network dependency and to make the submission directly reproducible by the judges.

## 4. African language strategy

Kiswahili is the first African language in the competition build because it is widely used across East Africa and already supported by the Urasis language-selection and speech flows. The test prompt is written as a real farmer question, using familiar words and asking for safe, affordable action rather than abstract encyclopedic knowledge.

The longer-term vision is a reusable African-language layer covering Dioula/Jula, Baoulé, Wolof, Hausa, Yoruba, Twi, Amharic, Zulu and other languages in partnership with speakers, agronomists and local extension organisations. Expansion will follow four safeguards: community review, agricultural expert validation, terminology testing in real conversations, and published provenance for every local knowledge pack.

## 5. Reproducibility

On Ubuntu 22.04:

```bash
bash scripts/setup_ubuntu.sh
bash download_model.sh
bash scripts/profile.sh --skip-accuracy
```

`download_model.sh` is idempotent and verifies SHA-256 `626b4a6678b86442240e33df819e00132d3ba7dddfe1cdc4fbb18e0a9615c62d`. The expected model path exactly matches `metadata.json`.

The Ubuntu setup pins `llama.cpp` release `b10218`, compiles it with `LLAMA_CURL=OFF`, installs the profiler in an isolated Python 3.11 environment and records the exact checked-out commit in `.tools/llama.cpp.commit`. The profile script explicitly exposes the compiled `llama-bench` binary on `PATH`.

## 6. Benchmarks

Final numbers must come from the official ADTC profiler and must not be estimated. They will be inserted after running on the closest available Ubuntu 22.04 laptop profile.

| Metric | Target | Measured result |
|---|---:|---:|
| Peak RSS | below 7,168 MB | pending official profiler run |
| Generation throughput | at least 8 tokens/s; stretch target 15 tokens/s | pending |
| First-token latency | below 5 seconds | pending |
| Peak temperature | below 85 °C | pending |
| Offline inference network calls | 0 | pending verification |

No accuracy percentage is self-reported. Response quality will be judged using the two declared agricultural prompts and the organisers' hidden prompts.

## 7. Limitations and next steps

The current GGUF is a multilingual base model rather than a completed agriculture-specific fine-tune. The local corpus is intentionally compact and safety-oriented. Before field deployment, it needs country-level crop calendars, locally registered input information, validated disease protocols and user testing with farmers and extension workers. Future work will evaluate a small agriculture LoRA, broader Kiswahili agronomy data, offline speech recognition, and additional African languages without exceeding the target memory ceiling.
