from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import uvicorn
import os
from db_classes import *
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
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

# Password hashing setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

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


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)

