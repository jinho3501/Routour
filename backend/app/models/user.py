# 여기에 User 모델(테이블)을 직접 작성합니다.
from datetime import datetime
from sqlalchemy import Integer, String, DateTime, func, Boolean
from sqlalchemy.orm import Mapped, mapped_column
from app.db.session import Base
import sqlalchemy as sa
from sqlalchemy import String,Integer, DateTime,func,Boolean

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

    # 약관 동의
    tos_agreed: Mapped[bool] = mapped_column(Boolean, default=False, server_default=sa.false())
    tos_version: Mapped[str | None] = mapped_column(String(20), nullable=True)
    tos_agreed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    
    privacy_agreed: Mapped[bool] = mapped_column(Boolean, default=False, server_default=sa.false())
    privacy_version: Mapped[str | None] = mapped_column(String(20), nullable=True)
    privacy_agreed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    marketing_agreed: Mapped[bool] = mapped_column(Boolean, default=False, server_default=sa.false())
    marketing_version: Mapped[str | None] = mapped_column(String(20), nullable=True)
    marketing_agreed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
