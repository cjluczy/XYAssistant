#!/bin/bash

# 快速启动脚本 - 可直接在服务器上执行

echo "=== XYAssistant 快速启动脚本 ==="
echo "此脚本将帮助您初始化服务器环境并启动应用"

# 步骤1: 更新系统并安装必要软件
echo "\n[1/5] 更新系统并安装必要软件..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git python3 python3-pip python3-venv

# 步骤2: 创建应用目录
echo "\n[2/5] 创建应用目录..."
sudo mkdir -p /home/ubuntu/XYAssistant
sudo chown ubuntu:ubuntu /home/ubuntu/XYAssistant
sudo chmod 755 /home/ubuntu/XYAssistant

# 步骤3: 克隆GitHub仓库
echo "\n[3/5] 克隆GitHub仓库..."
cd /home/ubuntu/XYAssistant
git clone https://github.com/cjluczy/XYAssistant.git .

# 步骤4: 创建并激活虚拟环境
echo "\n[4/5] 设置Python环境..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 步骤5: 启动服务
echo "\n[5/5] 启动服务..."
chmod +x server_check_and_fix.sh
./server_check_and_fix.sh

echo "\n=== 安装完成！ ==="
echo "请访问 http://103.217.187.88:5000 验证服务是否正常运行"
echo "如果遇到问题，请检查端口5000是否开放以及gunicorn服务状态"