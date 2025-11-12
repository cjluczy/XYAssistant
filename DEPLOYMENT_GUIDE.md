# XYAssistant 部署指南

本指南详细说明了如何在 Ubuntu 服务器上部署 XYAssistant 应用。

## 部署步骤

### 1. 通过 SSH 登录服务器

在本地机器上打开终端（Windows 用户使用 PowerShell 或 PuTTY），执行以下命令：

```bash
ssh ubuntu@103.217.187.88
```

当提示输入密码时，输入：`2460619562Chen.`

### 2. 安装必要的依赖

登录成功后，首先确保服务器上安装了必要的软件：

```bash
# 更新系统包
 sudo apt update
 sudo apt upgrade -y

# 安装 Git 和 Python
 sudo apt install git python3 python3-venv python3-pip -y
```

### 3. 拉取部署脚本并执行

```bash
# 创建项目目录
 mkdir -p /home/ubuntu/XYAssistant
 cd /home/ubuntu/XYAssistant

# 拉取代码
 git clone https://github.com/cjluczy/XYAssistant.git .

# 赋予脚本执行权限
 chmod +x github_deploy.sh

# 执行部署脚本
 ./github_deploy.sh
```

### 4. 验证服务是否正常运行

部署脚本执行完成后，可以通过以下命令检查服务状态：

```bash
# 检查 Gunicorn 进程是否正在运行
 ps aux | grep gunicorn

# 检查端口 5000 是否正在监听
 netstat -tuln | grep 5000
```

### 5. 访问应用

打开浏览器，访问以下地址：
```
http://103.217.187.88:5000
```

## 一键问题排查与修复

我们提供了一个自动化的检查和修复脚本，可以帮助您诊断并解决大多数部署问题：

```bash
# 登录服务器后执行
cd /home/ubuntu/XYAssistant
chmod +x server_check_and_fix.sh
./server_check_and_fix.sh
```

该脚本会自动：
- 检查端口5000是否正常开放
- 配置防火墙规则（如果需要）
- 检查并修复虚拟环境和依赖
- 检查并重启Gunicorn服务
- 创建必要的目录结构

## 常见问题排查

### 1. 端口访问问题

如果无法访问网站，首先检查端口是否开放：

```bash
# 检查端口5000是否被监听
sudo netstat -tuln | grep 5000

# 如果没有输出，说明服务未启动或端口被占用
# 检查防火墙设置
sudo ufw status

# 如果防火墙已启用，确保端口5000已开放
sudo ufw allow 5000/tcp
```

### 2. 服务无法启动

```bash
# 检查Gunicorn进程
ps aux | grep gunicorn

# 尝试手动启动（在虚拟环境中）
cd /home/ubuntu/XYAssistant
source venv/bin/activate
# 前台运行以便查看错误信息
gunicorn --bind 0.0.0.0:5000 wsgi:app
```

### 3. 依赖问题

```bash
cd /home/ubuntu/XYAssistant
source venv/bin/activate
# 重新安装依赖
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn
```

### 4. 权限问题

应用使用 SQLite 数据库，确保应用目录有写入权限：

```bash
chmod -R 755 /home/ubuntu/XYAssistant
mkdir -p /home/ubuntu/XYAssistant/static/uploads
chmod -R 775 /home/ubuntu/XYAssistant/static/uploads
```

### 5. 连接超时问题

如果应用响应缓慢或超时，可能需要调整Gunicorn配置：

```bash
# 使用更多的worker进程
gunicorn --bind 0.0.0.0:5000 wsgi:app --daemon --workers 4 --timeout 300
```

## 更新应用

当需要更新应用时，只需在服务器上重新执行部署脚本：

```bash
cd /home/ubuntu/XYAssistant
./github_deploy.sh
```

脚本会自动从 GitHub 拉取最新代码并重启服务。