#!/bin/bash

echo "🚀 Starting FlexWear Setup..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OS" == "Windows_NT" ]]; then
    OS_TYPE="windows"
else
    echo "❌ Unsupported operating system"
    exit 1
fi

# Function to install Python on macOS
install_python_macos() {
    echo "📥 Installing Python using Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python@3.11
    brew install pip3
}

# Function to install Python on Windows
install_python_windows() {
    echo "📥 Downloading Python installer..."
    curl -o python_installer.exe https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe
    echo "📦 Installing Python..."
    ./python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    rm python_installer.exe
}

# Function to install PostgreSQL on macOS
install_postgresql_macos() {
    echo "📥 Installing PostgreSQL using Homebrew..."
    brew install postgresql@14
    echo "🎉 Starting PostgreSQL service..."
    brew services start postgresql@14
}

# Function to install PostgreSQL on Windows
install_postgresql_windows() {
    echo "📥 Downloading PostgreSQL installer..."
    curl -o postgresql_installer.exe https://get.enterprisedb.com/postgresql/postgresql-14.10-1-windows-x64.exe
    echo "📦 Installing PostgreSQL..."
    ./postgresql_installer.exe --unattendedmodeui minimal --mode unattended --superpassword "password" --servicename "PostgreSQL"
    rm postgresql_installer.exe
    
    # Add PostgreSQL to PATH
    echo "🔄 Adding PostgreSQL to PATH..."
    export PATH=$PATH:"/c/Program Files/PostgreSQL/14/bin"
    [[ ":$PATH:" != *":/c/Program Files/PostgreSQL/14/bin:"* ]] && export PATH="/c/Program Files/PostgreSQL/14/bin:$PATH"
}

# Check and install Python if needed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Installing now..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        install_python_macos
    else
        install_python_windows
    fi
fi

# Check and install pip if needed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Installing now..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        brew install pip3
    else
        python3 -m ensurepip --upgrade
    fi
fi

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment based on OS
if [[ "$OS_TYPE" == "windows" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

# Install dependencies
echo "📥 Installing dependencies..."
pip3 install fastapi
pip3 install uvicorn
pip3 install sqlalchemy
pip3 install psycopg2-binary
pip3 install python-multipart
pip3 install python-jose[cryptography]
pip3 install passlib[bcrypt]
pip3 install python-dotenv
pip3 install aiofiles
pip3 install jinja2
pip3 install tk  # Adding tkinter for GUI

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "🔑 Creating .env file..."
    cat > .env << EOL
DATABASE_URL=postgresql://postgres:password@localhost:5432/flexwear
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
EOL
fi

# Check and install PostgreSQL if needed
if ! command -v psql &> /dev/null; then
    echo "📥 PostgreSQL is not installed. Installing now..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        install_postgresql_macos
    else
        install_postgresql_windows
    fi
fi

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
max_attempts=30
attempt=1
while ! pg_isready &> /dev/null && [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts: Waiting for PostgreSQL to start..."
    sleep 1
    attempt=$((attempt + 1))
done

if ! pg_isready &> /dev/null; then
    echo "❌ PostgreSQL failed to start. Please check your installation."
    exit 1
fi

# Database setup
echo "🗄️ Setting up database..."

# Create database if it doesn't exist
if [[ "$OS_TYPE" == "windows" ]]; then
    # For Windows, use the full path to psql
    PSQL="/c/Program Files/PostgreSQL/14/bin/psql.exe"
    "$PSQL" -U postgres -c "SELECT 1 FROM pg_database WHERE datname = 'flexwear'" | grep -q 1 || "$PSQL" -U postgres -c "CREATE DATABASE flexwear"
    "$PSQL" -U postgres -d flexwear -f database_dump.sql
else
    # For macOS
    psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'flexwear'" | grep -q 1 || psql -U postgres -c "CREATE DATABASE flexwear"
    psql -U postgres -d flexwear -f database_dump.sql
fi

# Start the application
echo "🚀 Starting the applications..."

# Change to the fastApiProject directory
cd fastApiProject || {
    echo "❌ Failed to find fastApiProject directory"
    exit 1
}

# Start the applications based on OS
if [[ "$OS_TYPE" == "windows" ]]; then
    # Windows: Start using pythonw for GUI
    echo "👤 Starting Admin GUI..."
    pythonw Admin_Main.py &
    ADMIN_PID=$!
    
    echo "🌐 Starting main web application..."
    python script.py &
    SCRIPT_PID=$!
else
    # macOS
    echo "👤 Starting Admin GUI..."
    python3 Admin_Main.py &
    ADMIN_PID=$!
    
    echo "🌐 Starting main web application..."
    python3 script.py &
    SCRIPT_PID=$!
fi

# Wait for both processes
wait $ADMIN_PID $SCRIPT_PID

echo "✅ Setup complete!"
echo "📝 Note: You can access the web application at: http://localhost:8000"
echo "The Admin GUI should now be open in a separate window."
echo ""
echo "To stop all applications, press Ctrl+C"

# Trap Ctrl+C and cleanup
trap 'kill $ADMIN_PID $SCRIPT_PID; exit' INT 