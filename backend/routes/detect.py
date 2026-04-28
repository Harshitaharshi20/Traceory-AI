from fastapi import APIRouter

router = APIRouter()

@router.get("/stats")
def get_stats():
    return {
        "monthly_breakdown": [12, 19, 15, 25, 22, 30],
        "attribution_accuracy": "94.5%",
        "detection_latency": "1.2s",
        "watermark_survival_rate": "99.1%"
    }
