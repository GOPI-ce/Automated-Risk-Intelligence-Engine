# Testing Guide for ARIE

This guide provides different methods to test the Automated Risk Intelligence Engine (ARIE), from the user interface to the underlying API and data pipeline.

## 1. Testing via Streamlit Dashboard (GUI)
**URL**: [http://localhost:8501](http://localhost:8501)

The dashboard allows you to interactively input trade details and get a risk prediction.

### **Scenario A: High Risk Trade**
Try entering these values to simulate a risky trade:
*   **Amount**: `500000` (High amount)
*   **Price**: `100`
*   **Quantity**: `5000`
*   **Counterparty**: `CP_99`
*   **Ticket Text**: `Settlement fails; collateral shortfall flagged for CP_99.`
*   **Expected Result**: High Risk Score (closer to 1.0)

### **Scenario B: Low Risk Trade**
Try these values for a standard trade:
*   **Amount**: `1000`
*   **Price**: `100`
*   **Quantity**: `10`
*   **Counterparty**: `CP_1`
*   **Ticket Text**: `Routine query for trade T12345.`
*   **Expected Result**: Low Risk Score (closer to 0.0)

---

## 2. Testing via API (Swagger UI)
**URL**: [http://localhost:8000/docs](http://localhost:8000/docs)

FastAPI provides an automatic interactive documentation page where you can test endpoints directly in the browser.

1.  Open the URL above.
2.  Click on the `POST /predict` endpoint.
3.  Click **Try it out**.
4.  Paste the following JSON into the Request body:
    ```json
    {
      "amount": 500000,
      "price": 100,
      "quantity": 5000,
      "counterparty": "CP_99",
      "ticket_text": "Settlement fails; collateral shortfall flagged.",
      "latency_ms": 200,
      "processing_delay": 5
    }
    ```
5.  Click **Execute**.
6.  Check the **Response body** for the `risk_score`.

---

## 3. Testing via Command Line (cURL)
You can test the API from your terminal using `curl`.

**High Risk Request:**
```bash
curl -X 'POST' \
  'http://localhost:8000/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "amount": 500000,
  "price": 100,
  "quantity": 5000,
  "counterparty": "CP_99",
  "ticket_text": "Settlement fails; collateral shortfall flagged.",
  "latency_ms": 200,
  "processing_delay": 5
}'
```

---

## 4. Testing via Python Script
You can create a small script to batch test multiple scenarios.

Create a file named `test_scenarios.py`:
```python
import requests
import json

url = "http://localhost:8000/predict"

scenarios = [
    {
        "name": "High Risk",
        "data": {
            "amount": 500000,
            "price": 100,
            "quantity": 5000,
            "counterparty": "CP_99",
            "ticket_text": "Settlement fails; collateral shortfall flagged.",
            "latency_ms": 200,
            "processing_delay": 5
        }
    },
    {
        "name": "Low Risk",
        "data": {
            "amount": 1000,
            "price": 100,
            "quantity": 10,
            "counterparty": "CP_1",
            "ticket_text": "Routine query for trade.",
            "latency_ms": 10,
            "processing_delay": 1
        }
    }
]

for s in scenarios:
    response = requests.post(url, json=s["data"])
    if response.status_code == 200:
        print(f"Scenario: {s['name']} | Risk Score: {response.json()['risk_score']:.4f}")
    else:
        print(f"Scenario: {s['name']} | Error: {response.text}")
```
Run it with: `python test_scenarios.py`

---

## 5. Testing the Data Pipeline
To ensure the data generation and training pipeline works, you can run the ETL script manually.

**Generate Data:**
```bash
python src/etl/etl_pipeline.py
```
*Check `data/processed/` to see if the parquet file was updated.*
