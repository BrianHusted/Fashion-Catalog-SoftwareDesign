from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime

app = FastAPI()

# Database connection
def get_db_connection():
    return psycopg2.connect(
        dbname="flexwear",
        user="",
        password="",  # Add your PostgreSQL password here
        host="localhost",
        port="5432"
    )

# Models
class Review(BaseModel):
    email: str
    product_id: int
    rating: int
    comment: Optional[str] = None

class ReviewResponse(BaseModel):
    review_id: int
    email: str
    product_id: int
    rating: int
    comment: Optional[str]
    created_at: datetime
    first_name: str
    last_name: str

# API Endpoints
@app.post("/api/reviews", response_model=ReviewResponse)
async def create_review(review: Review):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Check if user exists
            cur.execute("SELECT first_name, last_name FROM users WHERE email = %s", (review.email,))
            user = cur.fetchone()
            if not user:
                raise HTTPException(status_code=404, detail="User not found")

            # Check if product exists
            cur.execute("SELECT product_id FROM products WHERE product_id = %s", (review.product_id,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Product not found")

            # Insert review
            cur.execute("""
                INSERT INTO reviews (email, product_id, rating, comment)
                VALUES (%s, %s, %s, %s)
                RETURNING review_id, email, product_id, rating, comment, created_at
            """, (review.email, review.product_id, review.rating, review.comment))
            
            review_data = cur.fetchone()
            conn.commit()

            # Add user name to response
            review_data['first_name'] = user['first_name']
            review_data['last_name'] = user['last_name']
            
            return review_data

    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/reviews/{product_id}", response_model=List[ReviewResponse])
async def get_product_reviews(product_id: int):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Check if product exists
            cur.execute("SELECT product_id FROM products WHERE product_id = %s", (product_id,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Product not found")

            # Get reviews with user names
            cur.execute("""
                SELECT r.review_id, r.email, r.product_id, r.rating, r.comment, r.created_at,
                       u.first_name, u.last_name
                FROM reviews r
                JOIN users u ON r.email = u.email
                WHERE r.product_id = %s
                ORDER BY r.created_at DESC
            """, (product_id,))
            
            reviews = cur.fetchall()
            return reviews

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()

@app.get("/api/reviews/stats/{product_id}")
async def get_product_review_stats(product_id: int):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Check if product exists
            cur.execute("SELECT product_id FROM products WHERE product_id = %s", (product_id,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Product not found")

            # Get review statistics
            cur.execute("""
                SELECT 
                    COUNT(*) as total_reviews,
                    AVG(rating) as average_rating,
                    COUNT(CASE WHEN rating = 5 THEN 1 END) as five_star,
                    COUNT(CASE WHEN rating = 4 THEN 1 END) as four_star,
                    COUNT(CASE WHEN rating = 3 THEN 1 END) as three_star,
                    COUNT(CASE WHEN rating = 2 THEN 1 END) as two_star,
                    COUNT(CASE WHEN rating = 1 THEN 1 END) as one_star
                FROM reviews
                WHERE product_id = %s
            """, (product_id,))
            
            stats = cur.fetchone()
            return stats

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close() 