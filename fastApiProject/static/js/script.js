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
                                <td style="text-align: center;"><div class="color-swatch" style="background-color: ${v.color.toLowerCase()}"></div></td>
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