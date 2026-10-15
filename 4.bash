#注：主要是脚本
#!/bin/bash

# 1. 参数严格校验（非法或缺参时，输出 usage，退出64，不生成结果文件）
if [ $# -ne 2 ]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
fi

MODE="$1"
ITEM="$2"

if [ "$MODE" != "ok" ] && [ "$MODE" != "retry" ] && [ "$MODE" != "fatal" ]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
fi

# 校验 ITEM 是否为 1-32 位字母或数字
if ! [[ "$ITEM" =~ ^[a-zA-Z0-9]{1,32}$ ]]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
fi

# 2. 加载配置并显式导出变量（解答提示1）
ENV_FILE="/workspace/job.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: config file $ENV_FILE not found" >&2
    exit 1
fi

source "$ENV_FILE"
export TASK_TOOL_DIR ROUTE_RESULT ACCESS_TOKEN

# 3. 调整 PATH，满足按命令名调用（解答提示2）
export PATH="$TASK_TOOL_DIR:$PATH"

# 4. 调用工具（⚠️ 请务必根据 task-probe --help 的真实用法修改此行参数！）
# 假设工具不需要传 MODE，只接收 ITEM。根据实际帮助信息调整。
TOOL_OUTPUT=$(task-probe "$ITEM" 2>/dev/null)

# 【关键】立刻保存退出码（解答提示3）
TOOL_EXIT_CODE=$?

# 5. 清洗输出（防止有多行或回车符破坏“恰有一行”的规则）
CLEAN_OUTPUT=$(echo "$TOOL_OUTPUT" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# 6. 根据退出码分支处理（不要用 set -e，利用 case 处理非零正常业务状态）
case $TOOL_EXIT_CODE in
    0)
        echo "receipt:$CLEAN_OUTPUT" > "$ROUTE_RESULT"
        exit 0
        ;;
    11)
        echo "retry:$ITEM" > "$ROUTE_RESULT"
        exit 75
        ;;
    23)
        echo "rejected:$ITEM" > "$ROUTE_RESULT"
        exit 65
        ;;
    *)
        echo "Error: Unknown tool exit code: $TOOL_EXIT_CODE" >&2
        exit 1
        ;;
esac
chmod +x /workspace/route.sh