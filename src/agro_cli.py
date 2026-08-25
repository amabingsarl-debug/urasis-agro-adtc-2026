#!/usr/bin/env python3
"""Small dependency-free offline RAG demonstrator for Urasis Agro."""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import subprocess
import sys
import unicodedata
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORPUS = ROOT / "corpus" / "agriculture_sw_fr.jsonl"
MODEL = ROOT / "model" / "urasis-agro-qwen2.5-3b-q4_k_m.gguf"
SYSTEM_PROMPT = ROOT / "system_prompt.txt"


def normalize(text: str) -> str:
    text = unicodedata.normalize("NFKD", text.lower())
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return re.sub(r"[^a-z0-9\u0600-\u06ff]+", " ", text).strip()


def tokens(text: str) -> list[str]:
    return [word for word in normalize(text).split() if len(word) > 2]


def load_corpus() -> list[dict]:
    documents = []
    with CORPUS.open("r", encoding="utf-8") as handle:
        for line in handle:
            if line.strip():
                documents.append(json.loads(line))
    return documents


def retrieve(query: str, documents: list[dict], limit: int = 4) -> list[dict]:
    query_terms = Counter(tokens(query))
    document_terms = [Counter(tokens(" ".join([d["title"], d["content"], " ".join(d["tags"])]))) for d in documents]
    document_frequency = Counter()
    for term_counts in document_terms:
        document_frequency.update(term_counts.keys())

    scored = []
    total = len(documents)
    for document, term_counts in zip(documents, document_terms):
        score = 0.0
        length = max(sum(term_counts.values()), 1)
        for term, query_count in query_terms.items():
            if term in term_counts:
                inverse_frequency = math.log((total + 1) / (document_frequency[term] + 0.5)) + 1
                score += query_count * inverse_frequency * (1 + math.log(term_counts[term])) / math.sqrt(length)
        if score:
            scored.append((score, document))
    scored.sort(key=lambda item: item[0], reverse=True)
    return [document for _, document in scored[:limit]]


def build_prompt(question: str, matches: list[dict]) -> str:
    if matches:
        context = "\n\n".join(
            f"[SOURCE {index}] {doc['title']}\n{doc['content']}\nReference: {doc['source']}"
            for index, doc in enumerate(matches, start=1)
        )
    else:
        context = "No sufficiently relevant local note was found. Be transparent about uncertainty."
    return f"""Use the local notes below only when they are relevant. They are decision support, not a substitute for field inspection. Do not claim that a note confirms a diagnosis.

LOCAL NOTES
{context}

FARMER QUESTION
{question}

Answer in the farmer's language and follow the required four-part agronomic format."""


def run_model(prompt: str) -> int:
    llama_cli = Path(os.environ.get("LLAMA_CLI", ROOT / ".tools/llama.cpp/build/bin/llama-cli"))
    if not llama_cli.exists():
        print("llama-cli not found. Run scripts/setup_ubuntu.sh first.", file=sys.stderr)
        return 2
    if not MODEL.exists():
        print("Model not found. Run download_model.sh first.", file=sys.stderr)
        return 2
    command = [
        str(llama_cli), "--model", str(MODEL),
        "--system-prompt-file", str(SYSTEM_PROMPT),
        "--prompt", prompt, "--single-turn", "--conversation",
        "--ctx-size", "4096", "--threads", os.environ.get("URASIS_THREADS", "4"),
        "--n-predict", "450", "--temp", "0.2", "--top-p", "0.9",
        "--flash-attn", "auto", "--no-display-prompt", "--color", "off",
    ]
    return subprocess.run(command, check=False).returncode


def main() -> int:
    parser = argparse.ArgumentParser(description="Urasis Agro offline agricultural assistant")
    parser.add_argument("question", nargs="*", help="Farmer question in Swahili, French or English")
    parser.add_argument("--show-sources", action="store_true", help="Print selected local notes before inference")
    args = parser.parse_args()
    question = " ".join(args.question).strip() or input("Swali / Question: ").strip()
    if not question:
        return 1
    matches = retrieve(question, load_corpus())
    if args.show_sources:
        for document in matches:
            print(f"- {document['id']}: {document['title']} ({document['source']})")
        print()
    return run_model(build_prompt(question, matches))


if __name__ == "__main__":
    raise SystemExit(main())
