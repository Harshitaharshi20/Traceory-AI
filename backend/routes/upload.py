from fastapi import APIRouter
from pydantic import BaseModel
import uuid
from services.trajectory import generate_trajectory_params

router = APIRouter()

class UploadResponse(BaseModel):
    session_id: str
    video_url: str
    message: str
    trajectory_params: dict

@router.post("/", response_model=UploadResponse)
def upload_video():
    # Simulate a successful upload
    session_id = f"sess_{uuid.uuid4().hex[:8]}"
    params = generate_trajectory_params(session_id)
    return UploadResponse(
        session_id=session_id,
        video_url="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        message="Upload successful, AI embedding complete.",
        trajectory_params=params
    )
