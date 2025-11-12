#!/bin/bash

# 服务器初始化脚本 - 解决XYAssistant部署问题

echo "开始服务器初始化..."

# 步骤1: 更新软件包列表并安装git
echo "更新软件包列表..."
sudo apt-get update
echo "安装git..."
sudo apt-get install -y git

# 验证git安装
echo "验证git安装..."
git --version

# 步骤2: 创建XYAssistant目录
echo "创建XYAssistant目录..."
mkdir -p /home/ubuntu/XYAssistant
chown ubuntu:ubuntu /home/ubuntu/XYAssistant
chmod 755 /home/ubuntu/XYAssistant

# 步骤3: 克隆GitHub仓库
echo "克隆GitHub仓库..."
cd /home/ubuntu/XYAssistant
git clone https://github.com/yourusername/XYAssistant.git .  # 请替换为实际的GitHub仓库URL

# 步骤4: 执行检查和修复脚本
echo "设置脚本权限并执行检查修复..."
chmod +x server_check_and_fix.sh
./server_check_and_fix.sh

echo "服务器初始化完成！"
echo "请通过浏览器访问 http://103.217.187.88:5000 验证服务是否正常运行。"