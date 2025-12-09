# ARIE - Automated Risk Intelligence Engine

## Project Structure
```
ARIE/
├─ data/
│  ├─ raw/
│  ├─ processed/
├─ notebooks/
├─ src/
│  ├─ etl/
│  ├─ features/
│  ├─ models/
│  ├─ explain/
│  ├─ api/
│  ├─ dashboard/
│  ├─ utils/
├─ dags/
├─ requirements.txt
├─ Dockerfile
└─ experiments/
```

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Generate Synthetic Data:
   ```bash
   python src/etl/etl_pipeline.py
   ```
   Or:
   ```bash
   python -c "from src.utils.helpers import generate_multimodal_dataset; generate_multimodal_dataset(20000)"
   ```

## Running the Application

1. **Inference API (FastAPI)**:
   ```bash
   python -m uvicorn src.api.app:app --reload --port 8000
   ```

2. **Dashboard (Streamlit)**:
   ```bash
   python -m streamlit run src/dashboard/app_streamlit.py
   ```

## Docker

Build and run with Docker:
```bash
docker build -t arie .
docker run -p 8000:8000 -p 8501:8501 arie
```
