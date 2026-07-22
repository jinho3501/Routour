# 여기에 요청/응답 스키마(Pydantic)를 작성합니다.
from datetime import datetime
from pydantic import BaseModel

class UserCreate(BaseModel):
    uid: str
    email: str
    display_name: str
    nickname: str

class UserOut(BaseModel):
    uid: str
    email: str
    display_name: str
    nickname: str
    points: int
    coupons_count: int
    push_enabled: bool
    photo_url: str | None
    created_at: datetime
    last_login_at: datetime | None


class UserUpdate(BaseModel):
    display_name: str | None = None
    nickname: str | None = None
    push_enabled: bool | None = None

    model_config = {"from_attributes": True}