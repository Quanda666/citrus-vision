#!/bin/bash

# CitrusVision 停止脚本

set -e

echo "========================================="
echo "  停止 CitrusVision 服务"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 停止服务
stop_service() {
    SERVICE_NAME=$1
    PID_FILE="logs/${SERVICE_NAME}.pid"

    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "停止 ${SERVICE_NAME} (PID: $PID)..."
            kill "$PID"
            rm "$PID_FILE"
            echo -e "${GREEN}✅ ${SERVICE_NAME} 已停止${NC}"
        else
            echo -e "${RED}⚠️  ${SERVICE_NAME} 进程不存在${NC}"
            rm "$PID_FILE"
        fi
    else
        echo "未找到 ${SERVICE_NAME} PID 文件"
    fi
}

# 停止所有服务
stop_service "backend"
stop_service "algorithm"
stop_service "frontend"

echo ""
echo "========================================="
echo "  所有服务已停止"
echo "========================================="
