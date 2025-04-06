#!/bin/bash

echo "🚀 Starting FlexWear Setup..."

# Check for Python installation
if ! command -v python3 &> /dev/null; then
    echo "📥 Python not found. Please install Python 3.11 or later from https://www.python.org/downloads/macos/"
    exit 1
fi

# Check for Homebrew installation
if ! command -v brew &> /dev/null; then
    echo "📥 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check for PostgreSQL installation
if ! command -v psql &> /dev/null; then
    echo "📥 Installing PostgreSQL..."
    brew install postgresql@14
    brew services start postgresql@14
    
    # Wait for PostgreSQL to start
    echo "⏳ Waiting for PostgreSQL to start..."
    for i in {1..30}; do
        if pg_isready -q; then
            break
        fi
        echo "Waiting for PostgreSQL to start... ($i/30)"
        sleep 1
    done
fi

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "❌ Failed to create virtual environment"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "❌ Failed to activate virtual environment"
    exit 1
fi

# Install dependencies
echo "📥 Installing dependencies..."
pip install fastapi uvicorn sqlalchemy psycopg2-binary python-multipart python-jose[cryptography] passlib[bcrypt] python-dotenv aiofiles jinja2 tk
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "🔑 Creating .env file..."
    echo "DATABASE_URL=postgresql://postgres@localhost:5432/flexwear" > .env
    echo "SECRET_KEY=your-secret-key-here" >> .env
    echo "ALGORITHM=HS256" >> .env
    echo "ACCESS_TOKEN_EXPIRE_MINUTES=30" >> .env
fi

# Database setup
echo "🗄️ Setting up database..."
psql -U postgres -c "CREATE DATABASE flexwear;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ℹ️ Database might already exist, continuing..."
fi

# Import database dump if it exists
if [ -f database_dump.sql ]; then
    echo "📥 Importing database dump..."
    psql -U postgres -d flexwear -f database_dump.sql
    if [ $? -ne 0 ]; then
        echo "❌ Failed to import database dump"
        exit 1
    fi
else
    echo "ℹ️ No database dump found. Skipping import."
fi

# Start the applications
echo "🚀 Starting the applications..."

# Check if fastApiProject directory exists
if [ ! -d "fastApiProject" ]; then
    echo "❌ fastApiProject directory not found"
    exit 1
fi

# Change to the fastApiProject directory
cd fastApiProject
if [ $? -ne 0 ]; then
    echo "❌ Failed to change to fastApiProject directory"
    exit 1
fi

# Start Admin GUI
echo "👤 Starting Admin GUI..."
if [ -f "Admin_Main.py" ]; then
    python3 Admin_Main.py &
else
    echo "❌ Admin_Main.py not found"
    exit 1
fi

# Start web application
echo "🌐 Starting main web application..."
if [ -f "script.py" ]; then
    python3 script.py &
else
    echo "❌ script.py not found"
    exit 1
fi

echo "✅ Setup complete!"
echo "📝 Note: You can access the web application at: http://localhost:8000"
echo "The Admin GUI should now be open in a separate window."
echo ""
echo "To stop the applications, press Ctrl+C"

# Keep the script running
wait 