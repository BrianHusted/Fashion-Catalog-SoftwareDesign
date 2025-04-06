@echo off
echo 🚀 Starting FlexWear Setup...

:: Check for Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo 📥 Python not found. Downloading and installing Python...
    curl -o python_installer.exe https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python_installer.exe
)

:: Check for pip installation
pip --version >nul 2>&1
if errorlevel 1 (
    echo 📥 Installing pip...
    python -m ensurepip --upgrade
)

:: Create virtual environment
echo 📦 Creating virtual environment...
python -m venv venv
call venv\Scripts\activate.bat

:: Install dependencies
echo 📥 Installing dependencies...
pip install fastapi
pip install uvicorn
pip install sqlalchemy
pip install psycopg2-binary
pip install python-multipart
pip install python-jose[cryptography]
pip install passlib[bcrypt]
pip install python-dotenv
pip install aiofiles
pip install jinja2
pip install tk

:: Create .env file if it doesn't exist
if not exist .env (
    echo 🔑 Creating .env file...
    echo DATABASE_URL=postgresql://postgres:password@localhost:5432/flexwear > .env
    echo SECRET_KEY=your-secret-key-here >> .env
    echo ALGORITHM=HS256 >> .env
    echo ACCESS_TOKEN_EXPIRE_MINUTES=30 >> .env
)

:: Check for PostgreSQL installation
psql --version >nul 2>&1
if errorlevel 1 (
    echo 📥 PostgreSQL not found. Downloading and installing PostgreSQL...
    curl -o postgresql_installer.exe https://get.enterprisedb.com/postgresql/postgresql-14.10-1-windows-x64.exe
    postgresql_installer.exe --unattendedmodeui minimal --mode unattended --superpassword "password" --servicename "PostgreSQL"
    del postgresql_installer.exe
    
    :: Add PostgreSQL to PATH
    setx PATH "%PATH%;C:\Program Files\PostgreSQL\14\bin"
    set PATH=%PATH%;C:\Program Files\PostgreSQL\14\bin
)

:: Wait for PostgreSQL to be ready
echo ⏳ Waiting for PostgreSQL to be ready...
:wait_loop
pg_isready >nul 2>&1
if errorlevel 1 (
    echo Waiting for PostgreSQL to start...
    timeout /t 1 /nobreak >nul
    goto wait_loop
)

:: Database setup
echo 🗄️ Setting up database...
psql -U postgres -c "SELECT 1 FROM pg_database WHERE datname = 'flexwear'" | findstr /r "1" >nul
if errorlevel 1 (
    psql -U postgres -c "CREATE DATABASE flexwear"
)

:: Import database dump
echo 📥 Importing database dump...
psql -U postgres -d flexwear -f database_dump.sql

:: Start the applications
echo 🚀 Starting the applications...

:: Change to the fastApiProject directory
cd fastApiProject
if errorlevel 1 (
    echo ❌ Failed to find fastApiProject directory
    exit /b 1
)

:: Start Admin GUI using pythonw
echo 👤 Starting Admin GUI...
start /b pythonw Admin_Main.py

:: Start web application
echo 🌐 Starting main web application...
start /b python script.py

echo ✅ Setup complete!
echo 📝 Note: You can access the web application at: http://localhost:8000
echo The Admin GUI should now be open in a separate window.
echo.
echo To stop the applications, close this window or press Ctrl+C

:: Keep the window open
pause 