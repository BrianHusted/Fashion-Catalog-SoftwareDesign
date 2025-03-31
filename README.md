
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

## 🚀 How to Run

### 1. Setup PostgreSQL
Create a database named `flexwear` in PostgreSQL. Update connection credentials inside the Python files if necessary.

```bash
psql -U postgres
CREATE DATABASE flexwear;
```

Then load schema and data:

```bash
\i db.sql
\i flexwear_dump.sql
```

### 2. Install Python Dependencies
```bash
pip install fastapi uvicorn sqlalchemy psycopg2-binary passlib python-multipart pydantic
```

### 3. Run FastAPI Backend
```bash
cd fastApiProject
uvicorn script:app --reload
```
Visit the Fashion Catalog at: [http://127.0.0.1:8000](http://127.0.0.1:8000)
Visit the API docs at: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

### 4. Run the Admin GUI
```bash
python Admin_Main.py
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

## 📄 License

For academic use only.
