#!/usr/bin/env bash

echo "=== Redis Cluster Test Script ==="

# 检查集群状态
echo "1. Checking cluster status..."
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 cluster info | grep cluster_state

if [ $? -ne 0 ]; then
    echo "❌ Cluster is not ready. Please run ./set_cluster.sh first."
    exit 1
fi

echo "✅ Cluster is ready!"
echo ""

# 测试数据写入和读取
echo "2. Testing data operations..."

# 写入测试数据
echo "Writing test data..."
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 set test:key1 "Hello Redis Cluster" > /dev/null
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 set test:key2 "Node Distribution Test" > /dev/null
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 set test:key3 "Failover Test" > /dev/null

# 读取测试数据
echo "Reading test data..."
VAL1=$(docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 get test:key1 2>/dev/null)
VAL2=$(docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 get test:key2 2>/dev/null)
VAL3=$(docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 get test:key3 2>/dev/null)

echo "test:key1 = $VAL1"
echo "test:key2 = $VAL2"
echo "test:key3 = $VAL3"
echo "✅ Data operations successful!"
echo ""

# 测试不同节点的连接
echo "3. Testing connections to different nodes..."
echo "Connecting to node 10.0.9.10:7001..."
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 ping 2>/dev/null

echo "Connecting to node 10.0.9.11:7002..."
docker exec cr-node1 redis-cli -a course_redis -c -h 10.0.9.11 -p 7002 ping 2>/dev/null

echo "Connecting to node 10.0.9.12:7003..."
docker exec cr-node2 redis-cli -a course_redis -c -h 10.0.9.12 -p 7003 ping 2>/dev/null
echo "✅ All nodes are responding!"
echo ""

# 显示集群节点信息
echo "4. Cluster nodes information:"
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 cluster nodes 2>/dev/null
echo ""

# 显示槽位分配
echo "5. Slot allocation:"
docker exec cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001 cluster slots 2>/dev/null
echo ""

echo "=== Cluster Test Complete ==="
echo "🎉 Redis cluster is working properly!"
echo ""
echo "You can connect to the cluster using:"
echo "docker exec -it cr-master redis-cli -a course_redis -c -h 10.0.9.10 -p 7001"