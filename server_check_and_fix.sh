#!/bin/bash

# 服务器检查和修复脚本
echo "===== XYAssistant 服务器检查和修复工具 ====="

# 检查并安装必要的工具
echo "\n检查必要工具..."
for tool in netstat ufw; do
  if ! command -v $tool &> /dev/null; then
    echo "安装 $tool..."
    sudo apt-get install -y $tool
  fi
done

# 检查端口5000状态
echo "\n检查端口5000状态..."
if sudo netstat -tuln | grep -q 5000; then
  echo "✓ 端口5000已被占用，正在运行服务"
  echo "当前占用端口5000的进程:"
  sudo netstat -tulnp | grep 5000
else
  echo "✗ 端口5000未被占用，服务未启动"
fi

# 检查防火墙状态
echo "\n检查防火墙状态..."
if sudo ufw status | grep -q "Status: active"; then
  echo "防火墙已激活，检查端口5000规则..."
  if sudo ufw status | grep -q "5000"; then
    echo "✓ 防火墙已允许端口5000"
  else
    echo "✗ 防火墙未允许端口5000，正在添加规则..."
    sudo ufw allow 5000/tcp
    echo "✓ 已添加防火墙规则，允许端口5000"
  fi
else
  echo "防火墙未激活，您可以选择激活并配置规则"
  echo "提示: 输入 'y' 激活防火墙并允许端口5000，其他键跳过"
  read -r -p "是否激活防火墙? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo ufw enable
    sudo ufw allow 5000/tcp
    echo "✓ 防火墙已激活并配置端口5000规则"
  fi
fi

# 检查项目目录
echo "\n检查项目目录..."
PROJECT_DIR="/home/ubuntu/XYAssistant"
if [ -d "$PROJECT_DIR" ]; then
  echo "✓ 项目目录已存在"
  cd "$PROJECT_DIR" || exit
  
  # 检查虚拟环境
  if [ -d "venv" ]; then
    echo "✓ 虚拟环境已存在"
    source venv/bin/activate
    
    # 检查依赖安装
    echo "\n检查Flask依赖..."
    if pip list | grep -q "Flask"; then
      echo "✓ Flask已安装"
    else
      echo "✗ Flask未安装，正在安装依赖..."
      pip install -r requirements.txt
      pip install gunicorn
    fi
  else
    echo "✗ 虚拟环境不存在，正在创建..."
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    pip install gunicorn
  fi
  
  # 检查并启动Gunicorn服务
  echo "\n检查Gunicorn服务..."
  if pgrep -f "gunicorn.*wsgi:app" > /dev/null; then
    echo "✓ Gunicorn服务正在运行"
  else
    echo "✗ Gunicorn服务未运行，正在启动..."
    # 创建必要的目录
    mkdir -p static/uploads
    
    # 启动Gunicorn服务
    echo "正在启动Gunicorn服务..."
    gunicorn --bind 0.0.0.0:5000 wsgi:app --daemon --workers 3 --timeout 300
    
    # 检查启动状态
    sleep 3
    if pgrep -f "gunicorn.*wsgi:app" > /dev/null; then
      echo "✓ Gunicorn服务已成功启动"
    else
      echo "✗ Gunicorn服务启动失败，请检查错误日志"
      echo "尝试直接运行查看错误:"
      echo "cd $PROJECT_DIR && source venv/bin/activate && gunicorn --bind 0.0.0.0:5000 wsgi:app"
    fi
  fi
else
  echo "✗ 项目目录不存在，请先执行部署脚本"
  echo "执行以下命令部署项目:"
  echo "mkdir -p $PROJECT_DIR && cd $PROJECT_DIR && git clone https://github.com/cjluczy/XYAssistant.git . && chmod +x github_deploy.sh && ./github_deploy.sh"
fi

echo "\n===== 检查完成 ====="
echo "请尝试访问 http://103.217.187.88:5000"
echo "如果仍有问题，请检查以上输出中的错误信息"