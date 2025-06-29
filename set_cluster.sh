#!/usr/bin/env bash

echo "=== Redis Cluster Setup Script ==="
echo "Waiting for all Redis nodes to be ready..."
sleep 10

echo "Creating Redis cluster..."
# 创建集群：3个主节点，每个主节点有2个从节点
docker exec -it cr-master sh -c "redis-cli -a course_redis --cluster create 192.168.100.10:7001 192.168.100.10:7002 192.168.100.10:7003 192.168.100.11:7001 192.168.100.11:7002 192.168.100.11:7003 192.168.100.12:7001 192.168.100.12:7002 192.168.100.12:7003 --cluster-replicas 2 --cluster-yes"

echo "Checking cluster status..."
docker exec -it cr-master sh -c "redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster nodes"

echo "Cluster info:"
docker exec -it cr-master sh -c "redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster info"

echo "=== Redis Cluster Setup Complete ==="
echo "You can now connect to the cluster using:"
echo "redis-cli -a course_redis -c -h 192.168.100.10 -p 7001"
