const apiUrl = "http://127.0.0.1:8000";  // Change if needed

async function signup() { // Prevent page reload

    // Get form values
    const fullName = document.getElementById("fullName").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    // Send request to FastAPI backend
    try {
        const response = await fetch(`${apiUrl}/signup/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ full_name: fullName, email: email, password: password })
        });

        const data = await response.json();
        if (response.ok) {
            alert("Signup successful!");
            localStorage.setItem("userEmail", email); // Store user session
            window.location.href = "index.html";
        } else {
            alert("Signup failed: " + data.detail);
        }
    } catch (error) {
        console.error("Signup error:", error);
        alert("An error occurred. Please try again.");
    }
}

// Login Function
async function login() {
    const email = document.getElementById("loginEmail").value;
    const password = document.getElementById("loginPassword").value;

    const response = await fetch(`${apiUrl}/login/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
    });

    const data = await response.json();
    if (response.ok) {
        alert("Login successful!");
        localStorage.setItem("userEmail", email); // Store user session
        window.location.href = "index.html";
    } else {
        alert("Invalid credentials!");
    }
}

// Logout Function
function logout() {
    localStorage.removeItem("userEmail");
    alert("Logged out successfully!");
    window.location.href = "login.html";
}

// Load Products
document.addEventListener("DOMContentLoaded", () => {
    console.log("Loading products...");
    loadProducts();
});

async function loadProducts() {
    const container = document.getElementById("productContainer");

    if (!container) {
        console.warn("⚠️ Warning: 'productContainer' not found. Skipping loadProducts().");
        return;  // Exit the function early
    }

    try {
        const response = await fetch(`${apiUrl}/products/`);
        const products = await response.json();

        container.innerHTML = ""; // Clear previous content

        products.forEach(product => {
            const productCard = `
                <div class="product-card">
                    <img src="${product.image || 'assets/default-product.jpg'}" alt="${product.name}">
                    <h4>${product.name}</h4>
                    <p>${product.description}</p>
                    <button class="wishlist-btn" onclick="saveToWishlist('${product.id}', '${product.name}', '${product.image || ''}', '${product.description}')">
                        Save to Wish List
                    </button>
                </div>
            `;
            container.innerHTML += productCard;
        });

        console.log("Products displayed successfully!");
    } catch (error) {
        console.error("Error loading products:", error);
    }
}

// =====================
// Wishlist Feature (API Connected)
// =====================

// 🛒 Save to Wishlist (Backend API Integration)
async function saveToWishlist(productId, productName, productImage, productDescription) {
    const userEmail = localStorage.getItem("userEmail"); // Get logged-in user's email

    if (!userEmail) {
        alert("You need to log in to save items to your wishlist.");
        return;
    }

    try {
        const response = await fetch(`${apiUrl}/wishlist/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                user_email: userEmail,
                product_id: productId,
                product_name: productName,
                product_image: productImage,
                product_description: productDescription
            }),
        });

        if (response.ok) {
            alert("Added to wishlist!");
        } else {
            const data = await response.json();
            alert("Error: " + data.detail);
        }
    } catch (error) {
        console.error("Error adding to wishlist:", error);
    }
}

// 📝 Load Wishlist from Backend (Enhanced UI)
async function loadWishlist() {
    const userEmail = localStorage.getItem("userEmail");
    const wishlistContainer = document.getElementById("wishlistContainer");

    if (!wishlistContainer || !userEmail) {
        return;
    }

    try {
        const response = await fetch(`${apiUrl}/wishlist/${userEmail}`);
        const wishlist = await response.json();

        wishlistContainer.innerHTML = ""; // Clear previous content

        if (wishlist.length === 0) {
            wishlistContainer.innerHTML = `<p style="font-size:18px; color: #666;">Your wishlist is empty.</p>`;
            return;
        }

        wishlist.forEach(product => {
            const productCard = document.createElement("div");
            productCard.className = "wishlist-card";
            productCard.innerHTML = `
                <img src="${product.product_image || 'assets/default-product.jpg'}" alt="${product.product_name}">
                <h4>${product.product_name}</h4>
                <p>${product.product_description}</p>
                <button class="remove-btn" onclick="removeFromWishlist('${product.product_id}')">Remove</button>
            `;
            wishlistContainer.appendChild(productCard);
        });
    } catch (error) {
        console.error("Error loading wishlist:", error);
    }
}

// ❌ Remove from Wishlist (Backend API Integration)
async function removeFromWishlist(productId) {
    const userEmail = localStorage.getItem("userEmail");

    if (!userEmail) {
        alert("You need to log in to remove items from your wishlist.");
        return;
    }

    try {
        const response = await fetch(`${apiUrl}/wishlist/`, {
            method: "DELETE",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ user_email: userEmail, product_id: productId }),
        });

        if (response.ok) {
            alert("Removed from wishlist!");
            loadWishlist(); // Refresh UI
        } else {
            const data = await response.json();
            alert("Error: " + data.detail);
        }
    } catch (error) {
        console.error("Error removing from wishlist:", error);
    }
}

// 🔄 Load wishlist on page load
document.addEventListener("DOMContentLoaded", () => {
    if (document.getElementById("wishlistContainer")) {
        loadWishlist();
    }
});

console.log("script.js is running!");
