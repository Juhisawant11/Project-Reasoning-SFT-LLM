import json
import random
from pathlib import Path

source = Path("source_data/data/acereason11_100k.json")
destination = Path("LLaMA-Factory/data/advanced15k.json")

print("Loading dataset...")

with source.open("r", encoding="utf-8") as f:
    dataset = json.load(f)

# Difficulty proxy: solution length in words
for item in dataset:
    item["_solution_length"] = len(item["output"].split())

# Rank examples by solution length
dataset.sort(key=lambda x: x["_solution_length"])

# Retain examples from the 40th to 90th percentiles
start = int(len(dataset) * 0.40)
end = int(len(dataset) * 0.90)

candidates = dataset[start:end]

# Reproducible random sampling
random.seed(42)
selected = random.sample(candidates, 15000)

# Convert to LLaMA-Factory format
formatted = [
    {
        "instruction": item["instruction"],
        "input": item.get("input", ""),
        "output": item["output"],
        "system": item.get("system") or
                  "Please reason step by step, and put your final answer within \\boxed{}."
    }
    for item in selected
]

with destination.open("w", encoding="utf-8") as f:
    json.dump(formatted, f, ensure_ascii=False)

print("Advanced dataset created successfully!")
print("Total examples:", len(formatted))
print("Saved to:", destination)
