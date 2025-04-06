const apiUrl = "http://127.0.0.1:8000";  // Change this if needed
let currentUserEmail = null;  // Store the current user's email
let allProducts = [];
let currentPage = 1;
let productsPerPage = 12;
let isLoading = false;

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
            window.location.href = "/login";
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

    try {
        const response = await fetch(`${apiUrl}/login_request/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password }),
        });

        const data = await response.json();
        if (response.ok) {
            currentUserEmail = email;  // Store the user's email
            localStorage.setItem('userEmail', email);  // Store in localStorage for persistence
            console.log("Login successful, email stored:", email);  // Debug log
            alert("Login successful!");
            window.location.href = "/home";
        } else {
            alert("Invalid credentials!");
        }
    } catch (error) {
        console.error("Login error:", error);
        alert("An error occurred during login. Please try again.");
    }
}

// Check for stored user email on page load
document.addEventListener('DOMContentLoaded', () => {
    currentUserEmail = localStorage.getItem('userEmail');
    if (currentUserEmail) {
        // If we're on the wishlist page, load the wishlist
        if (window.location.pathname === '/wishlist') {
            loadWishlist();
        }
    }
});

// Load categories from the backend
async function loadCategories() {
    try {
        const response = await fetch(`${apiUrl}/categories/`);
        const categories = await response.json();
        
        const categoryFilters = document.getElementById('categoryFilters');
        if (categoryFilters) {
            categoryFilters.innerHTML = categories.map(category => `
                <div class="filter-option">
                    <input type="checkbox" id="category${category.category_id}" 
                           class="filter-checkbox" data-category="${category.name}">
                    <label for="category${category.category_id}" class="filter-label">
                        <span class="category-name">${category.name}</span>
                        <span class="category-count"></span>
                    </label>
                </div>
            `).join('');

            // Add event listeners after creating the checkboxes
            setupFilterListeners();
        }
    } catch (error) {
        console.error('Error loading categories:', error);
    }
}

// Setup filter event listeners
function setupFilterListeners() {
    const filterCheckboxes = document.querySelectorAll('.filter-checkbox');
    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            applyProductFilters();
        });
    });
}

// Apply filters to products
function applyProductFilters() {
    console.log('Applying product filters...');
    
    // Get selected filters
    const selectedCategories = Array.from(document.querySelectorAll('.filter-checkbox[data-category]:checked'))
        .map(cb => cb.dataset.category);
    const selectedSizes = Array.from(document.querySelectorAll('.filter-checkbox[data-size]:checked'))
        .map(cb => cb.dataset.size);
    const selectedColors = Array.from(document.querySelectorAll('.filter-checkbox[data-color]:checked'))
        .map(cb => cb.dataset.color);

    console.log('Selected filters:', {
        categories: selectedCategories,
        sizes: selectedSizes,
        colors: selectedColors
    });

    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(card => {
        const category = card.dataset.category;
        let variations = [];
        try {
            variations = JSON.parse(card.dataset.variations || '[]');
        } catch (e) {
            console.error('Error parsing variations:', e);
        }

        // Category matching
        const matchesCategory = selectedCategories.length === 0 || selectedCategories.includes(category);

        // Size matching
        const matchesSize = selectedSizes.length === 0 || 
            variations.some(v => selectedSizes.includes(v.size));

        // Color matching
        const matchesColor = selectedColors.length === 0 || 
            variations.some(v => selectedColors.includes(v.color));

        // Show/hide the product card
        const shouldShow = matchesCategory && matchesSize && matchesColor;
        card.style.display = shouldShow ? 'flex' : 'none';
    });
}

// Apply filters to wishlist
function applyWishlistFilters() {
    const selectedCategories = Array.from(document.querySelectorAll('[data-category]:checked'))
        .map(cb => cb.dataset.category);
    const selectedSizes = Array.from(document.querySelectorAll('[data-size]:checked'))
        .map(cb => cb.dataset.size);
    const selectedColors = Array.from(document.querySelectorAll('[data-color]:checked'))
        .map(cb => cb.dataset.color);

    const items = document.querySelectorAll('.wishlist-item');
    items.forEach(item => {
        const category = item.dataset.category;
        let variations = [];
        try {
            variations = JSON.parse(item.dataset.variations || '[]');
        } catch (e) {
            console.error('Error parsing variations:', e);
        }

        // Category matching
        const matchesCategory = selectedCategories.length === 0 || selectedCategories.includes(category);

        // Size matching - show if any variation matches any selected size
        const matchesSize = selectedSizes.length === 0 || 
            variations.some(v => selectedSizes.includes(v.size));

        // Color matching - show if any variation matches any selected color
        const matchesColor = selectedColors.length === 0 || 
            variations.some(v => selectedColors.includes(v.color));

        // Show the item if it matches all active filters
        const shouldShow = matchesCategory && matchesSize && matchesColor;
        item.style.display = shouldShow ? 'block' : 'none';
    });
}

// Update loadWishlist function to be simpler without filtering
async function loadWishlist() {
    if (!currentUserEmail) {
        currentUserEmail = localStorage.getItem('userEmail');
        if (!currentUserEmail) {
            alert("Please log in to view your wishlist");
            window.location.href = "/login";
            return;
        }
    }

    try {
        const response = await fetch(`${apiUrl}/wishlist/${currentUserEmail}`);
        if (!response.ok) {
            const errorData = await response.json();
            console.error("Wishlist error:", errorData);
            throw new Error(errorData.detail || 'Failed to load wishlist');
        }
        const wishlistItems = await response.json();
        
        const container = document.getElementById("wishlistContainer");
        if (!container) {
            console.error("Wishlist container not found");
            return;
        }

        container.innerHTML = "";
        if (wishlistItems.length === 0) {
            container.innerHTML = `
                <div class="empty-wishlist">
                    <p>Your wishlist is empty.</p>
                    <a href="/index" class="primary-btn">Browse Products</a>
                </div>
            `;
            return;
        }

        wishlistItems.forEach(item => {
            const imagePath = item.product.picture_url ? `/static/assets/products/${item.product.picture_url}` : '/static/assets/default-product.jpg';
            const addedDate = new Date(item.added_at).toLocaleDateString();
            
            // Create variations summary
            const variationsSummary = renderVariationsSummary(item.product.variations);
            
            container.innerHTML += `
                <div class="wishlist-item">
                    <img src="${imagePath}" alt="${item.product.name}" class="wishlist-item-image">
                    <div class="wishlist-item-info">
                        <h3 class="wishlist-item-title">${item.product.name}</h3>
                        <p class="wishlist-item-category">Category: ${item.product.category_name}</p>
                        <p class="wishlist-item-description">${item.product.description}</p>
                        <div class="variations-summary">
                            ${variationsSummary}
                        </div>
                        <p class="wishlist-item-date">Added on ${addedDate}</p>
                        <button class="remove-from-wishlist" onclick="removeFromWishlist(${item.product.product_id})">
                            <i class="fas fa-trash"></i> Remove from Wishlist
                        </button>
                    </div>
                </div>
            `;
        });
    } catch (error) {
        console.error("Error loading wishlist:", error);
        alert("Failed to load wishlist. Please try again.");
    }
}

// Save to Wishlist
async function saveToWishlist(productId) {
    if (!currentUserEmail) {
        currentUserEmail = localStorage.getItem('userEmail');  // Try to get email from localStorage
        if (!currentUserEmail) {
            alert("Please log in to add items to your wishlist");
            window.location.href = "/login";
            return;
        }
    }

    console.log("Attempting to add to wishlist:", { email: currentUserEmail, productId });  // Debug log

    try {
        const response = await fetch(`${apiUrl}/wishlist/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                email: currentUserEmail,
                product_id: productId
            })
        });

        const data = await response.json();
        if (response.ok) {
            alert("Added to wishlist!");
            // If we're on the wishlist page, reload it
            if (window.location.pathname === '/wishlist') {
                loadWishlist();
            }
        } else {
            console.error("Wishlist error response:", data);  // Debug log
            alert(data.detail || "Failed to add to wishlist");
        }
    } catch (error) {
        console.error("Error adding to wishlist:", error);
        alert("Failed to add to wishlist. Please try again.");
    }
}

// Remove from Wishlist
async function removeFromWishlist(productId) {
    if (!currentUserEmail) {
        currentUserEmail = localStorage.getItem('userEmail');  // Try to get email from localStorage
        if (!currentUserEmail) {
            alert("Please log in to manage your wishlist");
            window.location.href = "/login";
            return;
        }
    }

    try {
        console.log("Removing from wishlist:", { email: currentUserEmail, productId });  // Debug log
        const response = await fetch(`${apiUrl}/wishlist/${currentUserEmail}/${productId}`, {
            method: "DELETE"
        });

        if (response.ok) {
            alert("Removed from wishlist!");
            loadWishlist();  // Reload the wishlist
        } else {
            const data = await response.json();
            console.error("Remove wishlist error:", data);  // Debug log
            alert(data.detail || "Failed to remove from wishlist");
        }
    } catch (error) {
        console.error("Error removing from wishlist:", error);
        alert("Failed to remove from wishlist. Please try again.");
    }
}

// Load Products (generic)
async function loadProducts({ containerId = "productContainer", limit = null } = {}) {
    const container = document.getElementById(containerId);
    if (!container) return;

    try {
        // Add loading spinner
        container.innerHTML = '<div class="loading-spinner" style="display: block;"></div>';
        
        const response = await fetch(`${apiUrl}/products/`);
        allProducts = await response.json();
        
        // Calculate products per page based on screen size
        updateProductsPerPage();
        
        // Render initial batch of products
        renderProductBatch(container);
        
        // Add Load More button
        addLoadMoreButton(container);
        
        // Add intersection observer for infinite scroll
        setupInfiniteScroll(container);
        
    } catch (err) {
        console.warn("⚠️ Backend unavailable. Loading demo products...");
        allProducts = getDemoProducts();
        renderProductBatch(container);
    }
}

// Function to update products per page based on screen size
function updateProductsPerPage() {
    const width = window.innerWidth;
    if (width >= 2000) {
        productsPerPage = 15; // 5 columns x 3 rows
    } else if (width >= 1600) {
        productsPerPage = 12; // 4 columns x 3 rows
    } else if (width >= 1200) {
        productsPerPage = 9; // 3 columns x 3 rows
    } else if (width >= 768) {
        productsPerPage = 6; // 2 columns x 3 rows
    } else {
        productsPerPage = 4; // 1 column x 4 rows
    }
}

// Function to render a batch of products
function renderProductBatch(container) {
    const startIndex = (currentPage - 1) * productsPerPage;
    const endIndex = startIndex + productsPerPage;
    const productsToRender = allProducts.slice(startIndex, endIndex);
    
    if (currentPage === 1) {
        container.innerHTML = '';
    }
    
    productsToRender.forEach(product => {
        const imagePath = product.picture_url ? `/static/assets/products/${product.picture_url}` : '/static/assets/default-product.jpg';
        const variations = product.variations || [];
        const sizes = [...new Set(variations.map(v => v.size))].join(', ') || 'No sizes available';
        const colors = [...new Set(variations.map(v => v.color))].join(', ') || 'No colors available';
        
        const productCard = document.createElement('div');
        productCard.className = 'product-card';
        productCard.dataset.category = product.category_name;
        productCard.dataset.variations = JSON.stringify(variations);
        
        productCard.innerHTML = `
            <div class="clickable-area" onclick="window.location.href='/product?id=${product.product_id}'">
                <img src="${imagePath}" alt="${product.name}" loading="lazy">
                <div class="product-category">
                    <span>${product.category_name}</span>
                </div>
                <h4>${product.name}</h4>
                <p>${product.description}</p>
                <div class="variations-info">
                    <p>Sizes: ${sizes}</p>
                    <p>Colors: ${colors}</p>
                </div>
            </div>
            <button class="wishlist-btn" onclick="event.stopPropagation(); saveToWishlist(${product.product_id})">
                <i class="fas fa-heart"></i> Add to Wishlist
            </button>
        `;
        
        container.appendChild(productCard);
    });
}

// Function to add Load More button
function addLoadMoreButton(container) {
    const loadMoreContainer = document.createElement('div');
    loadMoreContainer.className = 'load-more-container';
    
    const button = document.createElement('button');
    button.className = 'load-more-btn';
    button.textContent = 'Load More Products';
    button.onclick = () => loadMoreProducts(container);
    
    if (currentPage * productsPerPage >= allProducts.length) {
        button.disabled = true;
        button.textContent = 'No More Products';
    }
    
    loadMoreContainer.appendChild(button);
    container.parentNode.insertBefore(loadMoreContainer, container.nextSibling);
}

// Function to load more products
async function loadMoreProducts(container) {
    if (isLoading) return;
    
    isLoading = true;
    const loadMoreBtn = document.querySelector('.load-more-btn');
    if (loadMoreBtn) {
        loadMoreBtn.disabled = true;
        loadMoreBtn.innerHTML = '<div class="loading-spinner" style="display: inline-block; width: 20px; height: 20px; margin-right: 10px;"></div> Loading...';
    }
    
    currentPage++;
    await new Promise(resolve => setTimeout(resolve, 500)); // Simulate loading delay
    renderProductBatch(container);
    
    isLoading = false;
    if (loadMoreBtn) {
        if (currentPage * productsPerPage >= allProducts.length) {
            loadMoreBtn.disabled = true;
            loadMoreBtn.textContent = 'No More Products';
        } else {
            loadMoreBtn.disabled = false;
            loadMoreBtn.textContent = 'Load More Products';
        }
    }
}

// Setup infinite scroll
function setupInfiniteScroll(container) {
    const options = {
        root: null,
        rootMargin: '100px',
        threshold: 0.1
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting && !isLoading && currentPage * productsPerPage < allProducts.length) {
                loadMoreProducts(container);
            }
        });
    }, options);
    
    // Observe the last product card
    const lastCard = container.querySelector('.product-card:last-child');
    if (lastCard) {
        observer.observe(lastCard);
    }
}

// Add window resize listener to update layout
window.addEventListener('resize', debounce(() => {
    const oldPerPage = productsPerPage;
    updateProductsPerPage();
    
    if (oldPerPage !== productsPerPage) {
        currentPage = 1;
        const container = document.getElementById('productContainer');
        if (container) {
            renderProductBatch(container);
            addLoadMoreButton(container);
        }
    }
}, 250));

// Debounce helper function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
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
    const imagePath = product.picture_url ? `/static/assets/products/${product.picture_url}` : '/static/assets/default-product.jpg';
    
    // Create variations table HTML if variations exist
    let variationsHTML = '';
    if (product.variations && product.variations.length > 0) {
        variationsHTML = `
            <div class="variations-section">
                <h3>Available Options</h3>
                <table class="variations-table">
                    <thead>
                        <tr>
                            <th>Size</th>
                            <th>Color</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${product.variations.map(v => `
                            <tr>
                                <td>${v.size}</td>
                                <td>
                                    <div class="color-swatch" style="background-color: ${v.color}"></div>
                                    ${v.color}
                                </td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        `;
    }

    container.innerHTML = `
        <div class="product-detail-container">
            <div class="product-image-section">
                <img src="${imagePath}" alt="${product.name}" class="product-main-image">
            </div>
            <div class="product-info-section">
                <h1 class="product-title">${product.name}</h1>
                <div class="product-category">
                    <span class="category-label">Category:</span>
                    <span class="category-value">${product.category_name}</span>
                </div>
                <div class="product-description">
                    <h3>Description</h3>
                    <p>${product.description}</p>
                </div>
                ${variationsHTML}
                <div class="product-actions">
                    <button class="wishlist-btn primary-btn" onclick="saveToWishlist(${product.product_id})">
                        <i class="fas fa-heart"></i> Add to Wishlist
                    </button>
                </div>
            </div>
        </div>
    `;
}

// Render Product Cards with variations data
function renderProducts(container, products) {
    container.innerHTML = "";
    products.forEach(product => {
        const imagePath = product.picture_url ? `/static/assets/products/${product.picture_url}` : '/static/assets/default-product.jpg';
        const variations = product.variations || [];
        const sizes = [...new Set(variations.map(v => v.size))].join(', ') || 'No sizes available';
        const colors = [...new Set(variations.map(v => v.color))].join(', ') || 'No colors available';
        
        container.innerHTML += `
        <div class="product-card" 
             data-category="${product.category_name}"
             data-variations='${JSON.stringify(variations)}'>
            <div class="clickable-area" onclick="window.location.href='/product?id=${product.product_id}'">
                <img src="${imagePath}" alt="${product.name}" loading="lazy">
                <div class="product-category">
                    <span>${product.category_name}</span>
                </div>
                <h4>${product.name}</h4>
                <p>${product.description}</p>
                <div class="variations-info">
                    <p>Sizes: ${sizes}</p>
                    <p>Colors: ${colors}</p>
                </div>
            </div>
            <button class="wishlist-btn" onclick="event.stopPropagation(); saveToWishlist(${product.product_id})">
                <i class="fas fa-heart"></i> Add to Wishlist
            </button>
        </div>
        `;
    });
}

// Helper function to render variations summary
function renderVariationsSummary(variations) {
    if (!variations || variations.length === 0) return '';
    
    const sizes = [...new Set(variations.map(v => v.size))];
    const colors = [...new Set(variations.map(v => v.color))];
    
    return `
        <div class="variations-info">
            <p>Available Sizes: ${sizes.join(', ')}</p>
            <p>Available Colors: ${colors.join(', ')}</p>
        </div>
    `;
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
            window.location.href = `/index?search=${encodeURIComponent(query)}`;
        }
    }
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

async function createProduct(event) {
    event.preventDefault();
    
    // Get form elements
    const nameInput = document.getElementById('productName');
    const descriptionInput = document.getElementById('productDescription');
    const categoryInput = document.getElementById('productCategory');
    const imageInput = document.getElementById('productImage');

    // Validate inputs
    if (!nameInput.value.trim()) {
        alert('Please enter a product name');
        return;
    }
    if (!descriptionInput.value.trim()) {
        alert('Please enter a product description');
        return;
    }
    if (!categoryInput.value) {
        alert('Please select a category');
        return;
    }
    if (!imageInput.files[0]) {
        alert('Please select an image');
        return;
    }

    const formData = new FormData();
    formData.append('name', nameInput.value.trim());
    formData.append('description', descriptionInput.value.trim());
    formData.append('category_id', parseInt(categoryInput.value));
    formData.append('picture', imageInput.files[0]);

    try {
        const response = await fetch(`${apiUrl}/products/`, {
            method: 'POST',
            body: formData
        });

        const data = await response.json();

        if (response.ok) {
            alert('Product created successfully!');
            window.location.href = '/index';
        } else {
            alert(data.detail || 'Failed to create product');
            console.error('Error response:', data);
        }
    } catch (error) {
        console.error('Error creating product:', error);
        alert('Failed to create product. Please try again.');
    }
}

// Update Account
async function updateAccount() {
    if (!currentUserEmail) {
        currentUserEmail = localStorage.getItem('userEmail');
        if (!currentUserEmail) {
            alert("Please log in to update your account");
            window.location.href = "/login";
            return;
        }
    }

    const firstName = document.getElementById("firstName").value.trim();
    const lastName = document.getElementById("lastName").value.trim();
    const birthdate = document.getElementById("birthdate").value;
    const currentPassword = document.getElementById("currentPassword").value;
    const newPassword = document.getElementById("newPassword").value;

    // Validate inputs
    if (!firstName || !lastName || !birthdate || !currentPassword) {
        alert("Please fill in all required fields");
        return;
    }

    // Validate date format
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(birthdate)) {
        alert("Please enter a valid date in YYYY-MM-DD format");
        return;
    }

    try {
        console.log("Attempting to update account:", { 
            email: currentUserEmail,
            firstName,
            lastName,
            birthdate
        });  // Debug log

        const response = await fetch(`${apiUrl}/update_account/`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                email: currentUserEmail,  // Send email directly
                first_name: firstName,
                last_name: lastName,
                birthdate: birthdate,
                current_password: currentPassword,
                new_password: newPassword || undefined  // Only include if not empty
            })
        });

        const data = await response.json();
        if (response.ok) {
            console.log("Account updated successfully:", data);  // Debug log
            alert("Account updated successfully!");
            
            // Clear sensitive fields
            document.getElementById("currentPassword").value = "";
            document.getElementById("newPassword").value = "";
            
            // Update displayed information
            if (document.getElementById("userName")) {
                document.getElementById("userName").textContent = `${data.first_name} ${data.last_name}`;
            }
        } else {
            console.error("Account update error:", data);  // Debug log
            alert(data.detail || "Failed to update account");
        }
    } catch (error) {
        console.error("Error updating account:", error);
        alert("Failed to update account. Please try again.");
    }
}

console.log("✅ script.js is running!");
