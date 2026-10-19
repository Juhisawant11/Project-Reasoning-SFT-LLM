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
