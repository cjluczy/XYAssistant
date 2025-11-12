# XYAssistant 部署指南

本文档提供了在Ubuntu服务器上部署XYAssistant应用的详细步骤。

## 目录
- [快速开始](#快速开始)
- [手动部署步骤](#手动部署步骤)
- [常见问题排查](#常见问题排查)
- [应用更新](#应用更新)
- [一键问题排查与修复](#一键问题排查与修复)

## 快速开始

我们提供了一个快速启动脚本，可以一步完成所有初始化工作。在服务器上执行以下命令：

```bash
# 直接下载并执行快速启动脚本
curl -s https://raw.githubusercontent.com/cjluczy/XYAssistant/master/quick_start.sh | bash
```

或者，您也可以通过以下步骤手动执行：

```bash
# 安装git
sudo apt-get update
sudo apt-get install -y git

# 创建目录并克隆仓库
mkdir -p /home/ubuntu/XYAssistant
cd /home/ubuntu/XYAssistant
git clone https://github.com/cjluczy/XYAssistant.git .

# 执行快速启动脚本
chmod +x quick_start.sh
./quick_start.sh
```

## 手动部署步骤

### 服务器环境准备

确保您的服务器满足以下要求：
- Ubuntu 18.04 LTS 或更高版本
- Python 3.6 或更高版本
- git
- pip
- virtualenv

```bash
# 更新系统软件包
sudo apt-get update && sudo apt-get upgrade -y

# 安装必要的软件包
sudo apt-get install -y python3 python3-pip python3-venv git
```

### 创建应用目录

```bash
# 创建应用目录
sudo mkdir -p /home/ubuntu/XYAssistant
sudo chown ubuntu:ubuntu /home/ubuntu/XYAssistant
sudo chmod 755 /home/ubuntu/XYAssistant
```

### 获取代码

```bash
# 克隆GitHub仓库
cd /home/ubuntu/XYAssistant
git clone https://github.com/cjluczy/XYAssistant.git .
```

### 安装依赖

创建并激活虚拟环境，然后安装所需的依赖：

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate

# 升级pip
pip install --upgrade pip

# 安装依赖
pip install -r requirements.txt
```

### 配置生产环境

设置必要的环境变量和配置文件：

```bash
# 创建.env文件（如果需要）
echo "FLASK_APP=app.py
FLASK_ENV=production
SECRET_KEY=your_secret_key_here" > .env

# 设置环境变量
export FLASK_APP=app.py
export FLASK_ENV=production
```

### 启动服务

使用Gunicorn作为WSGI服务器来运行应用：

```bash
# 安装Gunicorn（如果尚未安装）
pip install gunicorn

# 启动Gunicorn服务
gunicorn --bind 0.0.0.0:5000 wsgi:app

# 或者使用nohup使其在后台运行
nohup gunicorn --bind 0.0.0.0:5000 wsgi:app > app.log 2>&1 &
```

## 验证服务

确保服务正常运行：

```bash
# 检查Gunicorn进程
ps aux | grep gunicorn

# 测试本地访问
curl http://localhost:5000

# 通过公网访问
# 在浏览器中访问 http://103.217.187.88:5000
```

## 常见问题排查

### 端口访问问题

如果无法通过端口5000访问应用，请检查以下事项：

```bash
# 检查端口是否被占用
netstat -tuln | grep 5000

# 检查防火墙设置
sudo ufw status
sudo ufw allow 5000/tcp  # 如果防火墙处于活动状态
```

### 服务启动问题

如果Gunicorn服务无法启动，请检查：

```bash
# 检查应用日志
cat app.log

# 检查Python依赖是否正确安装
pip list

# 尝试直接使用Flask运行（用于调试）
export FLASK_APP=app.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=5000
```

### 依赖问题

如果遇到依赖相关的错误：

```bash
# 确保虚拟环境已激活
source venv/bin/activate

# 重新安装依赖
pip install -r requirements.txt
```

### 权限问题

如果遇到权限错误：

```bash
# 确保用户对应用目录有正确的权限
sudo chown -R ubuntu:ubuntu /home/ubuntu/XYAssistant
sudo chmod -R 755 /home/ubuntu/XYAssistant
```

### 连接超时问题

如果遇到连接超时：

```bash
# 检查网络连接
ping 8.8.8.8

# 检查DNS设置
cat /etc/resolv.conf

# 检查应用是否正确绑定到0.0.0.0
ps aux | grep gunicorn
```

## 应用更新

要更新应用，只需拉取最新代码并重启服务：

```bash
# 导航到应用目录
cd /home/ubuntu/XYAssistant

# 拉取最新代码
git pull origin master

# 重启服务（先查找进程ID）
ps aux | grep gunicorn
kill -HUP [进程ID]

# 或者重新启动
nohup gunicorn --bind 0.0.0.0:5000 wsgi:app > app.log 2>&1 &
```

## 一键问题排查与修复

我们提供了一个自动化脚本来帮助您排查和修复常见问题：

```bash
# 确保脚本有执行权限
chmod +x server_check_and_fix.sh

# 运行脚本
./server_check_and_fix.sh
```

该脚本将：
1. 检查端口5000的状态
2. 配置防火墙规则（如果需要）
3. 检查项目目录和文件权限
4. 验证虚拟环境和依赖安装
5. 启动或重启Gunicorn服务

## 初始化命令列表

如果您需要手动执行所有初始化步骤，可以参考以下命令序列：

```bash
# 安装git
sudo apt-get update
sudo apt-get install -y git

# 创建并设置目录权限
sudo mkdir -p /home/ubuntu/XYAssistant
sudo chown ubuntu:ubuntu /home/ubuntu/XYAssistant
sudo chmod 755 /home/ubuntu/XYAssistant

# 克隆仓库
cd /home/ubuntu/XYAssistant
git clone https://github.com/cjluczy/XYAssistant.git .

# 执行检查修复脚本
chmod +x server_check_and_fix.sh
./server_check_and_fix.sh

# 验证服务
ps aux | grep gunicorn
curl http://localhost:5000
```