from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import asyncio

from routes import upload, detect
from services.detection import start_detection_simulation

app = FastAPI(title="Traceory AI MVP", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(upload.router, prefix="/api/upload", tags=["Upload"])
app.include_router(detect.router, prefix="/api/detect", tags=["Detect"])

@app.on_event("startup")
async def startup_event():
    # Start the simulated detection loop in the background
    asyncio.create_task(start_detection_simulation())

@app.get("/")
def read_root():
    return {"message": "Traceory AI Backend Running"}
