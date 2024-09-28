# script.py

# Add any changes here
# For example, creating a file in the container
with open("/app/output.txt", "w") as f:
    f.write("This file was created by script.py inside the Docker container.\n")