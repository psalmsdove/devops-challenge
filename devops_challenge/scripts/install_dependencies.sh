
set -e 

echo "installing docker and docker compose"

sudo apt-get update

sudo apt-get install -y docker.io

sudo systemctl start docker
sudo systemctl enable docker

sudo apt-get install -y docker-compose-plugin

docker --version
docker compose version

echo "installed docker and docker compose successfully"
echo "to start docker compose: 'docker compose up -d'"
