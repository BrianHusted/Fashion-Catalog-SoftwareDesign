#!/bin/bash

# Start the FastAPI server in the background.
uvicorn script:app --host 127.0.0.1 --port 8000 &
SERVER_PID=$!

# Wait a moment to ensure the server is up.
sleep 2

# Open the default browser to your app's URL.
# On Linux, this typically uses xdg-open. For macOS, use "open", and on Windows "start".
open http://127.0.0.1:8000

# Wait for user input to shut down the server.
read -p "Press Enter to stop the server..."

# Kill the server process.
kill $SERVER_PID
