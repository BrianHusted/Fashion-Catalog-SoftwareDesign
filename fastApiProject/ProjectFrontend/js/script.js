const apiUrl = "http://127.0.0.1:8000";  // Change this if needed


async function signup(){ // Prevent page reload

    // Get form values
    const fullName = document.getElementById("fullName").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    // Send request to FastAPI backend
    try {
        const response = await fetch(`${apiUrl}/signup`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ full_name: fullName, email: email, password: password })
        });

        const data = await response.json();
        if (response.ok) {
            alert("Signup successful!");
            window.location.href = "login.html";
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

    const response = await fetch(`${apiUrl}/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
    });

    const data = await response.json();
    if (response.ok) {
        alert("Login successful!");
        window.location.href = "index.html";
    } else {
        alert("Invalid credentials!");
    }
}

// Load Products 
/*
document.addEventListener("DOMContentLoaded", () => {
    loadProducts();
});

async function loadProducts() {
    try {
        const response = await fetch("http://localhost:8000/api/products"); // Update API endpoint if needed
        const products = await response.json();

        const container = document.getElementById("productContainer");
        container.innerHTML = "";  // Clear existing products

        products.forEach(product => {
            const productCard = `
                <div class="product-card">
                    <img src="${product.image}" alt="${product.name}">
                    <h4>${product.name}</h4>
                    <p>${product.description}</p>
                    <button class="wishlist-btn" onclick="saveToWishlist('${product.id}')">Save to Wish List</button>
                </div>
            `;
            container.innerHTML += productCard;
        });
    } catch (error) {
        console.error("Error loading products:", error);
    }
}
*/
document.addEventListener("DOMContentLoaded", () => {
    console.log("Loading static products...");
    loadProducts();
});

function loadProducts() {
    const container = document.getElementById("productContainer");

    if (!container) {
        console.warn("⚠️ Warning: 'productContainer' not found. Skipping loadProducts().");
        return;  // Exit the function early
    }

    const products = [
        {
            id: 1,
            name: "Black Shirt",
            description: "Nice cotton shirt to keep you cool during workouts",
            image: "assets/black-shirt.png" // Add this image in your assets folder
        },
        {
            id: 2,
            name: "Grey Shorts",
            description: "Shorts built to keep you moving free",
            image: "assets/grey-shorts.jpg" // Add this image in your assets folder
        },
        {
            id: 3,
            name: "White Hoodie",
            description: "Cold out? No excuses with this hoodie!",
            image: "assets/white-hoodie.jpg" // Add this image in your assets folder
        }
    ];
    container.innerHTML = ""; // Clear previous content

    products.forEach(product => {
        const productCard = `
            <div class="product-card">
                <img src="${product.image}" alt="${product.name}">
                <h4>${product.name}</h4>
                <p>${product.description}</p>
                <button class="wishlist-btn" onclick="saveToWishlist('${product.id}')">Save to Wish List</button>
            </div>
        `;
        container.innerHTML += productCard;
    });

    console.log("Products displayed successfully!");
}

// Wishlist function (not connected to a backend yet)
function saveToWishlist(productId) {
    alert(`Product ${productId} added to wishlist!`);
}

// Save to Wishlist
async function saveToWishlist(productId) {
    alert("Added to wishlist!");  // In a real scenario, make an API call
}

// Load products on catalog page
if (document.getElementById("productContainer")) {
    loadProducts();
}


console.log("script.js is running!");