import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import psycopg2
from psycopg2 import sql
import os

# Database connection
def connect_db():
    try:
        conn = psycopg2.connect(
            dbname="flexwear",
            user="",
            password="",  # Add your PostgreSQL password here
            host="localhost",
            port="5432"
        )
        print("Database connected successfully!")
        return conn
    except Exception as e:
        print(f"Database connection failed: {e}")
        raise

# Main Admin GUI
class AdminGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Fashion Catalogue Admin Backend")
        try:
            self.conn = connect_db()
            self.cursor = self.conn.cursor()
            print("Cursor initialized successfully.")

            # Verify if admins table exists
            self.cursor.execute("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_name = 'admins'
                )
            """)
            table_exists = self.cursor.fetchone()[0]

            if not table_exists:
                self.cursor.execute("""
                    CREATE TABLE admins (
                        admin_id SERIAL PRIMARY KEY,
                        username VARCHAR(50) NOT NULL,
                        email VARCHAR(100) NOT NULL,
                        password_hash VARCHAR(255) NOT NULL,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                """)
                self.conn.commit()
                print("Created admins table.")

            # Ensure at least one admin exists
            self.cursor.execute("SELECT COUNT(*) FROM admins")
            count = self.cursor.fetchone()[0]

            if count == 0:
                self.cursor.execute("""
                    INSERT INTO admins (username, email, password_hash)
                    VALUES ('bohdan', 'b@gmail.com', '123')
                """)
                self.conn.commit()
                print("Inserted default admin.")

            # Print all admins for debugging
            self.print_all_admins()

        except Exception as e:
            print(f"Failed to initialize cursor or verify tables: {e}")
            self.conn.rollback()

        self.current_admin_id = None

        # Log filter state
        self.log_filter_applied = False
        self.log_filter_product_id = None
        self.log_filter_admin_id = None
        self.log_filter_action_type = None

        # Start with login screen
        self.show_login_screen()

    def print_all_admins(self):
        try:
            self.cursor.execute("SELECT admin_id, username, email, password_hash, created_at FROM admins")
            admins = self.cursor.fetchall()
            print("\nAll Admin Users and Passwords:")
            for admin in admins:
                admin_id, username, email, password, created_at = admin
                print(f"Admin ID: {admin_id}, Username: {username}, Email: {email}, Password: {password}, Created At: {created_at}")
            if not admins:
                print("No admin users found in the database!")
        except Exception as e:
            print(f"Error fetching admins: {e}")
            self.conn.rollback()

    def show_login_screen(self):
        self.clear_window()
        tk.Label(self.root, text="Admin Login", font=("Arial", 16)).pack(pady=10)

        tk.Label(self.root, text="Username").pack()
        self.username_entry = tk.Entry(self.root)
        self.username_entry.pack()

        tk.Label(self.root, text="Password").pack()
        self.password_entry = tk.Entry(self.root, show="*")
        self.password_entry.pack()

        tk.Button(self.root, text="Login", command=self.verify_login).pack(pady=10)

    def verify_login(self):
        username = self.username_entry.get()
        password = self.password_entry.get()
        print(f"Attempting login with Username: {username}, Password: {password}")

        try:
            self.cursor.execute("SELECT admin_id, password_hash FROM admins WHERE username = %s", (username,))
            result = self.cursor.fetchone()
            print(f"Database query result: {result}")

            if result and result[1] == password:
                self.current_admin_id = result[0]
                print(f"Login successful for Admin ID: {self.current_admin_id}")
                self.show_main_screen()
            else:
                print("Login failed: Invalid username or password")
                messagebox.showerror("Error", "Invalid username or password")
        except Exception as e:
            print(f"Login error: {e}")
            self.conn.rollback()
            messagebox.showerror("Error", f"Login failed: {e}")

    def clear_window(self):
        for widget in self.root.winfo_children():
            widget.destroy()

    def show_main_screen(self):
        self.clear_window()
        tk.Label(self.root, text="Fashion Catalogue Admin Backend", font=("Arial", 16)).pack(pady=10)

        self.notebook = ttk.Notebook(self.root)
        self.notebook.pack(pady=10, expand=True)

        self.categories_tab = ttk.Frame(self.notebook)
        self.products_tab = ttk.Frame(self.notebook)
        self.variations_tab = ttk.Frame(self.notebook)
        self.admins_tab = ttk.Frame(self.notebook)
        self.logs_tab = ttk.Frame(self.notebook)

        self.notebook.add(self.categories_tab, text="Categories")
        self.notebook.add(self.products_tab, text="Products")
        self.notebook.add(self.variations_tab, text="Product Variations")
        self.notebook.add(self.admins_tab, text="Admins")
        self.notebook.add(self.logs_tab, text="Logs")

        self.setup_categories_tab()
        self.setup_products_tab()
        self.setup_variations_tab()
        self.setup_admins_tab()
        self.setup_logs_tab()

    def setup_categories_tab(self):
        tk.Label(self.categories_tab, text="Category Name").grid(row=0, column=0, padx=5, pady=5)
        self.category_name_entry = tk.Entry(self.categories_tab)
        self.category_name_entry.grid(row=0, column=1, padx=5, pady=5)

        tk.Button(self.categories_tab, text="Add Category", command=self.add_category).grid(row=0, column=2, padx=5, pady=5)

        self.categories_tree = ttk.Treeview(self.categories_tab, columns=("ID", "Name"), show="headings")
        self.categories_tree.heading("ID", text="Category ID")
        self.categories_tree.heading("Name", text="Name")
        self.categories_tree.grid(row=1, column=0, columnspan=3, padx=5, pady=5)

        # Bind selection event
        self.categories_tree.bind("<<TreeviewSelect>>", self.on_category_selected)

        tk.Button(self.categories_tab, text="Edit Selected", command=self.edit_category).grid(row=2, column=0, padx=5, pady=5)
        tk.Button(self.categories_tab, text="Delete Selected", command=self.delete_category).grid(row=2, column=1, padx=5, pady=5)

        self.update_categories_tree()

    def on_category_selected(self, event):
        selected = self.categories_tree.selection()
        if selected:
            # Get the selected category's values
            values = self.categories_tree.item(selected[0])["values"]
            # Populate the input field
            self.category_name_entry.delete(0, tk.END)
            self.category_name_entry.insert(0, values[1])  # Name
        else:
            # Clear the field if no item is selected
            self.category_name_entry.delete(0, tk.END)

    def setup_products_tab(self):
        tk.Label(self.products_tab, text="Product Name").grid(row=0, column=0, padx=5, pady=5)
        self.product_name_entry = tk.Entry(self.products_tab)
        self.product_name_entry.grid(row=0, column=1, padx=5, pady=5)

        tk.Label(self.products_tab, text="Description").grid(row=1, column=0, padx=5, pady=5)
        self.product_desc_entry = tk.Entry(self.products_tab)
        self.product_desc_entry.grid(row=1, column=1, padx=5, pady=5)

        tk.Label(self.products_tab, text="Price").grid(row=2, column=0, padx=5, pady=5)
        self.product_price_entry = tk.Entry(self.products_tab)
        self.product_price_entry.grid(row=2, column=1, padx=5, pady=5)

        tk.Label(self.products_tab, text="Category").grid(row=3, column=0, padx=5, pady=5)
        self.product_category_combo = ttk.Combobox(self.products_tab)
        self.product_category_combo.grid(row=3, column=1, padx=5, pady=5)
        self.update_category_combo()

        tk.Label(self.products_tab, text="Picture URL").grid(row=4, column=0, padx=5, pady=5)
        self.product_picture_entry = tk.Entry(self.products_tab)
        self.product_picture_entry.grid(row=4, column=1, padx=5, pady=5)
        tk.Button(self.products_tab, text="Browse", command=self.browse_picture_file).grid(row=4, column=2, padx=5, pady=5)

        tk.Button(self.products_tab, text="Add Product", command=self.add_product).grid(row=5, column=1, padx=5, pady=5)

        self.products_tree = ttk.Treeview(self.products_tab, columns=("ID", "Name", "Description", "Price", "Category", "Picture URL"), show="headings")
        self.products_tree.heading("ID", text="Product ID")
        self.products_tree.heading("Name", text="Name")
        self.products_tree.heading("Description", text="Description")
        self.products_tree.heading("Price", text="Price")
        self.products_tree.heading("Category", text="Category")
        self.products_tree.heading("Picture URL", text="Picture URL")
        self.products_tree.grid(row=6, column=0, columnspan=3, padx=5, pady=5)

        # Bind selection event
        self.products_tree.bind("<<TreeviewSelect>>", self.on_product_selected)

        tk.Button(self.products_tab, text="Edit Selected", command=self.edit_product).grid(row=7, column=0, padx=5, pady=5)
        tk.Button(self.products_tab, text="Delete Selected", command=self.delete_product).grid(row=7, column=1, padx=5, pady=5)

        self.update_products_tree()

    def on_product_selected(self, event):
        selected = self.products_tree.selection()
        if selected:
            # Get the selected product's values
            values = self.products_tree.item(selected[0])["values"]
            # Populate the input fields
            self.product_name_entry.delete(0, tk.END)
            self.product_name_entry.insert(0, values[1])  # Name

            self.product_desc_entry.delete(0, tk.END)
            self.product_desc_entry.insert(0, values[2])  # Description

            self.product_price_entry.delete(0, tk.END)
            self.product_price_entry.insert(0, values[3])  # Price

            self.product_category_combo.set(values[4])  # Category

            self.product_picture_entry.delete(0, tk.END)
            self.product_picture_entry.insert(0, values[5] if values[5] else "")  # Picture URL (handle NULL)
        else:
            # Clear the fields if no item is selected
            self.product_name_entry.delete(0, tk.END)
            self.product_desc_entry.delete(0, tk.END)
            self.product_price_entry.delete(0, tk.END)
            self.product_category_combo.set("")
            self.product_picture_entry.delete(0, tk.END)

    def browse_picture_file(self):
        file_path = filedialog.askopenfilename(
            title="Select Picture File",
            filetypes=(("Image files", "*.png *.jpg *.jpeg *.gif *.bmp"), ("All files", "*.*"))
        )
        if file_path:
            # Extract just the file name from the full path
            file_name = os.path.basename(file_path)
            self.product_picture_entry.delete(0, tk.END)
            self.product_picture_entry.insert(0, file_name)
            print(f"Selected picture file: {file_name} (full path: {file_path})")

    def setup_variations_tab(self):
        tk.Label(self.variations_tab, text="Product").grid(row=0, column=0, padx=5, pady=5)
        self.variation_product_combo = ttk.Combobox(self.variations_tab)
        self.variation_product_combo.grid(row=0, column=1, padx=5, pady=5)
        self.update_product_combo()

        tk.Label(self.variations_tab, text="Size").grid(row=1, column=0, padx=5, pady=5)
        self.variation_size_entry = tk.Entry(self.variations_tab)
        self.variation_size_entry.grid(row=1, column=1, padx=5, pady=5)

        tk.Label(self.variations_tab, text="Color").grid(row=2, column=0, padx=5, pady=5)
        self.variation_color_entry = tk.Entry(self.variations_tab)
        self.variation_color_entry.grid(row=2, column=1, padx=5, pady=5)

        tk.Button(self.variations_tab, text="Add Variation", command=self.add_variation).grid(row=3, column=1, padx=5, pady=5)

        self.variations_tree = ttk.Treeview(self.variations_tab, columns=("ID", "Product", "Size", "Color"), show="headings")
        self.variations_tree.heading("ID", text="Variation ID")
        self.variations_tree.heading("Product", text="Product")
        self.variations_tree.heading("Size", text="Size")
        self.variations_tree.heading("Color", text="Color")
        self.variations_tree.grid(row=4, column=0, columnspan=3, padx=5, pady=5)

        # Bind selection event
        self.variations_tree.bind("<<TreeviewSelect>>", self.on_variation_selected)

        tk.Button(self.variations_tab, text="Edit Selected", command=self.edit_variation).grid(row=5, column=0, padx=5, pady=5)
        tk.Button(self.variations_tab, text="Delete Selected", command=self.delete_variation).grid(row=5, column=1, padx=5, pady=5)

        self.update_variations_tree()

    def on_variation_selected(self, event):
        selected = self.variations_tree.selection()
        if selected:
            # Get the selected variation's values
            values = self.variations_tree.item(selected[0])["values"]
            # Populate the input fields
            self.variation_product_combo.set(values[1])  # Product name
            self.variation_size_entry.delete(0, tk.END)
            self.variation_size_entry.insert(0, values[2])  # Size
            self.variation_color_entry.delete(0, tk.END)
            self.variation_color_entry.insert(0, values[3])  # Color
        else:
            # Clear the fields if no item is selected
            self.variation_product_combo.set("")
            self.variation_size_entry.delete(0, tk.END)
            self.variation_color_entry.delete(0, tk.END)

    def setup_admins_tab(self):
        tk.Label(self.admins_tab, text="Username").grid(row=0, column=0, padx=5, pady=5)
        self.admin_username_entry = tk.Entry(self.admins_tab)
        self.admin_username_entry.grid(row=0, column=1, padx=5, pady=5)

        tk.Label(self.admins_tab, text="Email").grid(row=1, column=0, padx=5, pady=5)
        self.admin_email_entry = tk.Entry(self.admins_tab)
        self.admin_email_entry.grid(row=1, column=1, padx=5, pady=5)

        tk.Label(self.admins_tab, text="Password").grid(row=2, column=0, padx=5, pady=5)
        self.admin_password_entry = tk.Entry(self.admins_tab, show="*")
        self.admin_password_entry.grid(row=2, column=1, padx=5, pady=5)

        tk.Button(self.admins_tab, text="Add Admin", command=self.add_admin).grid(row=3, column=1, padx=5, pady=5)

        self.admins_tree = ttk.Treeview(self.admins_tab, columns=("ID", "Username", "Email"), show="headings")
        self.admins_tree.heading("ID", text="Admin ID")
        self.admins_tree.heading("Username", text="Username")
        self.admins_tree.heading("Email", text="Email")
        self.admins_tree.grid(row=4, column=0, columnspan=3, padx=5, pady=5)

        # Bind selection event
        self.admins_tree.bind("<<TreeviewSelect>>", self.on_admin_selected)

        tk.Button(self.admins_tab, text="Edit Selected", command=self.edit_admin).grid(row=5, column=0, padx=5, pady=5)
        tk.Button(self.admins_tab, text="Delete Selected", command=self.delete_admin).grid(row=5, column=1, padx=5, pady=5)

        self.update_admins_tree()

    def on_admin_selected(self, event):
        selected = self.admins_tree.selection()
        if selected:
            # Get the selected admin's values
            values = self.admins_tree.item(selected[0])["values"]
            # Populate the input fields
            self.admin_username_entry.delete(0, tk.END)
            self.admin_username_entry.insert(0, values[1])  # Username
            self.admin_email_entry.delete(0, tk.END)
            self.admin_email_entry.insert(0, values[2])  # Email
            self.admin_password_entry.delete(0, tk.END)
            # Fetch the password from the database (not displayed in Treeview for security)
            self.cursor.execute("SELECT password_hash FROM admins WHERE admin_id = %s", (values[0],))
            password = self.cursor.fetchone()[0]
            self.admin_password_entry.insert(0, password)  # Password
        else:
            # Clear the fields if no item is selected
            self.admin_username_entry.delete(0, tk.END)
            self.admin_email_entry.delete(0, tk.END)
            self.admin_password_entry.delete(0, tk.END)

    def setup_logs_tab(self):
        tk.Label(self.logs_tab, text="Search by Product ID").grid(row=0, column=0, padx=5, pady=5)
        self.log_product_id_entry = tk.Entry(self.logs_tab)
        self.log_product_id_entry.grid(row=0, column=1, padx=5, pady=5)

        tk.Label(self.logs_tab, text="Search by Admin ID").grid(row=1, column=0, padx=5, pady=5)
        self.log_admin_id_entry = tk.Entry(self.logs_tab)
        self.log_admin_id_entry.grid(row=1, column=1, padx=5, pady=5)

        tk.Label(self.logs_tab, text="Search by Action Type").grid(row=2, column=0, padx=5, pady=5)
        self.log_action_type_entry = tk.Entry(self.logs_tab)
        self.log_action_type_entry.grid(row=2, column=1, padx=5, pady=5)

        tk.Button(self.logs_tab, text="Search Logs", command=self.search_logs).grid(row=3, column=1, padx=5, pady=5)
        tk.Button(self.logs_tab, text="Reset Search", command=self.reset_log_filter).grid(row=3, column=2, padx=5, pady=5)

        self.logs_tree = ttk.Treeview(self.logs_tab, columns=("Log ID", "Product ID", "Admin ID", "Action Type", "Timestamp"), show="headings")
        self.logs_tree.heading("Log ID", text="Log ID")
        self.logs_tree.heading("Product ID", text="Product ID")
        self.logs_tree.heading("Admin ID", text="Admin ID")
        self.logs_tree.heading("Action Type", text="Action Type")
        self.logs_tree.heading("Timestamp", text="Timestamp")
        self.logs_tree.grid(row=4, column=0, columnspan=3, padx=5, pady=5)

        self.update_logs_tree()

    def add_category(self):
        name = self.category_name_entry.get()
        if name:
            try:
                self.cursor.execute("INSERT INTO categories (name) VALUES (%s)", (name,))
                self.conn.commit()
                print(f"Added category: {name}")
                self.category_name_entry.delete(0, tk.END)
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error adding category: {e}")
                self.conn.rollback()

    def edit_category(self):
        selected = self.categories_tree.selection()
        if selected:
            category_id = self.categories_tree.item(selected)["values"][0]
            name = self.category_name_entry.get()
            if name:
                try:
                    self.cursor.execute("UPDATE categories SET name = %s WHERE category_id = %s", (name, category_id))
                    self.conn.commit()
                    print(f"Edited category ID {category_id} to name: {name}")
                    self.category_name_entry.delete(0, tk.END)
                    self.update_all_trees()  # Update UI immediately
                except Exception as e:
                    print(f"Error editing category: {e}")
                    self.conn.rollback()

    def delete_category(self):
        selected = self.categories_tree.selection()
        if selected:
            category_id = self.categories_tree.item(selected)["values"][0]
            try:
                self.cursor.execute("DELETE FROM categories WHERE category_id = %s", (category_id,))
                self.conn.commit()
                print(f"Deleted category ID: {category_id}")
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error deleting category: {e}")
                self.conn.rollback()

    def add_product(self):
        name = self.product_name_entry.get()
        description = self.product_desc_entry.get()
        price = self.product_price_entry.get()
        category_name = self.product_category_combo.get()
        picture_url = self.product_picture_entry.get()

        if name and description and price and category_name:
            try:
                self.cursor.execute("SELECT category_id FROM categories WHERE name = %s", (category_name,))
                category_id = self.cursor.fetchone()[0]
                self.cursor.execute(
                    "INSERT INTO products (name, description, price, category_id, picture_url, created_at, updated_at) VALUES (%s, %s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING product_id",
                    (name, description, float(price), category_id, picture_url)
                )
                product_id = self.cursor.fetchone()[0]
                self.conn.commit()
                self.log_action(product_id, "Added")
                print(f"Added product ID: {product_id}, Name: {name}")
                self.product_name_entry.delete(0, tk.END)
                self.product_desc_entry.delete(0, tk.END)
                self.product_price_entry.delete(0, tk.END)
                self.product_picture_entry.delete(0, tk.END)
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error adding product: {e}")
                self.conn.rollback()

    def edit_product(self):
        selected = self.products_tree.selection()
        if selected:
            product_id = self.products_tree.item(selected)["values"][0]
            name = self.product_name_entry.get()
            description = self.product_desc_entry.get()
            price = self.product_price_entry.get()
            category_name = self.product_category_combo.get()
            picture_url = self.product_picture_entry.get()

            if name and description and price and category_name:
                try:
                    self.cursor.execute("SELECT category_id FROM categories WHERE name = %s", (category_name,))
                    category_id = self.cursor.fetchone()[0]
                    self.cursor.execute(
                        "UPDATE products SET name = %s, description = %s, price = %s, category_id = %s, picture_url = %s, updated_at = CURRENT_TIMESTAMP WHERE product_id = %s",
                        (name, description, float(price), category_id, picture_url, product_id)
                    )
                    self.conn.commit()
                    self.log_action(product_id, "Edited")
                    print(f"Edited product ID: {product_id}")
                    self.update_all_trees()  # Update UI immediately
                except Exception as e:
                    print(f"Error editing product: {e}")
                    self.conn.rollback()

    def delete_product(self):
        selected = self.products_tree.selection()
        if selected:
            product_id = self.products_tree.item(selected)["values"][0]
            try:
                # Log the action before deleting the product
                self.log_action(product_id, "Deleted")
                self.cursor.execute("DELETE FROM products WHERE product_id = %s", (product_id,))
                self.conn.commit()
                print(f"Deleted product ID: {product_id}")
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error deleting product: {e}")
                self.conn.rollback()

    def add_variation(self):
        product_name = self.variation_product_combo.get()
        size = self.variation_size_entry.get()
        color = self.variation_color_entry.get()

        if product_name and size and color:
            try:
                self.cursor.execute("SELECT product_id FROM products WHERE name = %s", (product_name,))
                product_id = self.cursor.fetchone()[0]
                self.cursor.execute(
                    "INSERT INTO product_variations (product_id, size, color) VALUES (%s, %s, %s)",
                    (product_id, size, color)
                )
                self.conn.commit()
                self.log_action(product_id, "Added Variation")
                print(f"Added variation for product ID: {product_id}")
                self.variation_size_entry.delete(0, tk.END)
                self.variation_color_entry.delete(0, tk.END)
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error adding variation: {e}")
                self.conn.rollback()

    def edit_variation(self):
        selected = self.variations_tree.selection()
        if selected:
            variation_id = self.variations_tree.item(selected)["values"][0]
            product_name = self.variation_product_combo.get()
            size = self.variation_size_entry.get()
            color = self.variation_color_entry.get()

            if product_name and size and color:
                try:
                    self.cursor.execute("SELECT product_id FROM products WHERE name = %s", (product_name,))
                    product_id = self.cursor.fetchone()[0]
                    self.cursor.execute(
                        "UPDATE product_variations SET product_id = %s, size = %s, color = %s WHERE variation_id = %s",
                        (product_id, size, color, variation_id)
                    )
                    self.conn.commit()
                    self.log_action(product_id, "Edited Variation")
                    print(f"Edited variation ID: {variation_id}")
                    self.update_all_trees()  # Update UI immediately
                except Exception as e:
                    print(f"Error editing variation: {e}")
                    self.conn.rollback()

    def delete_variation(self):
        selected = self.variations_tree.selection()
        if selected:
            variation_id = self.variations_tree.item(selected)["values"][0]
            try:
                self.cursor.execute("SELECT product_id FROM product_variations WHERE variation_id = %s", (variation_id,))
                product_id = self.cursor.fetchone()[0]
                self.cursor.execute("DELETE FROM product_variations WHERE variation_id = %s", (variation_id,))
                self.conn.commit()
                self.log_action(product_id, "Deleted Variation")
                print(f"Deleted variation ID: {variation_id}")
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error deleting variation: {e}")
                self.conn.rollback()

    def add_admin(self):
        username = self.admin_username_entry.get()
        email = self.admin_email_entry.get()
        password = self.admin_password_entry.get()

        if username and email and password:
            try:
                # Debug: Check the current max admin_id
                self.cursor.execute("SELECT MAX(admin_id) FROM admins")
                max_id = self.cursor.fetchone()[0]
                print(f"Current max admin_id: {max_id}")

                self.cursor.execute(
                    "INSERT INTO admins (username, email, password_hash, created_at) VALUES (%s, %s, %s, CURRENT_TIMESTAMP) RETURNING admin_id",
                    (username, email, password)
                )
                new_admin_id = self.cursor.fetchone()[0]
                self.conn.commit()
                print(f"Added admin: ID: {new_admin_id}, Username: {username}, Email: {email}")
                self.admin_username_entry.delete(0, tk.END)
                self.admin_email_entry.delete(0, tk.END)
                self.admin_password_entry.delete(0, tk.END)
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error adding admin: {e}")
                self.conn.rollback()

    def edit_admin(self):
        selected = self.admins_tree.selection()
        if selected:
            admin_id = self.admins_tree.item(selected)["values"][0]
            username = self.admin_username_entry.get()
            email = self.admin_email_entry.get()
            password = self.admin_password_entry.get()

            if username and email and password:
                try:
                    self.cursor.execute(
                        "UPDATE admins SET username = %s, email = %s, password_hash = %s WHERE admin_id = %s",
                        (username, email, password, admin_id)
                    )
                    self.conn.commit()
                    print(f"Edited admin ID: {admin_id}")
                    self.update_all_trees()  # Update UI immediately
                except Exception as e:
                    print(f"Error editing admin: {e}")
                    self.conn.rollback()

    def delete_admin(self):
        selected = self.admins_tree.selection()
        if selected:
            admin_id = self.admins_tree.item(selected)["values"][0]
            try:
                self.cursor.execute("DELETE FROM admins WHERE admin_id = %s", (admin_id,))
                self.conn.commit()
                print(f"Deleted admin ID: {admin_id}")
                self.update_all_trees()  # Update UI immediately
            except Exception as e:
                print(f"Error deleting admin: {e}")
                self.conn.rollback()

    def update_categories_tree(self):
        # Preserve selection
        selected = self.categories_tree.selection()
        selected_values = [self.categories_tree.item(item)["values"] for item in selected] if selected else []

        for item in self.categories_tree.get_children():
            self.categories_tree.delete(item)
        self.cursor.execute("SELECT category_id, name FROM categories")
        for row in self.cursor.fetchall():
            item = self.categories_tree.insert("", tk.END, values=row)
            # Reselect the item if it matches the previously selected values
            if row in selected_values:
                self.categories_tree.selection_add(item)

    def update_products_tree(self):
        # Preserve selection
        selected = self.products_tree.selection()
        selected_values = [self.products_tree.item(item)["values"] for item in selected] if selected else []

        for item in self.products_tree.get_children():
            self.products_tree.delete(item)
        self.cursor.execute("""
            SELECT p.product_id, p.name, p.description, p.price, c.name, p.picture_url
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
        """)
        for row in self.cursor.fetchall():
            item = self.products_tree.insert("", tk.END, values=row)
            # Reselect the item if it matches the previously selected values
            if row in selected_values:
                self.products_tree.selection_add(item)

    def update_variations_tree(self):
        # Preserve selection
        selected = self.variations_tree.selection()
        selected_values = [self.variations_tree.item(item)["values"] for item in selected] if selected else []

        for item in self.variations_tree.get_children():
            self.variations_tree.delete(item)
        self.cursor.execute("""
            SELECT pv.variation_id, p.name, pv.size, pv.color
            FROM product_variations pv
            JOIN products p ON pv.product_id = p.product_id
        """)
        for row in self.cursor.fetchall():
            item = self.variations_tree.insert("", tk.END, values=row)
            # Reselect the item if it matches the previously selected values
            if row in selected_values:
                self.variations_tree.selection_add(item)

    def update_admins_tree(self):
        # Preserve selection
        selected = self.admins_tree.selection()
        selected_values = [self.admins_tree.item(item)["values"] for item in selected] if selected else []

        for item in self.admins_tree.get_children():
            self.admins_tree.delete(item)
        self.cursor.execute("SELECT admin_id, username, email FROM admins")
        for row in self.cursor.fetchall():
            item = self.admins_tree.insert("", tk.END, values=row)
            # Reselect the item if it matches the previously selected values
            if row in selected_values:
                self.admins_tree.selection_add(item)

    def update_category_combo(self):
        self.cursor.execute("SELECT name FROM categories")
        categories = [row[0] for row in self.cursor.fetchall()]
        self.product_category_combo["values"] = categories

    def update_product_combo(self):
        self.cursor.execute("SELECT name FROM products")
        products = [row[0] for row in self.cursor.fetchall()]
        self.variation_product_combo["values"] = products

    def update_logs_tree(self):
        # Preserve selection
        selected = self.logs_tree.selection()
        selected_values = [self.logs_tree.item(item)["values"] for item in selected] if selected else []

        for item in self.logs_tree.get_children():
            self.logs_tree.delete(item)
        try:
            if self.log_filter_applied:
                # Reapply the current filter
                query = "SELECT log_id, product_id, admin_id, action_type, timestamp FROM product_logs WHERE 1=1"
                params = []
                if self.log_filter_product_id:
                    query += " AND product_id = %s"
                    params.append(self.log_filter_product_id)
                if self.log_filter_admin_id:
                    query += " AND admin_id = %s"
                    params.append(self.log_filter_admin_id)
                if self.log_filter_action_type:
                    query += " AND action_type ILIKE %s"
                    params.append(f"%{self.log_filter_action_type}%")
                self.cursor.execute(query, params)
            else:
                # Show all logs
                self.cursor.execute("SELECT log_id, product_id, admin_id, action_type, timestamp FROM product_logs")
            
            for row in self.cursor.fetchall():
                item = self.logs_tree.insert("", tk.END, values=row)
                # Reselect the item if it matches the previously selected values
                if row in selected_values:
                    self.logs_tree.selection_add(item)
        except Exception as e:
            print(f"Error updating logs tree: {e}")
            self.conn.rollback()

    def search_logs(self):
        # Store the current filter parameters
        self.log_filter_product_id = self.log_product_id_entry.get()
        self.log_filter_admin_id = self.log_admin_id_entry.get()
        self.log_filter_action_type = self.log_action_type_entry.get()
        
        # Set the filter applied flag
        self.log_filter_applied = bool(self.log_filter_product_id or self.log_filter_admin_id or self.log_filter_action_type)

        # Update the logs tree with the filter
        self.update_logs_tree()

    def reset_log_filter(self):
        # Clear the filter parameters and flag
        self.log_filter_applied = False
        self.log_filter_product_id = None
        self.log_filter_admin_id = None
        self.log_filter_action_type = None
        
        # Clear the entry fields
        self.log_product_id_entry.delete(0, tk.END)
        self.log_admin_id_entry.delete(0, tk.END)
        self.log_action_type_entry.delete(0, tk.END)
        
        # Update the logs tree to show all logs
        self.update_logs_tree()

    def log_action(self, product_id, action_type):
        try:
            self.cursor.execute(
                "INSERT INTO product_logs (product_id, admin_id, action_type, timestamp) VALUES (%s, %s, %s, CURRENT_TIMESTAMP)",
                (product_id, self.current_admin_id, action_type)
            )
            self.conn.commit()
            print(f"Logged action: Product ID {product_id}, Action: {action_type}")
        except Exception as e:
            print(f"Error logging action: {e}")
            self.conn.rollback()

    def update_all_trees(self):
        self.update_categories_tree()
        self.update_products_tree()
        self.update_variations_tree()
        self.update_admins_tree()
        self.update_logs_tree()
        self.update_category_combo()
        self.update_product_combo()

    def on_closing(self):
        self.conn.close()
        print("Database connection closed.")
        self.root.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    app = AdminGUI(root)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.mainloop()