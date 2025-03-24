from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import uvicorn
import os

from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from fastapi.middleware.cors import CORSMiddleware

from pydantic import BaseModel
from passlib.context import CryptContext
from typing import Optional

app = FastAPI()

# Define paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PAGES_DIR = os.path.join(BASE_DIR, "ProjectFrontend/pages")
STATIC_DIR = os.path.join(BASE_DIR, "ProjectFrontend/static")

# Mount the static files directory
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

@app.get("/", response_class=HTMLResponse)
def serve_signup_page():
    """Serves the signup.html file."""
    signup_html = os.path.join(PAGES_DIR, "signup.html")
    with open(signup_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)


@app.get("/login", response_class=HTMLResponse)
def serve_login_page():
    """Serves the login.html file."""
    login_html = os.path.join(PAGES_DIR, "login.html")
    with open(login_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)

@app.get("/index", response_class=HTMLResponse)
def serve_login_page():
    """Serves the login.html file."""
    login_html = os.path.join(PAGES_DIR, "index.html")
    with open(login_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)

@app.get("/account", response_class=HTMLResponse)
def serve_login_page():
    """Serves the login.html file."""
    login_html = os.path.join(PAGES_DIR, "account.html")
    with open(login_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)

@app.get("/wishlist", response_class=HTMLResponse)
def serve_login_page():
    """Serves the login.html file."""
    login_html = os.path.join(PAGES_DIR, "wishlist.html")
    with open(login_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)

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



@app.post("/signup_request/")
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


@app.post("/login_request/")
def login(user_data: LogInRequest, db: Session = Depends(get_db)):
    # Find user by email
    user = db.query(User).filter(User.email == user_data.email).first()

    if not user or user.password_hash != user_data.password:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    return {"message": "Login successful!", "email": user.email}


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)

