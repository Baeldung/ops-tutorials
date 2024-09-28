# Use a Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python script into the container
COPY ../script.py .

# Run the Python script and keep the container running
CMD ["sh", "-c", "python script.py && tail -f /dev/null"]