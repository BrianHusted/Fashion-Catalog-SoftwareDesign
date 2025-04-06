#!/bin/bash

echo "📦 Creating database dump..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

# Create dumps directory if it doesn't exist
mkdir -p dumps

# Get current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create the dump
echo "📥 Dumping database schema and data..."
pg_dump -U postgres -d flexwear --clean --if-exists > "dumps/database_dump_${TIMESTAMP}.sql"

# Create a copy as the default dump file
cp "dumps/database_dump_${TIMESTAMP}.sql" database_dump.sql

echo "✅ Database dump created successfully!"
echo "📁 Dumps created:"
echo "  - dumps/database_dump_${TIMESTAMP}.sql (timestamped backup)"
echo "  - database_dump.sql (main dump file)"
echo ""
echo "💡 The main dump file (database_dump.sql) will be used by the setup script." 