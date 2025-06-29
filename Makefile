.PHONY: help up down restart logs clean setup test status connect

# 默认目标
help:
	@echo "Redis Cluster Docker Management"
	@echo "================================"
	@echo "Available commands:"
	@echo "  make up        - Start the Redis cluster"
	@echo "  make down      - Stop the Redis cluster"
	@echo "  make restart   - Restart the Redis cluster"
	@echo "  make setup     - Initialize the Redis cluster"
	@echo "  make test      - Test the Redis cluster"
	@echo "  make status    - Show cluster status"
	@echo "  make logs      - Show container logs"
	@echo "  make connect   - Connect to Redis cluster"
	@echo "  make clean     - Clean up everything (including volumes)"
	@echo "  make help      - Show this help message"

# 启动集群
up:
	@echo "Starting Redis cluster..."
	docker compose up -d
	@echo "Waiting for containers to be ready..."
	sleep 10
	@echo "Cluster containers started!"

# 停止集群
down:
	@echo "Stopping Redis cluster..."
	docker compose down

# 重启集群
restart: down up

# 初始化集群
setup:
	@echo "Setting up Redis cluster..."
	@if [ ! -f "./set_cluster.sh" ]; then echo "Error: set_cluster.sh not found"; exit 1; fi
	chmod +x ./set_cluster.sh
	./set_cluster.sh

# 测试集群
test:
	@echo "Testing Redis cluster..."
	@if [ ! -f "./test_cluster.sh" ]; then echo "Error: test_cluster.sh not found"; exit 1; fi
	chmod +x ./test_cluster.sh
	./test_cluster.sh

# 查看集群状态
status:
	@echo "Redis Cluster Status:"
	@echo "====================="
	docker compose ps
	@echo ""
	@echo "Cluster Info:"
	@docker exec cr-master redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster info 2>/dev/null || echo "Cluster not initialized yet"

# 查看日志
logs:
	@echo "Container logs:"
	docker compose logs --tail=50

# 连接到集群
connect:
	@echo "Connecting to Redis cluster..."
	@echo "Use 'exit' to disconnect"
	docker exec -it cr-master redis-cli -a course_redis -c -h 192.168.100.10 -p 7001

# 清理所有资源
clean:
	@echo "Cleaning up Redis cluster..."
	docker compose down -v
	docker system prune -f
	@echo "Cleanup complete!"

# 完整部署（启动 + 初始化 + 测试）
deploy: up setup test
	@echo "Redis cluster deployment complete!"