cat > /workspace/manage.sh << 'EOF'
#!/bin/bash

WORKER_BIN="/opt/recruitment/bin/slow-worker"
WORK_DIR="${WORK_DIR:-/workspace}"
PID_FILE="$WORK_DIR/worker.pid"

# 极简且底层的进程检测，杜绝任何多余输出
is_running() {
    if [ ! -f "$PID_FILE" ]; then
        return 1
    fi
    
    local pid=$(cat "$PID_FILE" 2>/dev/null)
    
    # 如果 pid 为空或者非数字，清理文件并返回未运行
    if [ -z "$pid" ] || ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        rm -f "$PID_FILE"
        return 1
    fi
    
    # 使用 kill -0 探测进程是否存在（不发送任何信号）
    if kill -0 "$pid" 2>/dev/null; then
        return 0
    else
        # 进程不存在，清理过期的 pid 文件
        rm -f "$PID_FILE"
        return 1
    fi
}

start_worker() {
    if is_running; then
        exit 0
    fi
    mkdir -p "$WORK_DIR"
    # 重定向所有输出，确保脚本自身没有 stdout 输出
    nohup "$WORKER_BIN" > "$WORK_DIR/heartbeat.log" 2>&1 &
    echo $! > "$PID_FILE"
    exit 0
}

status_worker() {
    if is_running; then
        echo "running"
        exit 0
    else
        echo "stopped"
        exit 1
    fi
}

stop_worker() {
    if ! is_running; then
        rm -f "$PID_FILE"
        exit 0
    fi
    local pid=$(cat "$PID_FILE")
    kill -15 "$pid" 2>/dev/null
    
    # 等待进程完全退出
    local count=0
    while kill -0 "$pid" 2>/dev/null && [ $count -lt 50 ]; do
        sleep 0.1
        count=$((count + 1))
    done
    
    echo "Worker stopped at $(date)" > "$WORK_DIR/stopped.log"
    rm -f "$PID_FILE"
    exit 0
}

report_worker() {
    if ! is_running; then
        exit 1
    fi
    local pid=$(cat "$PID_FILE")
    local report_file="$WORK_DIR/resource.txt"
    {
        echo "PID=$pid"
        ps -ww -p "$pid" -o pid,ppid,user,stat,start,time,args
        top -b -n 1 -p "$pid"
    } > "$report_file"
    exit 0
}

case "$1" in
    start)   start_worker ;;
    status)  status_worker ;;
    stop)    stop_worker ;;
    report)  report_worker ;;
    *)
        echo "Usage: $0 {start|status|stop|report}"
        exit 64
        ;;
esac
EOF