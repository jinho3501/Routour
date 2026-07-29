# 여기에 요청/응답 스키마(Pydantic)를 작성합니다.
from datetime import datetime
from pydantic import BaseModel

class UserCreate(BaseModel):
    email: str
    display_name: str = ""
    nickname: str = ""
    agree_tos: bool = False
    agree_privacy: bool = False
    agree_marketing: bool = False

class UserOut(BaseModel):
    uid: str
    email: str
    display_name: str
    nickname: str
    points: int
    coupons_count: int
    push_enabled: bool
    photo_url: str | None
    tos_agreed: bool
    privacy_agreed: bool
    marketing_agreed: bool
    created_at: datetime
    last_login_at: datetime | None

    model_config = {"from_attributes": True}


class UserUpdate(BaseModel):
    display_name: str | None = None
    nickname: str | None = None
    push_enabled: bool | None = None