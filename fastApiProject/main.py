from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import Column, Integer, String, ForeignKey, Float, DateTime, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
from pydantic import BaseModel
from passlib.context import CryptContext
from typing import Optional

# Database Setup
DATABASE_URL = "postgresql://localhost:5432/flexwear"  # Use your username that you used for creating the database
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Define Models
class User(Base):
    __tablename__ = "users"
    email = Column(String, primary_key=True, index=True)
    password_hash = Column(String)
    first_name = Column(String)
    last_name = Column(String)
    birthdate = Column(String)

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

class UserPreference(Base):
    __tablename__ = "user_preferences"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
    category_id = Column(Integer, ForeignKey("categories.id"))
    preferred_size = Column(String)
    preferred_color = Column(String)

# class Wishlist(Base):
#     __tablename__ = "wishlist"
#     id = Column(Integer, primary_key=True, index=True)
#     user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
#     product_id = Column(Integer, ForeignKey("products.id"))
#     product = relationship("Product")

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

# Password hashing setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Pydantic model for input validation
class SignUpRequest(BaseModel):
    full_name: str
    email: str
    password: str

class LogInRequest(BaseModel):
    email: str
    password: str

# class ProductLog(Base):
#     __tablename__ = "product_logs"
#     id = Column(Integer, primary_key=True, index=True)
#     admin_id = Column(Integer, ForeignKey("admins.id"))
#     product_id = Column(Integer, ForeignKey("products.id"))
#     action = Column(String)
#     timestamp = Column(DateTime, default=datetime.utcnow)
#     product = relationship("Product")

# Create Tables
Base.metadata.create_all(bind=engine)

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# FastAPI App
app = FastAPI()

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Routes
class ProductResponse(BaseModel):
    product_id: int
    name: str
    description: Optional[str]
    category_name: str  # ✅ Return category name instead of category_id
    picture_url: Optional[str]

    class Config:
        orm_mode = True


@app.get("/products/", response_model=list[ProductResponse])
def read_products(db: Session = Depends(get_db)):
    products = db.query(Product).join(Product.category).all()

    return [
        ProductResponse(
            product_id=p.product_id,
            name=p.name,
            description=p.description,
            category_name=p.category.name,  # ✅ Get category name from relationship
            picture_url=p.picture_url
        ) for p in products
    ]









# @app.get("/wishlist/{user_id}")
# def get_wishlist(user_id: str, db: Session = Depends(get_db)):  # Use str since user_email is the key
#     return db.query(Wishlist).filter(Wishlist.user_email == user_id).all()

# @app.post("/wishlist/")
# def add_to_wishlist(user_email: str, product_id: int, db: Session = Depends(get_db)):  # Use str for email
#     new_wishlist_item = Wishlist(user_email=user_email, product_id=product_id)
#     db.add(new_wishlist_item)
#     db.commit()
#     db.refresh(new_wishlist_item)
#     return new_wishlist_item
