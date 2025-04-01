# FlexWear Frontend – Fashion Catalog Software

This repository contains the frontend components for **FlexWear**, a digital fashion catalog platform. It enables user registration, login, wishlist management, and admin functionality including user management and product creation.

---

## 📁 File Structure

```
├── index.html          # Admin Panel Homepage
├── home.html           # Post-login landing page
├── account.html        # User account management page
├── wishlist.html       # Wishlist display page
├── signup.html         # User registration page
├── login.html          # Login interface
├── script.js           # JavaScript for logic handling
├── styles.css          # General styling
├── auth-styles.css     # Styling for auth-related pages
```

---

## 🔐 Login

**Overview:**  
Provides a secure interface for existing users to authenticate using email and password.

**Features:**
- HTML5 form with validation
- Responsive navbar
- Calls `login()` for backend communication

**How to Use:**
- Navigate to `login.html`
- Enter credentials
- Redirects on success or shows error on failure

---

## 📝 Signup

**Overview:**  
Collects user information to create a new account and integrates with backend API.

**Features:**
- Form validation
- Responsive layout
- Calls `signup()` for backend registration

**How to Use:**
- Go to `signup.html`
- Fill in full name, email, and password
- Submit to create account

---

## 👤 Account Page

**Overview:**  
Allows users to view and update personal details and create new products.

**Features:**
- Displays email, name, birthdate
- PUT request to update details
- Product creation form

**Functions:**
- `loadAccount()`
- `updateAccount()`
- `createProduct(event)`

---

## 🛒 Admin Panel

**Overview:**  
Available via `index.html`, this interface displays customers and manages cart data.

**Features:**
- Shows customer emails
- Manages localStorage-based cart
- Button to clear cart

---

## 💖 Wishlist

**Overview:**  
Displays saved wishlist items with options to remove them and navigate back to catalog.

**Features:**
- Uses `loadWishlist()` and `removeFromWishlist(productId)`
- Responsive design
- Mocked product data

---

## 🧠 Functionalities Summary

### Cart Management
- Uses `localStorage`
- Clear cart with button

### User Account Management
- Fetch and update account via API

### Product Creation
- Submit product form to backend

---

## 📦 Dependencies

- HTML5 form attributes
- JavaScript Fetch API
- LocalStorage for client-side persistence
- CSS for styling

---

## 🚀 How to Use

1. Open `index.html` for admin panel
2. Visit `account.html` to manage account and create products
3. Use `signup.html` to register
4. Login via `login.html`
5. Manage wishlist via `wishlist.html`

---

## 👩‍💻 Contributors

- **Mehrin**: Account, Home, Index, Product
- **Darab**: Login, Signup, Wishlist
