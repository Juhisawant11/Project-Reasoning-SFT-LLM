# Reasoning SFT Evaluation Results

## Evaluation Configuration

- Base model: Qwen/Qwen2.5-3B-Instruct
- Temperature: 0.6
- Top-p: 0.95
- Samples per question: 8
- Maximum generation tokens: 32768
- System prompt: Please reason step by step, and put your final answer within \boxed{}.

## Verified Baseline Results

| Benchmark | Accuracy (Pass@8) | Pass@1 |
|---|---:|---:|
| AMC 2023 | 0.7000 | 0.4188 |

The AMC baseline evaluation completed successfully on October 19, 2026.

## Pending Evaluations

- Remaining baseline benchmarks: pending ARC GPU availability.
- Random15K fine-tuned model: evaluation jobs submitted.
- Advanced15K fine-tuned model: training queued; evaluation depends on training and model merging.

## Computing Constraints

Evaluation jobs experienced extended queue delays on Virginia Tech ARC clusters.
Initial Random15K evaluation attempts failed because the FlashInfer JIT compiler
could not locate the `ninja` executable in the batch job environment.
The evaluation script was updated to include the reasoning-eval environment
in PATH. Successful execution after this fix has not yet been verified.
