#!/usr/bin/env bash

# 设置集群
docker exec -it cr-master sh -c "redis-cli -a course_redis --cluster create 10.0.9.10:7001 10.0.9.10:7002 10.0.9.10:7003 10.0.9.11:7001 10.0.9.11:7002 10.0.9.11:7003 10.0.9.12:7001 10.0.9.12:7002 10.0.9.12:7003 --cluster-replicas 2"
