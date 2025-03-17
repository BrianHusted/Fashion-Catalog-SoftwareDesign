-- Users table
CREATE TABLE "users" (
  "email" VARCHAR(100) PRIMARY KEY,
  "password_hash" TEXT NOT NULL,
  "first_name" VARCHAR(50) NOT NULL,
  "last_name" VARCHAR(50) NOT NULL,
  "birthdate" DATE NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Categories table
CREATE TABLE "categories" (
  "category_id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE NOT NULL
);

-- Products table (removed stock_quantity, added picture_url)
CREATE TABLE "products" (
  "product_id" SERIAL PRIMARY KEY,
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "price" DECIMAL(10,2) NOT NULL,
  "category_id" INT NOT NULL,
  "picture_url" VARCHAR(255), -- Added for storing image file names
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Product Variations table (removed stock_quantity)
CREATE TABLE "product_variations" (
  "variation_id" SERIAL PRIMARY KEY,
  "product_id" INT NOT NULL,
  "size" VARCHAR(20) NOT NULL,
  "color" VARCHAR(50) NOT NULL
);

-- User Preferences table
CREATE TABLE "user_preferences" (
  "preference_id" SERIAL PRIMARY KEY,
  "email" VARCHAR(100) NOT NULL,
  "category_id" INT NOT NULL,
  "preferred_size" VARCHAR(20),
  "preferred_color" VARCHAR(50)
);

-- Wishlist table
CREATE TABLE "wishlist" (
  "wishlist_id" SERIAL PRIMARY KEY,
  "email" VARCHAR(100) NOT NULL,
  "product_id" INT NOT NULL,
  "added_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Reviews table
CREATE TABLE "reviews" (
  "review_id" SERIAL PRIMARY KEY,
  "email" VARCHAR(100) NOT NULL,
  "product_id" INT NOT NULL,
  "rating" INT,
  "comment" TEXT,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Admins table
CREATE TABLE "admins" (
  "admin_id" SERIAL PRIMARY KEY,
  "username" VARCHAR(50) UNIQUE NOT NULL,
  "email" VARCHAR(100) UNIQUE NOT NULL,
  "password_hash" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Product Logs table (adjusted product_id foreign key to ON DELETE SET NULL)
CREATE TABLE "product_logs" (
  "log_id" SERIAL PRIMARY KEY,
  "product_id" INT,
  "admin_id" INT NOT NULL,
  "action_type" VARCHAR(50),
  "timestamp" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

-- Unique Indexes
CREATE UNIQUE INDEX ON "product_variations" ("product_id", "size", "color");
CREATE UNIQUE INDEX ON "user_preferences" ("email", "category_id");
CREATE UNIQUE INDEX ON "wishlist" ("email", "product_id");

-- Foreign Key Constraints
ALTER TABLE "products" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id") ON DELETE SET NULL;
ALTER TABLE "product_variations" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id") ON DELETE CASCADE;
ALTER TABLE "user_preferences" ADD FOREIGN KEY ("email") REFERENCES "users" ("email") ON DELETE CASCADE;
ALTER TABLE "user_preferences" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id") ON DELETE CASCADE;
ALTER TABLE "wishlist" ADD FOREIGN KEY ("email") REFERENCES "users" ("email") ON DELETE CASCADE;
ALTER TABLE "wishlist" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id") ON DELETE CASCADE;
ALTER TABLE "reviews" ADD FOREIGN KEY ("email") REFERENCES "users" ("email") ON DELETE CASCADE;
ALTER TABLE "reviews" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id") ON DELETE CASCADE;
ALTER TABLE "product_logs" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id") ON DELETE SET NULL;
ALTER TABLE "product_logs" ADD FOREIGN KEY ("admin_id") REFERENCES "admins" ("admin_id") ON DELETE SET NULL;