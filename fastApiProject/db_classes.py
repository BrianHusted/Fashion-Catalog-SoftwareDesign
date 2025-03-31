from sqlalchemy import Column, Integer, String, ForeignKey, Float, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

Base = declarative_base()
class User(Base):
    __tablename__ = "users"
    email = Column(String, primary_key=True, index=True)
    password_hash = Column(String)
    first_name = Column(String)
    last_name = Column(String)
    birthdate = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)

class Category(Base):
    __tablename__ = "categories"
    category_id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True)

    products = relationship("Product", back_populates="category")

class Product(Base):
    __tablename__ = "products"
    product_id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(String)
    category_id = Column(Integer, ForeignKey("categories.category_id"))
    picture_url = Column(String, nullable=True)

    category = relationship("Category", back_populates="products")
    variations = relationship("ProductVariation", back_populates="product")

class ProductVariation(Base):
    __tablename__ = "product_variations"
    variation_id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.product_id", ondelete="CASCADE"))
    size = Column(String)
    color = Column(String)

    product = relationship("Product", back_populates="variations")

class UserPreference(Base):
    __tablename__ = "user_preferences"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
    category_id = Column(Integer, ForeignKey("categories.id"))
    preferred_size = Column(String)
    preferred_color = Column(String)

class Wishlist(Base):
    __tablename__ = "wishlist"
    wishlist_id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email", ondelete="CASCADE"))
    product_id = Column(Integer, ForeignKey("products.product_id", ondelete="CASCADE"))
    added_at = Column(DateTime, default=datetime.utcnow)
    product = relationship("Product")

# class Review(Base):
#     __tablename__ = "reviews"
#     id = Column(Integer, primary_key=True, index=True)
#     user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
#     product_id = Column(Integer, ForeignKey("products.id"))
#     rating = Column(Float)
#     comment = Column(String)
#     timestamp = Column(DateTime, default=datetime.utcnow)
#     product = relationship("Product")

class Admin(Base):
    __tablename__ = "admins"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True)
    password = Column(String)


class SignUpRequest(BaseModel):
    full_name: str
    email: str
    password: str

class LogInRequest(BaseModel):
    email: str
    password: str

class ProductResponse(BaseModel):
    product_id: int
    name: str
    description: Optional[str]
    category_name: str  # ✅ Return category name instead of category_id
    picture_url: Optional[str]

    class Config:
        orm_mode = True

# class ProductLog(Base):
#     __tablename__ = "product_logs"
#     id = Column(Integer, primary_key=True, index=True)
#     admin_id = Column(Integer, ForeignKey("admins.id"))
#     product_id = Column(Integer, ForeignKey("products.id"))
#     action = Column(String)
#     timestamp = Column(DateTime, default=datetime.utcnow)
#     product = relationship("Product")