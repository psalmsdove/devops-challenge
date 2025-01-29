echo "testing postgres connection in container..."

docker exec -i postgres-db psql -U admin -d devops_db -c "CREATE TABLE IF NOT EXISTS test_table (id SERIAL PRIMARY KEY, name VARCHAR(50));"
docker exec -i postgres-db psql -U admin -d devops_db -c "INSERT INTO test_table (name) VALUES ('test_data');"
docker exec -i postgres-db psql -U admin -d devops_db -c "SELECT * FROM test_table;"

echo "test completed."
