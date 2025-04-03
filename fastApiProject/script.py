from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import uvicorn
import os
from db_classes import *
from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy import create_engine, func, case
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from fastapi.middleware.cors import CORSMiddleware
import shutil
from datetime import datetime

from pydantic import BaseModel
from passlib.context import CryptContext
from typing import Optional, List

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

@app.get("/product", response_class=HTMLResponse)
def serve_product_page():
    """Serves the product.html file."""
    product_html = os.path.join(PAGES_DIR, "product.html")
    with open(product_html, "r", encoding="utf-8") as file:
        content = file.read()
    return HTMLResponse(content=content)

@app.get("/home", response_class=HTMLResponse)
def serve_home_page():
    """Serves the home.html file."""
    home_html = os.path.join(PAGES_DIR, "home.html")
    with open(home_html, "r", encoding="utf-8") as file:
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
    category_name: str
    picture_url: Optional[str]
    variations: list = []

    class Config:
        orm_mode = True


@app.get("/products/", response_model=list[ProductResponse])
def read_products(db: Session = Depends(get_db)):
    """Get all products with their variations."""
    products = db.query(Product).join(Product.category).all()
    
    return [
        ProductResponse(
            product_id=p.product_id,
            name=p.name,
            description=p.description,
            category_name=p.category.name,
            picture_url=p.picture_url,
            variations=[
                {
                    "variation_id": v.variation_id,
                    "size": v.size,
                    "color": v.color
                }
                for v in p.variations
            ]
        ) for p in products
    ]

@app.get("/products/")
def get_products(db: Session = Depends(get_db)):
    """Get all products with their category names."""
    products = db.query(Product).all()
    return [
        {
            "product_id": p.product_id,
            "name": p.name,
            "description": p.description,
            "category_name": p.category.name,
            "picture_url": p.picture_url  # Return the filename directly
        }
        for p in products
    ]

@app.get("/products/{product_id}")
def get_product(product_id: int, db: Session = Depends(get_db)):
    """Get a specific product by ID with its variations."""
    product = db.query(Product).filter(Product.product_id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    return {
        "product_id": product.product_id,
        "name": product.name,
        "description": product.description,
        "category_name": product.category.name,
        "picture_url": product.picture_url,
        "variations": [
            {
                "variation_id": v.variation_id,
                "size": v.size,
                "color": v.color
            }
            for v in product.variations
        ]
    }

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
async def create_product(
    name: str = Form(...),
    description: str = Form(...),
    category_id: int = Form(...),
    picture: UploadFile = File(None),
    db: Session = Depends(get_db)
):
    try:
        # Check if category exists
        category = db.query(Category).filter(Category.category_id == category_id).first()
        if not category:
            raise HTTPException(status_code=404, detail=f"Category with ID {category_id} not found")

        # Create the product first
        new_product = Product(name=name, description=description, category_id=category_id)
        db.add(new_product)
        db.commit()
        db.refresh(new_product)

        # Handle image upload if provided
        if picture:
            # Create a unique filename
            file_extension = os.path.splitext(picture.filename)[1]
            filename = f"product_{new_product.product_id}{file_extension}"
            
            # Define the correct path for saving the image
            products_dir = os.path.join(STATIC_DIR, "assets", "products")
            os.makedirs(products_dir, exist_ok=True)
            file_path = os.path.join(products_dir, filename)

            # Save the file
            with open(file_path, "wb") as buffer:
                shutil.copyfileobj(picture.file, buffer)

            # Update the product with the image URL
            new_product.picture_url = f"assets/products/{filename}"
            db.commit()
            db.refresh(new_product)

        return new_product
    except Exception as e:
        db.rollback()  # Rollback the transaction if anything fails
        raise HTTPException(status_code=500, detail=str(e))

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

@app.get("/wishlist/{user_email}")
def get_wishlist(user_email: str, db: Session = Depends(get_db)):
    """Get all items in a user's wishlist with product details."""
    try:
        # First check if user exists
        user = db.query(User).filter(User.email == user_email).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        wishlist_items = db.query(Wishlist).join(Product).join(Category).filter(Wishlist.email == user_email).all()
        return [
            {
                "wishlist_id": item.wishlist_id,
                "email": item.email,
                "product_id": item.product_id,
                "added_at": item.added_at,
                "product": {
                    "product_id": item.product.product_id,
                    "name": item.product.name,
                    "description": item.product.description,
                    "picture_url": item.product.picture_url,
                    "category_name": item.product.category.name
                }
            }
            for item in wishlist_items
        ]
    except Exception as e:
        print(f"Error getting wishlist: {str(e)}")  # Debug log
        raise HTTPException(status_code=500, detail=str(e))

class WishlistItem(BaseModel):
    email: str
    product_id: int

@app.post("/wishlist/")
def add_to_wishlist(item: WishlistItem, db: Session = Depends(get_db)):
    """Add a product to a user's wishlist."""
    try:
        # Check if user exists
        user = db.query(User).filter(User.email == item.email).first()
        if not user:
            print(f"User not found: {item.email}")  # Debug log
            raise HTTPException(status_code=404, detail="User not found")
        
        # Check if product exists
        product = db.query(Product).filter(Product.product_id == item.product_id).first()
        if not product:
            print(f"Product not found: {item.product_id}")  # Debug log
            raise HTTPException(status_code=404, detail="Product not found")
        
        # Check if item is already in wishlist
        existing_item = db.query(Wishlist).filter(
            Wishlist.email == item.email,
            Wishlist.product_id == item.product_id
        ).first()
        
        if existing_item:
            print(f"Item already in wishlist: {item.email}, {item.product_id}")  # Debug log
            raise HTTPException(status_code=400, detail="Item already in wishlist")
        
        # Add to wishlist
        new_wishlist_item = Wishlist(email=item.email, product_id=item.product_id)
        db.add(new_wishlist_item)
        db.commit()
        db.refresh(new_wishlist_item)
        print(f"Successfully added to wishlist: {item.email}, {item.product_id}")  # Debug log
        return new_wishlist_item
    except Exception as e:
        db.rollback()  # Rollback the transaction if anything fails
        print(f"Error adding to wishlist: {str(e)}")  # Debug log
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/wishlist/{user_email}/{product_id}")
def remove_from_wishlist(user_email: str, product_id: int, db: Session = Depends(get_db)):
    """Remove a product from a user's wishlist."""
    try:
        wishlist_item = db.query(Wishlist).filter(
            Wishlist.email == user_email,
            Wishlist.product_id == product_id
        ).first()
        
        if not wishlist_item:
            raise HTTPException(status_code=404, detail="Item not found in wishlist")
        
        db.delete(wishlist_item)
        db.commit()
        return {"message": "Item removed from wishlist"}
    except Exception as e:
        db.rollback()
        print(f"Error removing from wishlist: {str(e)}")  # Debug log
        raise HTTPException(status_code=500, detail=str(e))

class AccountUpdateRequest(BaseModel):
    email: str  # Add email field
    first_name: str
    last_name: str
    birthdate: str
    current_password: str
    new_password: Optional[str] = None

@app.post("/update_account/")
def update_account(update_data: AccountUpdateRequest, db: Session = Depends(get_db)):
    """Update user account information."""
    try:
        # Find the user by email
        user = db.query(User).filter(User.email == update_data.email).first()
        if not user:
            print(f"User not found: {update_data.email}")  # Debug log
            raise HTTPException(status_code=404, detail="User not found")

        # Verify current password
        if user.password_hash != update_data.current_password:
            print("Current password verification failed")  # Debug log
            raise HTTPException(status_code=401, detail="Current password is incorrect")

        # Convert birthdate string to datetime
        try:
            birthdate = datetime.strptime(update_data.birthdate, "%Y-%m-%d")
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid birthdate format. Use YYYY-MM-DD")

        # Update user information
        user.first_name = update_data.first_name
        user.last_name = update_data.last_name
        user.birthdate = birthdate
        
        # Update password if new one is provided
        if update_data.new_password:
            user.password_hash = update_data.new_password

        db.commit()
        db.refresh(user)
        print(f"Account updated successfully for user: {user.email}")  # Debug log

        return {
            "message": "Account updated successfully",
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "birthdate": user.birthdate.strftime("%Y-%m-%d")
        }
    except Exception as e:
        db.rollback()
        print(f"Error updating account: {str(e)}")  # Debug log
        raise HTTPException(status_code=500, detail=str(e))

# Add endpoint to create product variations
class ProductVariationCreate(BaseModel):
    product_id: int
    size: str
    color: str

@app.post("/products/{product_id}/variations/")
def create_product_variation(
    product_id: int,
    variation: ProductVariationCreate,
    db: Session = Depends(get_db)
):
    """Add a variation to a product."""
    # Check if product exists
    product = db.query(Product).filter(Product.product_id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Create new variation
    new_variation = ProductVariation(
        product_id=product_id,
        size=variation.size,
        color=variation.color
    )
    
    try:
        db.add(new_variation)
        db.commit()
        db.refresh(new_variation)
        return new_variation
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/products/{product_id}/sample-variations")
def add_sample_variations(product_id: int, db: Session = Depends(get_db)):
    """Add sample variations to a product for testing."""
    # Check if product exists
    product = db.query(Product).filter(Product.product_id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Sample sizes and colors
    sizes = ["S", "M", "L", "XL"]
    colors = ["Black", "White", "Navy", "Grey"]

    variations = []
    for size in sizes:
        for color in colors:
            # Check if variation already exists
            existing = db.query(ProductVariation).filter(
                ProductVariation.product_id == product_id,
                ProductVariation.size == size,
                ProductVariation.color == color
            ).first()
            
            if not existing:
                variation = ProductVariation(
                    product_id=product_id,
                    size=size,
                    color=color
                )
                db.add(variation)
                variations.append(variation)

    try:
        db.commit()
        return {"message": f"Added {len(variations)} variations to product {product_id}"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/reviews", response_model=ReviewResponse)
def create_review(review: ReviewCreate, db: Session = Depends(get_db)):
    """Create a new review for a product."""
    # Check if user exists
    user = db.query(User).filter(User.email == review.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Check if product exists
    product = db.query(Product).filter(Product.product_id == review.product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Create new review
    new_review = Review(
        email=review.email,
        product_id=review.product_id,
        rating=review.rating,
        comment=review.comment
    )
    
    db.add(new_review)
    db.commit()
    db.refresh(new_review)

    # Get user's name for response
    return {
        "review_id": new_review.review_id,
        "email": new_review.email,
        "product_id": new_review.product_id,
        "rating": new_review.rating,
        "comment": new_review.comment,
        "created_at": new_review.created_at,
        "first_name": user.first_name,
        "last_name": user.last_name
    }

@app.get("/api/reviews/{product_id}", response_model=List[ReviewResponse])
def get_product_reviews(product_id: int, db: Session = Depends(get_db)):
    """Get all reviews for a specific product."""
    # Check if product exists
    product = db.query(Product).filter(Product.product_id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Get reviews with user information
    reviews = db.query(Review, User).join(User).filter(Review.product_id == product_id).order_by(Review.created_at.desc()).all()
    
    return [
        {
            "review_id": review.Review.review_id,
            "email": review.Review.email,
            "product_id": review.Review.product_id,
            "rating": review.Review.rating,
            "comment": review.Review.comment,
            "created_at": review.Review.created_at,
            "first_name": review.User.first_name,
            "last_name": review.User.last_name
        }
        for review in reviews
    ]

@app.get("/api/reviews/stats/{product_id}")
def get_product_review_stats(product_id: int, db: Session = Depends(get_db)):
    """Get review statistics for a specific product."""
    # Check if product exists
    product = db.query(Product).filter(Product.product_id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Get review statistics
    stats = db.query(
        func.count(Review.review_id).label('total_reviews'),
        func.avg(Review.rating).label('average_rating'),
        func.count(case((Review.rating == 5, 1))).label('five_star'),
        func.count(case((Review.rating == 4, 1))).label('four_star'),
        func.count(case((Review.rating == 3, 1))).label('three_star'),
        func.count(case((Review.rating == 2, 1))).label('two_star'),
        func.count(case((Review.rating == 1, 1))).label('one_star')
    ).filter(Review.product_id == product_id).first()

    return {
        "total_reviews": stats.total_reviews or 0,
        "average_rating": float(stats.average_rating) if stats.average_rating else 0,
        "five_star": stats.five_star or 0,
        "four_star": stats.four_star or 0,
        "three_star": stats.three_star or 0,
        "two_star": stats.two_star or 0,
        "one_star": stats.one_star or 0
    }

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)

