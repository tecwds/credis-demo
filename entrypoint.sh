#!/usr/bin/env bash

# 创建必要的目录
mkdir -p /var/log/redis
mkdir -p /usr/lib/redis/cluster/redis_7001
mkdir -p /usr/lib/redis/cluster/redis_7002
mkdir -p /usr/lib/redis/cluster/redis_7003

# 启动 Redis 服务
echo "Starting Redis servers..."
redis-server /etc/redis/conf.d/redis_7001.conf
redis-server /etc/redis/conf.d/redis_7002.conf
redis-server /etc/redis/conf.d/redis_7003.conf

# 等待 Redis 服务启动
sleep 5

# 检查 Redis 服务状态
echo "Checking Redis servers status..."
ps aux | grep redis-server

# 保持容器运行
echo "Redis cluster nodes started successfully!"
echo "Use 'docker exec -it <container_name> bash' to access the container"
echo "Use './set_cluster.sh' to initialize the cluster"

# 保持前台进程运行
tail -f /dev/null
