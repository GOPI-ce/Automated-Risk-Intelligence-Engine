#!/usr/bin/env bash
set -e
CMD=${1:-help}

if [ "$CMD" = "help" ]; then
  echo "Usage: ./run_all.sh [generate|train|api|dashboard]"
  exit 0
fi

if [ "$CMD" = "generate" ]; then
  python -c "from src.utils.helpers import generate_multimodal_dataset; generate_multimodal_dataset(20000)"
  exit 0
fi

if [ "$CMD" = "train" ]; then
  python -u scripts/train_pipeline.py
  exit 0
fi

if [ "$CMD" = "api" ]; then
  uvicorn src.api.app:app --reload --port 8000
  exit 0
fi

if [ "$CMD" = "dashboard" ]; then
  streamlit run src.dashboard.app_streamlit.py
  exit 0
fi

echo "Unknown command: $CMD"
exit 1
