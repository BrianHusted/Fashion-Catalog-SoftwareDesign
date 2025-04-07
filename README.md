# 🧵 Fashion Catalog Software Design Project

This project is a full-stack application developed for managing and exploring fashion products. It features a PostgreSQL-backed FastAPI application for managing users, products, categories, and more, with a GUI-based admin interface built using Tkinter.

---

## 🛠️ Tech Stack

- **Backend**: FastAPI (Python)
- **GUI Admin Panel**: Tkinter
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy
- **Password Handling**: Passlib
- **Testing**: HTTP requests via `.http` files
- **Script Tools**: Bash (macOS) / Batch (Windows)

---

## 📂 Project Structure

```
Fashion-Catalog-SoftwareDesign/
│
├── fastApiProject/
│   ├── Admin_Main.py          # Tkinter-based Admin GUI
│   ├── db_classes.py          # SQLAlchemy ORM models
│   ├── script.py              # FastAPI backend
│   ├── db.sql                 # Initial DB schema
│   ├── flexwear_dump.sql      # Sample data dump
│   ├── test_main.http         # HTTP test routes
│   └── run.sh                 # Run server and open browser
│
├── setup.bat                  # Windows setup script
├── setup.sh                   # macOS setup script
└── README.md (this file)
```

---

## 🧠 Key Features

- Add/Edit/Delete products, categories, users via Admin GUI
- View product reviews and logs
- Automatic logging of actions into the database
- Image upload support
- Secure password hashing using `passlib`

---

## 🚀 Quick Start

### For Windows Users:

1. **Prerequisites**
   - Install [Python 3.11 or later](https://www.python.org/downloads/windows/)
     - During installation, check "Add Python to PATH"
   - Install [PostgreSQL](https://www.postgresql.org/download/windows/)
     - Use port: 5432
     - Set password to: postgres
     - Keep default superuser: postgres
     - Add to PATH: `C:\Program Files\PostgreSQL\14\bin`

2. **Setup**
   - Double-click `setup.bat`
   - Follow the on-screen instructions
   - **Note**: Admin credentials will be displayed in the terminal when the application starts

### For macOS Users:

1. **Prerequisites**
   - Install [Python 3.11 or later](https://www.python.org/downloads/macos/)
   - Install [Homebrew](https://brew.sh/) (if not already installed)
   - PostgreSQL will be installed automatically by the setup script

2. **Setup**
   - Open Terminal
   - Navigate to project directory:
     ```bash
     cd path/to/Fashion-Catalog-SoftwareDesign
     ```
   - Make setup script executable:
     ```bash
     chmod +x setup.sh
     ```
   - Run setup script:
     ```bash
     ./setup.sh
     ```
   - **Note**: Admin credentials will be displayed in the terminal when the application starts

## 📌 Accessing the Application

After successful setup:
- Web Application: http://localhost:8000
- Admin GUI: Opens automatically in a separate window
- **Important**: Check the terminal for admin login credentials

## 🛠️ Troubleshooting

### Common Issues

1. **PostgreSQL Connection Issues**
   - Windows:
     - Verify PostgreSQL is running
     - Check port 5432 is not in use
     - Confirm password is "postgres"
   - macOS:
     - Run `brew services start postgresql@14`
     - Check status with `brew services list`

2. **Python/Pip Issues**
   - Verify Python installation:
     ```bash
     python --version  # Windows
     python3 --version # macOS
     ```
   - Check PATH settings

3. **Application Not Starting**
   - Check if all dependencies are installed
   - Verify database connection in .env file
   - Ensure port 8000 is available
   - Make sure to check the terminal for any error messages

4. **Admin GUI Not Opening**
   - Check the terminal for any error messages
   - Verify that the admin credentials are displayed
   - Make sure tkinter is properly installed

## ⏹️ Stopping the Applications

- Windows: Close Command Prompt or press Ctrl+C
- macOS: Press Ctrl+C in Terminal

## 📝 Notes

- No deployment tools used; intended for local use
- Make sure PostgreSQL is running locally
- For macOS users, Homebrew is required for PostgreSQL installation
- Admin credentials are automatically generated and displayed in the terminal
- Keep the terminal window open to see the admin credentials and any error messages

## 🤝 Support

If you need additional help, please contact the development team.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

# FlexWear Fashion Catalog

A modern fashion catalog management system with admin interface and web application.

## Prerequisites

Before running the setup script, please ensure you have the following installed:

1. **Python 3.11 or later**
   - Download from: [Python Official Website](https://www.python.org/downloads/)
   - During installation, make sure to check "Add Python to PATH"

2. **PostgreSQL**
   - Download from: [PostgreSQL Official Website](https://www.postgresql.org/download/windows/)
   - During installation:
     - Use port: 5432
     - Set password to: postgres
     - Keep the default superuser: postgres
   - After installation:
     - Add PostgreSQL to your system PATH:
       - Add this to your PATH: `C:\Program Files\PostgreSQL\14\bin`
       - (Replace 14 with your PostgreSQL version number)
     - To add to PATH:
       1. Open System Properties (Win + Pause/Break)
       2. Click "Advanced system settings"
       3. Click "Environment Variables"
       4. Under "System variables", find and select "Path"
       5. Click "Edit"
       6. Click "New"
       7. Add the PostgreSQL bin path
       8. Click "OK" on all windows

## Setup Instructions

1. **Download the Project**
   - Download and extract the project files to your desired location

2. **Run the Setup Script**
   - Double-click `setup.bat` to start the setup process
   - The script will:
     - Create a Python virtual environment
     - Install all required dependencies
     - Set up the database
     - Start the applications

3. **Access the Applications**
   - Web Application: http://localhost:8000
   - Admin GUI: Will open automatically in a separate window

## Troubleshooting

If you encounter any issues:

1. **PostgreSQL Connection Issues**
   - Make sure PostgreSQL is running
   - Verify the port (5432) is not in use
   - Check if the password is set to "postgres"

2. **Python/Pip Issues**
   - Make sure Python is added to PATH
   - Try running `python --version` in Command Prompt to verify installation

3. **Application Not Starting**
   - Check if all dependencies are installed correctly
   - Verify the database connection in the .env file
   - Make sure no other applications are using port 8000

## Stopping the Applications

- Close the Command Prompt window
- Or press Ctrl+C in the Command Prompt window

## Support

If you need additional help, please contact the development team.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

# Fashion Catalog System

A comprehensive fashion catalog management system with user and admin interfaces, built with FastAPI, PostgreSQL, and modern web technologies.

## Key Features

### User Features
- **Product Browsing**: View products with detailed information including:
  - Product images
  - Descriptions
  - Categories
  - Price information
  - Available variations (size and color)
- **Product Variations**: View available size and color options for each product
- **Wishlist Management**: Save favorite products for later
- **User Reviews**: 
  - Rate products (1-5 stars)
  - Add detailed comments
  - View average ratings
  - See review history with timestamps
- **User Preferences**: Save preferred sizes and colors by category

### Admin Features
- **Complete Product Management**:
  - Add new products
  - Edit existing products
  - Delete products (automatically removes associated variations)
  - Upload product images
- **Category Management**:
  - Create categories
  - Edit categories
  - Delete categories
- **Variation Management**:
  - Add size and color variations
  - Edit existing variations
  - Delete variations
- **Admin User Management**:
  - Create admin accounts
  - Manage admin permissions
- **Comprehensive Logging**:
  - Track all product-related actions
  - View logs by product ID
  - Filter logs by admin ID
  - Search by action type
  - Timestamp tracking for all changes

### Database Features
- **Relational Database Structure**:
  - Products table with category relationships
  - Product variations with size and color options
  - User accounts and preferences
  - Review system with ratings and comments
  - Wishlist functionality
  - Comprehensive logging system
- **Data Integrity**:
  - Cascading deletes for product variations
  - Foreign key constraints
  - Unique indexes for data consistency
  - Automatic timestamp tracking

### Technical Features
- **Modern Web Stack**:
  - FastAPI backend
  - PostgreSQL database
  - Responsive frontend
  - RESTful API endpoints
- **Security**:
  - Password hashing
  - Admin authentication
  - User session management
- **Error Handling**:
  - Graceful fallbacks
  - Comprehensive logging
  - User-friendly error messages

## Database Schema

The system uses a PostgreSQL database with the following main tables:

1. **users**: User account information
2. **categories**: Product categories
3. **products**: Main product information
4. **product_variations**: Size and color options
5. **user_preferences**: User size and color preferences
6. **wishlist**: Saved products
7. **reviews**: Product ratings and comments
8. **admins**: Admin user accounts
9. **product_logs**: Action tracking and auditing

## Setup Instructions

1. Install PostgreSQL and create a new database
2. Clone the repository
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Set up the database:
   ```bash
   psql -U your_username -d your_database -f db.sql
   ```
5. Configure environment variables:
   - DATABASE_URL
   - SECRET_KEY
   - ADMIN_EMAIL
   - ADMIN_PASSWORD

6. Start the application:
   ```bash
   uvicorn script:app --reload
   ```

## Usage

### Admin Interface
Access the admin interface at `/admin` to:
- Manage products and categories
- View and filter logs
- Manage admin users
- Monitor system activity

### User Interface
The main interface allows users to:
- Browse products by category
- View product details and variations
- Save products to wishlist
- Leave reviews and ratings
- Manage preferences

## Security Notes
- All passwords are hashed before storage
- Admin actions are logged for auditing
- User sessions are managed securely
- API endpoints are protected with authentication

## Contributing
Feel free to submit issues and enhancement requests!

---
