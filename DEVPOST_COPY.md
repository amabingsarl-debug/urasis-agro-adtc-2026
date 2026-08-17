# Devpost submission copy

## Project name

Urasis Agro — Offline Agricultural Intelligence in Kiswahili

## One-line description

A Swahili-first agricultural assistant that runs locally on an ordinary 8 GB laptop and gives cautious, practical guidance without Internet or API fees.

## Inspiration

African farmers should not lose access to useful AI because a connection is weak, an API credit is exhausted or the available interface does not speak their language. Urasis began as an interactive virtual-assistant platform. For ADTC, we concentrated that vision into an offline agricultural companion built for constrained hardware and real field conversations.

## What it does

Urasis Agro answers crop, soil, water, pest and post-harvest questions in Kiswahili, French and English. It asks for missing observations, separates possible causes from confirmed diagnoses, prioritizes affordable actions and explains when the user should contact an extension officer. A local knowledge retriever can add conservative agronomic notes without sending farm data to the cloud.

## How we built it

We use Qwen2.5-3B-Instruct in GGUF Q4_K_M format with `llama.cpp`. The 2.1 GB model is sized for an 8 GB laptop and runs CPU-first. The optional RAG demonstrator is written with the Python standard library, while the wider Urasis product demonstrates 3D agricultural avatars, voice and visual explanations.

## Challenges

The central trade-off was quality versus memory and speed. We selected a 3B Q4 model instead of a slower 7B model, constrained context to 4,096 tokens, and designed an explicit safety structure to reduce confident but unsupported agronomic advice. We also separated time-sensitive facts such as prices and weather from durable offline knowledge.

## Accomplishments

- Entire model inference works without cloud dependencies.
- Kiswahili is a real interaction language and supports the African Alpha claim.
- Model download is public, idempotent and SHA-256 verified.
- The product combines offline AI, local agricultural knowledge and accessible avatar interaction.

## What we learned

Local AI is not simply a cloud model copied onto a laptop. It requires deliberate choices about quantization, context size, uncertainty, knowledge freshness and user experience. In agriculture, asking the right follow-up question is often safer and more valuable than generating a long answer immediately.

## What's next

We will validate the knowledge packs with agronomists and farmer groups, add Dioula/Jula, Baoulé, Wolof, Hausa, Yoruba, Twi, Amharic and Zulu, and develop country-specific offline packs that remain small enough for shared and refurbished laptops.
