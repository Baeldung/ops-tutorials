# Use a Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python script into the container
COPY script.py .

# Entrypoint for the Python script
ENTRYPOINT ["python", "script.py"]
# CMD to drop into an interactive shell
CMD ["bash"]