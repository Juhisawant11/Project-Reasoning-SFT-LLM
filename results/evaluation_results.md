# Reasoning SFT Evaluation Results

## Evaluation Configuration

- Base model: Qwen/Qwen2.5-3B-Instruct
- Temperature: 0.6
- Top-p: 0.95
- Samples per question: 8
- Maximum generation tokens: 32768
- System prompt: Please reason step by step, and put your final answer within \boxed{}.

## Baseline Evaluation Results

The following results were provided by a team member for the original
Qwen/Qwen2.5-3B-Instruct model. The AMC result was independently
verified using the local ARC evaluation log on October 19, 2026.

Evaluation uses temperature 0.6, top-p 0.95, eight samples per
question, and a maximum generation length of 32768 tokens.

| Benchmark | Problems | Acc (Pass@8) | Pass@1 | Fall 2025 Reference (Pass@8) |
|---|---:|---:|---:|---:|
| AIME 2024 | 30 | 0.1667 | 0.0833 | 0.200 |
| MATH-500 | 500 | 0.8640 | 0.6570 | 0.844 |
| CN Math 2024 | 30 | 0.3667 | 0.1167 | 0.233 |
| Kaoyan | 199 | 0.5377 | 0.2180 | 0.513 |
| AMC 2023 | 40 | 0.7000 | 0.4188 | 0.700 |
| Minerva Math | 272 | 0.4743 | 0.3015 | 0.338 |
| OlympiadBench | 675 | 0.4993 | 0.2811 | 0.495 |
| GPQA-Diamond | 198 | 0.7323 | 0.3037 | 0.742 |
| **Mean (8 benchmarks)** | — | **0.5426** | **0.2975** | **0.508** |

### Baseline Analysis

The team-reported baseline achieved a mean Pass@8 accuracy of
0.5426 and a mean Pass@1 score of 0.2975.

Performance varied substantially across benchmarks. MATH-500
achieved the highest Pass@8 accuracy (0.8640), while AIME 2024
achieved the lowest (0.1667).

The mean Pass@8 accuracy was 0.0346 higher than the Fall 2025
reference baseline (0.508). These results are not necessarily
directly comparable because the evaluation environments may differ.

The full set of baseline results was supplied by a team member;
only AMC was independently reproduced in the local ARC logs.

## Pending Evaluations

- Team-reported baseline results are available for all eight benchmarks; local reproduction of seven benchmarks remains pending.
- Random15K fine-tuned model: evaluation jobs submitted.
- Advanced15K fine-tuned model: training queued; evaluation depends on training and model merging.

## Computing Constraints

Evaluation jobs experienced extended queue delays on Virginia Tech ARC clusters.
Initial Random15K evaluation attempts failed because the FlashInfer JIT compiler
could not locate the `ninja` executable in the batch job environment.
The evaluation script was updated to include the reasoning-eval environment
in PATH. Successful execution after this fix has not yet been verified.

## Advanced Data Selection Strategy

We investigated reasoning-length-based data curation as an alternative
to random sampling. Both datasets contain 15,000 examples drawn from
the AceReason-1.1-SFT 100K subset.

The Advanced15K dataset contains a greater concentration of medium-to-long
reasoning traces than Random15K.

| Metric | Random15K | Advanced15K |
|---|---:|---:|
| Average solution length (characters) | 22,661.96 | 27,702.37 |
| Median solution length (characters) | 19,327 | 26,378 |
| Solutions >= 10,000 characters | 77.05% | 100.00% |
| Solutions >= 20,000 characters | 48.28% | 77.25% |
| Solutions >= 30,000 characters | 28.84% | 37.57% |
| Solutions >= 40,000 characters | 15.33% | 10.35% |

These observed differences are consistent with reasoning-length-oriented
data selection. The exact selection algorithm has not been independently
verified. Solution length is used as a proxy for reasoning complexity,
not as a direct measure of correctness or difficulty.

## Fine-Tuning Hyperparameters

Both experiments use the same configuration, except for the training
dataset and checkpoint output directory.

| Parameter | Value |
|---|---|
| Base model | Qwen/Qwen2.5-3B-Instruct |
| Training method | LoRA supervised fine-tuning |
| Dataset size | 15,000 examples |
| Epochs | 2 |
| Learning rate | 0.0002 |
| LoRA rank | 8 |
| LoRA alpha | 16 |
| LoRA target | All supported linear modules |
| Per-device batch size | 2 |
| Gradient accumulation steps | 8 |
| Effective batch size | 16 (single GPU) |
| Sequence cutoff | 2048 tokens |
| Precision | BF16 |
| Learning rate scheduler | Cosine |
| Warmup ratio | 0.1 |

## Comparison and Analysis

The baseline AMC evaluation achieved an accuracy (Pass@8) of 0.7000
and Pass@1 of 0.4188.

Random15K fine-tuning completed successfully. However, its evaluation
results are not yet available because of GPU scheduling delays and
initial evaluation environment errors.

Advanced15K training remains queued on ARC.

Consequently, the available results do not yet establish whether
reasoning-length-based curation improves benchmark performance
relative to random sampling or the original model.

## Advanced15K Selection Methodology

Advanced15K was generated using difficulty-aware sampling based on
solution length.

For each of the 100,000 AceReason-1.1-SFT examples, solution length
was measured using the number of whitespace-separated words.

Examples were sorted by solution length, and those ranked between
the 40th and 90th percentiles were retained.

From this 50,000-example candidate pool, 15,000 examples were
randomly sampled using seed 42.

This strategy was designed to prioritize substantial reasoning
traces while avoiding extremely short and excessively long solutions.

The implementation is available at
`scripts/create_advanced15k.py`.

The method does not directly measure problem difficulty or
solution correctness. Its effectiveness must be evaluated against
the Random15K baseline.
