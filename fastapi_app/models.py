# Define the shape of data the API returns so FastAPI will know how to validate and serialize uploads and labels into JSON. 

from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class Label(BaseModel):
    id: int
    label: str 
    confidence: float 
    created_at: datetime

class Upload(BaseModel):
    id: int 
    filename: str 
    s3_key: str 
    uploaded_at: datetime
    labels: Optional[List[Label]] = []

class UploadSummary(BaseModel):
    id: int 
    filename: str 
    uploaded_at: datetime
    