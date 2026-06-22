#!/bin/bash

# CitrusVision 本地一键启动脚本
# 用于开发/演示环境快速启动所有服务

set -e

echo "========================================="
echo "  CitrusVision 本地启动脚本"
echo "========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查依赖
check_dependencies() {
    echo "🔍 检查依赖..."

    # 检查 Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python 3 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Python 3: $(python3 --version)${NC}"

    # 检查 Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js 未安装${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"

    # 检查 MySQL
    if ! command -v mysql &> /dev/null; then
        echo -e "${YELLOW}⚠️  MySQL 命令未找到，请确保 MySQL 已启动${NC}"
    else
        echo -e "${GREEN}✅ MySQL 已安装${NC}"
    fi

    echo ""
}

# 初始化数据库
init_database() {
    echo "📊 初始化数据库..."

    read -p "是否初始化数据库？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "MySQL 用户名 [root]: " MYSQL_USER
        MYSQL_USER=${MYSQL_USER:-root}

        read -sp "MySQL 密码: " MYSQL_PASS
        echo ""

        mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" < database/schema.sql
        mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" < database/seed.sql

        echo -e "${GREEN}✅ 数据库初始化完成${NC}"
    else
        echo "跳过数据库初始化"
    fi
    echo ""
}

# 启动后端服务
start_backend() {
    echo "🚀 启动后端服务..."

    cd backend

    # 创建虚拟环境（如果不存在）
    if [ ! -d "venv" ]; then
        echo "创建 Python 虚拟环境..."
        python3 -m venv venv
    fi

    # 激活虚拟环境
    source venv/bin/activate || source venv/Scripts/activate

    # 安装依赖
    if [ ! -f "venv/.installed" ]; then
        echo "安装 Python 依赖..."
        pip install -r requirements.txt
        touch venv/.installed
    fi

    # 启动服务（后台运行）
    echo "启动 FastAPI 后端..."
    nohup uvicorn main:app --host 0.0.0.0 --port 8000 > ../logs/backend.log 2>&1 &
    echo $! > ../logs/backend.pid

    cd ..
    echo -e "${GREEN}✅ 后端服务已启动 (PID: $(cat logs/backend.pid))${NC}"
    echo "   访问: http://localhost:8000/docs"
    echo ""
}

# 启动算法服务
start_algorithm() {
    echo "🤖 启动算法服务..."

    cd algorithm-service

    # 创建虚拟环境（如果不存在）
    if [ ! -d "venv" ]; then
        echo "创建 Python 虚拟环境..."
        python3 -m venv venv
    fi

    # 激活虚拟环境
    source venv/bin/activate || source venv/Scripts/activate

    # 安装依赖
    if [ ! -f "venv/.installed" ]; then
        echo "安装 Python 依赖..."
        pip install -r requirements.txt
        touch venv/.installed
    fi

    # 检查模型文件
    if [ ! -f "weights/best.pt" ]; then
        echo -e "${YELLOW}⚠️  模型文件 weights/best.pt 不存在${NC}"
        echo "   首次运行将使用预训练模型"
    fi

    # 启动服务（后台运行）
    echo "启动算法服务..."
    nohup uvicorn server:app --host 0.0.0.0 --port 8001 > ../logs/algorithm.log 2>&1 &
    echo $! > ../logs/algorithm.pid

    cd ..
    echo -e "${GREEN}✅ 算法服务已启动 (PID: $(cat logs/algorithm.pid))${NC}"
    echo ""
}

# 启动前端服务
start_frontend() {
    echo "🎨 启动前端服务..."

    cd frontend

    # 安装依赖
    if [ ! -d "node_modules" ]; then
        echo "安装 Node.js 依赖..."
        npm install
    fi

    # 启动服务（后台运行）
    echo "启动 Vite 开发服务器..."
    nohup npm run dev > ../logs/frontend.log 2>&1 &
    echo $! > ../logs/frontend.pid

    cd ..
    echo -e "${GREEN}✅ 前端服务已启动 (PID: $(cat logs/frontend.pid))${NC}"
    echo "   访问: http://localhost:5173"
    echo ""
}

# 显示状态
show_status() {
    echo "========================================="
    echo "  🎉 所有服务已启动完成！"
    echo "========================================="
    echo ""
    echo "服务地址："
    echo "  • 前端:      http://localhost:5173"
    echo "  • 后端 API:  http://localhost:8000"
    echo "  • API 文档:  http://localhost:8000/docs"
    echo "  • 算法服务:  http://localhost:8001"
    echo ""
    echo "日志文件："
    echo "  • 后端:   logs/backend.log"
    echo "  • 算法:   logs/algorithm.log"
    echo "  • 前端:   logs/frontend.log"
    echo ""
    echo "停止服务: ./deploy/stop_local.sh"
    echo "查看日志: tail -f logs/*.log"
    echo ""
}

# 创建日志目录
mkdir -p logs

# 主流程
check_dependencies
init_database
start_backend
sleep 2
start_algorithm
sleep 2
start_frontend
sleep 2
show_status
