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

document.addEventListener("DOMContentLoaded", () => {
    console.log("Loading products from the server...");
    loadProducts();
});

async function loadProducts() {
    try {
        const response = await fetch(`${apiUrl}/products`);

        if (!response.ok) {
            throw new Error(`Server returned ${response.status}: ${response.statusText}`);
        }

        const products = await response.json();
        displayProducts(products);

    } catch (error) {
        console.error("Error loading products:", error);
        document.getElementById("productContainer").innerHTML = `<p class="error">Failed to load products.</p>`;
    }
}

function displayProducts(products) {
    const container = document.getElementById("productContainer");
    container.innerHTML = "";  // Clear existing products

    products.forEach(product => {
        const productElement = document.createElement("div");
        productElement.classList.add("product-card");

        productElement.setAttribute("data-category-name", product.category_name);
        const img = document.createElement("img");
        img.src = product.picture_url;  // ✅ Use correct key
        img.alt = product.name;

        const title = document.createElement("h4");
        title.textContent = product.name;

        const desc = document.createElement("p");
        desc.textContent = product.description;

        const btn = document.createElement("button");
        btn.textContent = "Save to Wish List";
        btn.classList.add("wishlist-btn");
        btn.onclick = () => saveToWishlist(product.product_id);  // ✅ Corrected ID

        productElement.appendChild(img);
        productElement.appendChild(title);
        productElement.appendChild(desc);
        productElement.appendChild(btn);

        container.appendChild(productElement);
    });
}

function filterByCategory(categoryName) {
    const productCards = document.querySelectorAll(".product-card");

    productCards.forEach(card => {
        const productCategory = card.getAttribute("data-category-name");

        if (categoryName === "all" || productCategory === categoryName) {
            card.style.display = "block"; // Show products in the selected category
        } else {
            card.style.display = "none"; // Hide products that don't match
        }
    });
}

function searchProducts() {
    const searchText = document.getElementById("searchInput").value.toLowerCase();
    const productCards = document.querySelectorAll(".product-card");

    productCards.forEach(card => {
        const productName = card.querySelector("h4").textContent.toLowerCase();

        if (productName.includes(searchText)) {
            card.style.display = "block"; // Show matching products
        } else {
            card.style.display = "none"; // Hide non-matching products
        }
    });
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