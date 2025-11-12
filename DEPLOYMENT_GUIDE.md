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

## 常见问题排查

### 如果服务无法启动

1. 检查 Gunicorn 日志：
   ```bash
   journalctl -u gunicorn --no-pager
   ```

2. 检查依赖是否安装正确：
   ```bash
   cd /home/ubuntu/XYAssistant
   source venv/bin/activate
   pip list
   ```

3. 尝试手动启动服务进行测试：
   ```bash
   cd /home/ubuntu/XYAssistant
   source venv/bin/activate
   gunicorn --bind 0.0.0.0:5000 wsgi:app
   ```

### 数据库相关问题

应用使用 SQLite 数据库，默认存储在应用目录下。确保应用目录有写入权限：

```bash
chmod -R 755 /home/ubuntu/XYAssistant
```

## 更新应用

当需要更新应用时，只需在服务器上重新执行部署脚本：

```bash
cd /home/ubuntu/XYAssistant
./github_deploy.sh
```

脚本会自动从 GitHub 拉取最新代码并重启服务。