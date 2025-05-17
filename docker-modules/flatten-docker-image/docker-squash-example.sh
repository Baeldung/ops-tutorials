# Install Python and Pip
sudo apt install python3
sudo apt install python3-pip

# Create and activate a virtual environment
python3 -m venv docker-squash-env
source docker-squash-env/bin/activate

# Install docker-squash
pip install docker-squash

# Use docker-squash
docker-squash 
-t mysql:squashed 
mysql
