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
- **Script Tools**: Bash

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
├── README.md (this file)
```

---



## 🧠 Key Features

- Add/Edit/Delete products, categories, users via Admin GUI
- View product reviews and logs
- Automatic logging of actions into the database
- Image upload support
- Secure password hashing using `passlib`

---

## 📌 Notes

- No deployment tools used; intended for local use
- Make sure PostgreSQL is running locally

---

# FlexWear Fashion Catalog

A modern fashion catalog web application with admin interface and user management.

## Quick Start Guide

### For Windows Users:

1. Download or clone this repository
2. Open Command Prompt as Administrator
3. Navigate to the project directory:
```cmd
cd path\to\Fashion-Catalog-SoftwareDesign
```
4. Run the setup script:
```cmd
setup.bat
```

The script will automatically:
- Install Python if not present
- Install PostgreSQL if not present
- Set up the virtual environment
- Install all dependencies
- Create and populate the database
- Start both the web application and admin GUI

### For macOS Users:

1. Download or clone this repository
2. Open Terminal
3. Navigate to the project directory:
```bash
cd path/to/Fashion-Catalog-SoftwareDesign
```
4. Make the setup script executable:
```bash
chmod +x setup.sh
```
5. Run the setup script:
```bash
./setup.sh
```

The script will automatically:
- Install Homebrew if not present
- Install Python if not present
- Install PostgreSQL if not present
- Set up the virtual environment
- Install all dependencies
- Create and populate the database
- Start both the web application and admin GUI

## What Gets Installed

The setup scripts will check for and install (if needed):

- Python 3.11
- pip (Python package manager)
- PostgreSQL 14
- Required Python packages:
  - FastAPI
  - Uvicorn
  - SQLAlchemy
  - psycopg2-binary
  - And more...

## Accessing the Application

After setup completes successfully:
- The web application will be available at: http://localhost:8000
- The Admin GUI will open automatically in a separate window

## Stopping the Application

### On Windows:
- Close the Command Prompt window, or
- Press Ctrl+C in the Command Prompt

### On macOS:
- Press Ctrl+C in the Terminal window

## Troubleshooting

### Common Issues

1. "Permission Denied" when running setup script:
   - Windows: Run Command Prompt as Administrator
   - macOS: Run `chmod +x setup.sh` before executing

2. PostgreSQL Connection Issues:
   - Ensure no other PostgreSQL instance is running
   - Default password is set to "password"
   - Check if port 5432 is available

3. Python Installation Issues:
   - Windows: Ensure you're using Command Prompt as Administrator
   - macOS: If Homebrew installation fails, visit https://brew.sh for manual installation

4. Admin GUI Not Opening:
   - Ensure tkinter is properly installed
   - Try running Admin_Main.py manually:
     ```bash
     # In fastApiProject directory
     python Admin_Main.py
     ```

### Getting Help

If you encounter any issues:
1. Check the console output for error messages
2. Ensure all prerequisites are properly installed
3. Try running the setup script again
4. Check the project's issue tracker for similar problems

## Manual Setup

If you prefer to set up manually, follow these steps:

1. Install Python 3.11
2. Install PostgreSQL 14
3. Create a virtual environment:
```bash
python -m venv venv
# On Windows:
venv\Scripts\activate
# On macOS:
source venv/bin/activate
```

4. Install dependencies:
```bash
pip install -r requirements.txt
```

5. Create and set up the database:
```bash
psql -U postgres -c "CREATE DATABASE flexwear"
psql -U postgres -d flexwear -f database_dump.sql
```

6. Start the applications:
```bash
cd fastApiProject
# Start Admin GUI
python Admin_Main.py
# In a new terminal
python script.py
```

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---
