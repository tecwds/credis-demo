#!/usr/bin/env bash

echo "=== Redis Cluster Setup Script ==="
echo "Waiting for all Redis nodes to be ready..."
sleep 10

echo "Creating Redis cluster..."
# 创建集群：3个主节点，每个主节点有2个从节点
docker exec -it cr-master sh -c "redis-cli -a course_redis --cluster create 10.0.9.10:7001 10.0.9.10:7002 10.0.9.10:7003 10.0.9.11:7001 10.0.9.11:7002 10.0.9.11:7003 10.0.9.12:7001 10.0.9.12:7002 10.0.9.12:7003 --cluster-replicas 2 --cluster-yes"

echo "Checking cluster status..."
docker exec -it cr-master sh -c "redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 cluster nodes"

echo "Cluster info:"
docker exec -it cr-master sh -c "redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 cluster info"

echo "=== Redis Cluster Setup Complete ==="
echo "You can now connect to the cluster using:"
echo "redis-cli -a course_redis -c -h 10.0.9.10 -p 7001"
