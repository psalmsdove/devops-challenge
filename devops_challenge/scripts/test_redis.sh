echo "testing redis connection with docker-compose..."

docker compose exec redis-cache redis-cli ping

if [ $? -eq 0 ]; then
  echo "redis connection successful!"
else
  echo "redis connection failed!"
fi
