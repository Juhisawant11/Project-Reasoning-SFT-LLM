#!/bin/bash
#SBATCH --job-name=merge_advanced15k
#SBATCH --partition=normal_q
#SBATCH --account=tml_2026
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=merge_advanced15k_%j.out
#SBATCH --error=merge_advanced15k_%j.err

module load Miniconda3

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate reasoning-sft

cd ~/Project-Reasoning-SFT-LLM/LLaMA-Factory

llamafactory-cli export merge_advanced15k.yaml
