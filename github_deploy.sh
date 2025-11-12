#!/bin/bash

# 设置变量
GITHUB_REPO="https://github.com/cjluczy/XYAssistant.git"
PROJECT_DIR="/home/ubuntu/XYAssistant"
VENV_DIR="$PROJECT_DIR/venv"

# 创建项目目录（如果不存在）
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR || exit

# 检查是否已经有git仓库
if [ -d ".git" ]; then
    echo "Updating existing repository..."
    git pull origin main
else
    echo "Cloning repository from GitHub..."
    git clone $GITHUB_REPO .
fi

# 创建虚拟环境（如果不存在）
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $VENV_DIR
fi

# 激活虚拟环境
echo "Activating virtual environment..."
source $VENV_DIR/bin/activate

# 升级pip
echo "Upgrading pip..."
pip install --upgrade pip

# 安装依赖
echo "Installing dependencies..."
pip install -r requirements.txt
pip install gunicorn

# 创建必要的目录
mkdir -p static/uploads

# 启动Gunicorn服务器
echo "Starting Gunicorn server..."
# 停止之前可能运行的进程
pkill -f "gunicorn.*wsgi:app" || true
# 启动新的进程
gunicorn --bind 0.0.0.0:5000 wsgi:app --daemon --workers 3 --timeout 300

echo "Deployment completed successfully!"
echo "Application should be running on http://103.217.187.88:5000"