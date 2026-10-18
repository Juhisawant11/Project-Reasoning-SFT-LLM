#!/bin/bash
#SBATCH --job-name=random15k_sft
#SBATCH --partition=h200_normal_q
#SBATCH --account=tml_2026
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --time=12:00:00
#SBATCH --output=random15k_%j.out
#SBATCH --error=random15k_%j.err

module load Miniconda3
module load CUDA/12.6.0

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate reasoning-sft

cd ~/Project-Reasoning-SFT-LLM/LLaMA-Factory

echo "GPU information:"
nvidia-smi

echo "Starting Random15k fine-tuning..."

llamafactory-cli train examples/train_lora/random15k.yaml

echo "Training finished."
