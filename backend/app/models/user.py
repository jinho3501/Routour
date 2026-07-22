# 여기에 User 모델(테이블)을 직접 작성합니다.
from datetime import datetime
from sqlalchemy import Integer, String, DateTime, func, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from app.db.session import Base

class User(Base):
    __tablename__ = "users"

    uid : Mapped[str] = mapped_column(String(128),primary_key=True)
    email : Mapped[str] = mapped_column(String(255),nullable=False)
    display_name: Mapped[str] = mapped_column(String(100), default="")
    nickname: Mapped[str] = mapped_column(String(50), default="")
    points: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    last_login_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    photo_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    coupons_count: Mapped[int] = mapped_column(Integer, default=0)
    push_enabled: Mapped[bool] = mapped_column(Boolean, default=True)

