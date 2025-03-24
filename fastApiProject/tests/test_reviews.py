from fastapi.testclient import TestClient
import os
import sys

from script import app

client = TestClient(app)


def test_get_signup_page():
    """Test that the signup page loads correctly."""
    response = client.get("/")
    # Check that the response status code is 200 (OK)
    assert response.status_code == 200
    # Optionally, check that the content includes expected elements from your signup page
    assert "<h2>Create Your Account</h2>" in response.text


def test_signup_form_submission():
    """Test submitting the signup form."""
    form_data = {
        "full_name": "Test User",
        "email": "test@test.com",
        "password": "secret"
    }
    response = client.post("/signup_request/", json=form_data)

    assert response.status_code == 200 or response.status_code == 400



def test_get_login_page():
    """Test that the login page loads correctly."""
    response = client.get("/login")
    assert response.status_code == 200
    # Check that the login page contains expected content, like a form or title
    assert "<h2>Login</h2>" in response.text


def test_incorrect_login_form_submission():
    """Test incorrect the login attempt submission."""
    form_data = {"email": "test@test.com", "password": "123"}
    response = client.post("/login_request/", json=form_data)
    # Check that the response status code is 401 (Unauthorized)
    assert response.status_code == 401


def test_login_form_submission():
    """Test submitting the login form."""
    form_data = {"email": "test@test.com", "password": "secret"}
    response = client.post("/login_request/", json=form_data)
    # Check that the response status code is 200 (OK)
    assert response.status_code == 200
    # Verify the returned JSON data
    json_data = response.json()
    assert json_data["message"] == "Login successful!"
    assert json_data["email"] == "test@test.com"
