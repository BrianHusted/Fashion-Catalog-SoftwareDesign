const apiUrl = "http://127.0.0.1:8000";  // Change this if needed

// Signup Function
async function signup() {
    const fullName = document.getElementById("fullName").value;
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    try {
        const response = await fetch(`${apiUrl}/signup_request/`, {
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

    const response = await fetch(`${apiUrl}/login_request/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
    });

    const data = await response.json();
    if (response.ok) {
        alert("Login successful!");
        window.location.href = "home.html";
    } else {
        alert("Invalid credentials!");
    }
}

// Load Products (generic)
async function loadProducts({ containerId = "productContainer", limit = null } = {}) {
    const container = document.getElementById(containerId);
    if (!container) return;

    try {
        const response = await fetch(`${apiUrl}/products/`);
        const allProducts = await response.json();
        const products = limit ? allProducts.slice(0, limit) : allProducts;
        renderProducts(container, products);
    } catch (err) {
        console.warn("⚠️ Backend unavailable. Loading demo products...");
        const demoProducts = getDemoProducts();
        const products = limit ? demoProducts.slice(0, limit) : demoProducts;
        renderProducts(container, products);
    }
}

// Product Suggestions (Homepage)
async function loadSuggestedProducts() {
    const container = document.getElementById("suggestedProducts");
    if (!container) return;

    try {
        const response = await fetch(`${apiUrl}/products/`);
        const allProducts = await response.json();
        const limited = allProducts.slice(0, 3);
        renderProducts(container, limited);
    } catch (err) {
        console.warn("⚠️ Backend unavailable. Loading demo products...");
        const demo = getDemoProducts().slice(0, 3);
        renderProducts(container, demo);
    }
}

// Load Product by ID (for detail page)
function loadProductById(id) {
    const container = document.getElementById("productDetails");
    if (!container) return;

    fetch(`${apiUrl}/products/`)
        .then(res => res.json())
        .then(products => {
            const product = products.find(p => p.product_id === id);
            if (product) {
                renderProductDetail(container, product);
            } else {
                throw new Error("Product not found in backend");
            }
        })
        .catch(() => {
            console.warn("⚠️ Backend failed, using demo data...");
            const demo = getDemoProducts();
            const product = demo.find(p => p.product_id === id);
            if (product) renderProductDetail(container, product);
            else container.innerHTML = "<p>Product not found.</p>";
        });
}

function renderProductDetail(container, product) {
    container.innerHTML = `
        <img src="../assets/${product.picture_url}" alt="${product.name}">
        <div class="product-info">
            <h2>${product.name}</h2>
            <p><strong>Description:</strong> ${product.description}</p>
            <p><strong>Category:</strong> ${product.category_name}</p>
            <button class="wishlist-btn" onclick="saveToWishlist(${product.product_id})">Save to Wish List</button>
        </div>
    `;
}

// Render Product Cards
function renderProducts(container, products) {
    container.innerHTML = "";
    products.forEach(product => {
        container.innerHTML += `
        <div class="product-card" data-category-name="${product.category_name}">
            <div class="clickable-area" onclick="window.location.href='product.html?id=${product.product_id}'">
                <img src="../assets/${product.picture_url}" alt="${product.name}">
                <h4>${product.name}</h4>
                <p>${product.description}</p>
            </div>
            <button class="wishlist-btn" onclick="event.stopPropagation(); saveToWishlist(${product.product_id})">Save to Wish List</button>
        </div>
        `;
    });
}

// Filter Products by Category
function filterByCategory(categoryName) {
    const productCards = document.querySelectorAll(".product-card");
    productCards.forEach(card => {
        const productCategory = card.getAttribute("data-category-name");
        card.style.display = (categoryName === "all" || productCategory === categoryName) ? "block" : "none";
    });
}

// Search by Name (Live Filter - used only on index)
function searchProducts() {
    const searchText = document.getElementById("searchInput").value.toLowerCase();
    const productCards = document.querySelectorAll(".product-card");
    productCards.forEach(card => {
        const productName = card.querySelector("h4").textContent.toLowerCase();
        card.style.display = productName.includes(searchText) ? "block" : "none";
    });
}

// Search Bar Enter Key Handler
function handleSearchKey(event) {
    if (event.key === "Enter") {
        const query = document.getElementById("searchInput").value.trim();
        if (query !== "") {
            window.location.href = `index.html?search=${encodeURIComponent(query)}`;
        }
    }
}

// Wishlist Button (to be connected later)
async function saveToWishlist(productId) {
    alert(`Product ${productId} added to wishlist!`);
}

// Demo Product Data
function getDemoProducts() {
    return [
        {
            product_id: 1,
            name: "Black Shirt",
            description: "Lightweight cotton shirt for your workouts.",
            picture_url: "black-shirt.png",
            category_name: "Weightlifting"
        },
        {
            product_id: 2,
            name: "Grey Shorts",
            description: "Freedom of motion with these comfy shorts.",
            picture_url: "grey-shorts.jpg",
            category_name: "Running"
        },
        {
            product_id: 3,
            name: "White Hoodie",
            description: "Stay warm without losing flexibility.",
            picture_url: "white-hoodie.jpg",
            category_name: "Hiking"
        }
    ];
}

console.log("✅ script.js is running!");
