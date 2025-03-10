from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import Column, Integer, String, ForeignKey, Float, DateTime, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
from pydantic import BaseModel
from passlib.context import CryptContext

# Database Setup
DATABASE_URL = "postgresql://bohdansynytskyi@localhost:5432/flexwear"  # Use your username that you used for creating the database
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
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True)

class Product(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(String)
    category_id = Column(Integer, ForeignKey("categories.id"))
    category = relationship("Category")

class ProductVariation(Base):
    __tablename__ = "product_variations"
    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    size = Column(String)
    color = Column(String)
    product = relationship("Product")

class UserPreference(Base):
    __tablename__ = "user_preferences"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
    category_id = Column(Integer, ForeignKey("categories.id"))
    preferred_size = Column(String)
    preferred_color = Column(String)

class Wishlist(Base):
    __tablename__ = "wishlist"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
    product_id = Column(Integer, ForeignKey("products.id"))
    product = relationship("Product")

class Review(Base):
    __tablename__ = "reviews"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String, ForeignKey("users.email"))  # Fix foreign key reference
    product_id = Column(Integer, ForeignKey("products.id"))
    rating = Column(Float)
    comment = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
    product = relationship("Product")

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

class ProductLog(Base):
    __tablename__ = "product_logs"
    id = Column(Integer, primary_key=True, index=True)
    admin_id = Column(Integer, ForeignKey("admins.id"))
    product_id = Column(Integer, ForeignKey("products.id"))
    action = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
    product = relationship("Product")

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
@app.get("/products/")
def read_products(db: Session = Depends(get_db)):
    return db.query(Product).all()

@app.post("/products/")
def create_product(name: str, description: str, category_id: int, db: Session = Depends(get_db)):
    new_product = Product(name=name, description=description, category_id=category_id)
    db.add(new_product)
    db.commit()
    db.refresh(new_product)
    return new_product

@app.get("/categories/")
def read_categories(db: Session = Depends(get_db)):
    return db.query(Category).all()

@app.get("/users/")
def read_users(db: Session = Depends(get_db)):  # Fix function name
    print("Users endpoint activated")
    return db.query(User).all()

@app.post("/categories/")
def create_category(name: str, db: Session = Depends(get_db)):
    new_category = Category(name=name)
    db.add(new_category)
    db.commit()
    db.refresh(new_category)
    return new_category


@app.post("/signup/")
def signup(user_data: SignUpRequest, db: Session = Depends(get_db)):
    # Check if user already exists
    existing_user = db.query(User).filter(User.email == user_data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Extract first and last name
    name_parts = user_data.full_name.split(" ", 1)
    first_name = name_parts[0]
    last_name = name_parts[1] if len(name_parts) > 1 else ""

    # Hash the password before storing
    # hashed_password = pwd_context.hash(user_data.password)

    # Create user object
    new_user = User(
        email=user_data.email,
        password_hash=user_data.password,
        first_name=first_name,
        last_name=last_name
    )

    # Add and commit the new user
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {"message": "User created successfully", "email": new_user.email}


@app.post("/login/")
def login(user_data: LogInRequest, db: Session = Depends(get_db)):
    # Find user by email
    user = db.query(User).filter(User.email == user_data.email).first()

    if not user or user.password_hash != user_data.password:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    return {"message": "Login successful!", "email": user.email}

@app.get("/wishlist/{user_id}")
def get_wishlist(user_id: str, db: Session = Depends(get_db)):  # Use str since user_email is the key
    return db.query(Wishlist).filter(Wishlist.user_email == user_id).all()

@app.post("/wishlist/")
def add_to_wishlist(user_email: str, product_id: int, db: Session = Depends(get_db)):  # Use str for email
    new_wishlist_item = Wishlist(user_email=user_email, product_id=product_id)
    db.add(new_wishlist_item)
    db.commit()
    db.refresh(new_wishlist_item)
    return new_wishlist_item
