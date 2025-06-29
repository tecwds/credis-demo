# Redis 集群 Docker 演示项目

这个项目使用 Docker Compose 来模拟一个 Redis 集群环境，包含 3 个节点，每个节点运行 3 个 Redis 实例。

## 项目结构

```
credis-demo/
├── compose.yml          # Docker Compose 配置文件
├── entrypoint.sh        # 容器启动脚本
├── set_cluster.sh       # 集群初始化脚本
├── conf/                # Redis 配置文件目录
│   ├── redis_7001.conf  # Redis 7001 端口配置
│   ├── redis_7002.conf  # Redis 7002 端口配置
│   └── redis_7003.conf  # Redis 7003 端口配置
└── README.md           # 项目说明文档
```

## 集群架构

- **3 个 Docker 容器**：cr-master, cr-node1, cr-node2
- **9 个 Redis 实例**：每个容器运行 3 个 Redis 实例（端口 7001, 7002, 7003）
- **网络配置**：使用自定义网络 `redis-cluster-net`
  - cr-master: 192.168.100.10
  - cr-node1: 192.168.100.11
  - cr-node2: 192.168.100.12

## 快速开始

### 1. 启动集群

```bash
# 启动所有容器
docker-compose up -d

# 查看容器状态
docker-compose ps
```

### 2. 初始化 Redis 集群

```bash
# 运行集群初始化脚本
./set_cluster.sh
```

### 3. 连接到集群

```bash
# 连接到集群
docker exec -it cr-master redis-cli -a course_redis -c -h 192.168.100.10 -p 7001

# 或者从宿主机连接（需要安装 redis-cli）
redis-cli -a course_redis -c -h localhost -p 7001
```

## 常用命令

### 集群管理

```bash
# 查看集群节点信息
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster nodes

# 查看集群信息
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster info

# 查看集群槽位分配
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 cluster slots
```

### 数据操作测试

```bash
# 设置键值对（会自动路由到正确的节点）
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 set key1 "value1"
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 set key2 "value2"
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 set key3 "value3"

# 获取键值对
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 get key1
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 get key2
redis-cli -a course_redis -c -h 192.168.100.10 -p 7001 get key3
```

## 配置说明

### Redis 配置

- **密码**：`course_redis`
- **集群模式**：已启用
- **持久化**：AOF 模式
- **超时时间**：15000ms

### 网络配置

- **子网**：192.168.100.0/24
- **IP 范围**：192.168.100.0/24
- **网关**：192.168.100.1

## 故障排除

### 查看容器日志

```bash
# 查看特定容器日志
docker logs cr-master
docker logs cr-node1
docker logs cr-node2

# 实时查看日志
docker logs -f cr-master
```

### 进入容器调试

```bash
# 进入容器
docker exec -it cr-master bash

# 查看 Redis 进程
ps aux | grep redis

# 查看 Redis 日志
tail -f /var/log/redis/cluster_redis_7001.log
```

### 重新初始化集群

```bash
# 停止并删除容器
docker-compose down

# 删除数据卷（注意：这会删除所有数据）
docker volume rm credis-demo_r-master-d credis-demo_r-node1-d credis-demo_r-node2-d

# 重新启动
docker-compose up -d

# 重新初始化集群
./set_cluster.sh
```

## 注意事项

1. 确保 Docker 和 Docker Compose 已正确安装
2. 确保端口 7001-7003 未被其他服务占用
3. 集群初始化需要一些时间，请耐心等待
4. 生产环境中请修改默认密码
5. 建议在生产环境中使用更安全的网络配置

## 许可证

本项目仅用于学习和演示目的。