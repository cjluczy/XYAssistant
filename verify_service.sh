#!/bin/bash

# 服务验证脚本
echo "=== XYAssistant 服务验证脚本 ==="
echo ""

# 1. 检查进程状态
echo "[1/5] 检查Gunicorn进程..."
pids=$(ps aux | grep gunicorn | grep -v grep | awk '{print $2}')
if [ -n "$pids" ]; then
    echo "✓ Gunicorn 进程正在运行"
    echo "  进程ID: $pids"
else
    echo "✗ 未找到Gunicorn进程"
fi

# 2. 检查端口状态
echo "\n[2/5] 检查端口5000..."
if netstat -tuln | grep -q ":5000 "; then
    echo "✓ 端口5000正在监听"
    netstat -tuln | grep ":5000 "
else
    echo "✗ 端口5000未在监听"
fi

# 3. 检查防火墙状态
echo "\n[3/5] 检查防火墙设置..."
if command -v ufw &> /dev/null; then
    if sudo ufw status | grep -q "Status: active"; then
        echo "✓ 防火墙已激活"
        if sudo ufw status | grep -q "5000/tcp"; then
            echo "✓ 端口5000已开放"
        else
            echo "✗ 端口5000未开放"
            echo "  建议执行: sudo ufw allow 5000/tcp"
        fi
    else
        echo "✓ 防火墙未激活"
    fi
else
    echo "⚠️  无法检查ufw状态，可能未安装"
fi

# 4. 本地访问测试
echo "\n[4/5] 测试本地访问..."
if command -v curl &> /dev/null; then
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000)
    if [ "$response" == "200" ]; then
        echo "✓ 本地访问成功 (HTTP 200)"
    else
        echo "✗ 本地访问失败 (HTTP $response)"
    fi
else
    echo "⚠️ curl 未安装，无法测试本地访问"
    echo "  建议执行: sudo apt-get install -y curl"
fi

# 5. 总结
echo "\n[5/5] 验证完成！"
echo ""
echo "访问地址: http://103.217.187.88:5000"
echo ""
echo "如果遇到问题，请执行: ./server_check_and_fix.sh"
echo "或者参考DEPLOYMENT_GUIDE.md中的故障排除部分"