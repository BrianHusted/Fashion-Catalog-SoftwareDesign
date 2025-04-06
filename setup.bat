@echo off
setlocal enabledelayedexpansion

echo 🚀 Starting FlexWear Setup...

:: Check for Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo 📥 Python not found. Downloading and installing Python...
    curl -o python_installer.exe https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe
    if errorlevel 1 (
        echo ❌ Failed to download Python installer
        exit /b 1
    )
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    if errorlevel 1 (
        echo ❌ Failed to install Python
        del python_installer.exe
        exit /b 1
    )
    del python_installer.exe
)

:: Check for pip installation
pip --version >nul 2>&1
if errorlevel 1 (
    echo 📥 Installing pip...
    python -m ensurepip --upgrade
    if errorlevel 1 (
        echo ❌ Failed to install pip
        exit /b 1
    )
)

:: Create virtual environment
echo 📦 Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ❌ Failed to create virtual environment
    exit /b 1
)
call "venv\Scripts\activate.bat"
if errorlevel 1 (
    echo ❌ Failed to activate virtual environment
    exit /b 1
)

:: Install dependencies
echo 📥 Installing dependencies...
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-multipart python-jose[cryptography] passlib[bcrypt] python-dotenv aiofiles jinja2 tk
if errorlevel 1 (
    echo ❌ Failed to install dependencies
    exit /b 1
)

:: Create .env file if it doesn't exist
if not exist .env (
    echo 🔑 Creating .env file...
    echo DATABASE_URL=postgresql://postgres@localhost:5432/flexwear > .env
    echo SECRET_KEY=your-secret-key-here >> .env
    echo ALGORITHM=HS256 >> .env
    echo ACCESS_TOKEN_EXPIRE_MINUTES=30 >> .env
)

:: Check for PostgreSQL installation
psql --version >nul 2>&1
if errorlevel 1 (
    echo ❌ PostgreSQL not found in PATH. Please check the README.md for installation instructions.
    exit /b 1
)

:: Database setup
echo 🗄️ Setting up database...
echo Creating database 'flexwear'...
psql -U postgres -c "CREATE DATABASE flexwear;" 2>nul
if errorlevel 1 (
    echo ℹ️ Database might already exist, continuing...
)

:: Import database dump if it exists
if exist database_dump.sql (
    echo 📥 Importing database dump...
    psql -U postgres -d flexwear -f database_dump.sql
    if errorlevel 1 (
        echo ❌ Failed to import database dump
        exit /b 1
    )
) else (
    echo ℹ️ No database dump found. Skipping import.
)

:: Start the applications
echo 🚀 Starting the applications...

:: Check if fastApiProject directory exists
if not exist "fastApiProject" (
    echo ❌ fastApiProject directory not found
    exit /b 1
)

:: Change to the fastApiProject directory
cd "fastApiProject"
if errorlevel 1 (
    echo ❌ Failed to change to fastApiProject directory
    exit /b 1
)

:: Start Admin GUI using pythonw
echo 👤 Starting Admin GUI...
if exist "Admin_Main.py" (
    start /b pythonw "Admin_Main.py"
) else (
    echo ❌ Admin_Main.py not found
    exit /b 1
)

:: Start web application
echo 🌐 Starting main web application...
if exist "script.py" (
    start /b python "script.py"
) else (
    echo ❌ script.py not found
    exit /b 1
)

echo ✅ Setup complete!
echo 📝 Note: You can access the web application at: http://localhost:8000
echo The Admin GUI should now be open in a separate window.
echo.
echo To stop the applications, close this window or press Ctrl+C

:: Keep the window open
pause 