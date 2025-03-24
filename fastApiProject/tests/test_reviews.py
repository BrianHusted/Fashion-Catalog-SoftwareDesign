import pytest
from httpx import AsyncClient
from fastapi import status
from fastApiProject import app  # Import your FastAPI app

@pytest.mark.asyncio  #Asynchronous function
async def test_add_review():
    """ Test adding a review (should fail initially - Red Phase) """
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post("/reviews/", json={
            "product_id": 1,
            "user_id": 1,
            "rating": 5,
            "comment": "Very nice item"
        })
    assert response.status_code == status.HTTP_404_NOT_FOUND  # Expect failure since no endpoint exists


@pytest.mark.asyncio
async def test_get_reviews():

    """ Test fetching reviews for a product (should fail initially) """
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/reviews/1")  # Fetch reviews for product_id=1
    assert response.status_code == status.HTTP_404_NOT_FOUND  # Expect failure since no endpoint exists