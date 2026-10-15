#!/bin/bash

# 目标文件路径
TASK_FILE="/workspace/task.txt"

# 1. 创建组 (如果不存在)
if ! getent group archive > /dev/null; then
    groupadd archive
fi

# 2. 创建账号 (处理已存在的同名账号)
# 检查是否存在 archiver 用户
if getent passwd archiver > /dev/null; then
    # 获取现有属性
    EXIST_UID=$(id -u archiver)
    EXIST_GID=$(id -g archiver)
    EXIST_HOME=$(getent passwd archiver | cut -d: -f6)
    EXIST_SHELL=$(getent passwd archiver | cut -d: -f7)
    ARCHIVE_GID=$(getent group archive | cut -d: -f3)
    
    # 如果有任何属性不符合要求，则删除重建
    if [ "$EXIST_UID" -lt 200 ] || [ "$EXIST_UID" -gt 999 ] || \
       [ "$EXIST_GID" != "$ARCHIVE_GID" ] || \
       [ -n "$EXIST_HOME" ] || \
       [ "$EXIST_SHELL" != "/usr/sbin/nologin" ]; then
        userdel archiver
    fi
fi

# 如果不存在，则创建
if ! getent passwd archiver > /dev/null; then
    # 使用 -r 系统账号，指定UID为200（确保在200-999内），-M 不创建home，-s 指定nologin
    useradd -r -u 200 -g archive -M -s /usr/sbin/nologin archiver
fi

# 确保 visitor 账号存在（用于验证不能读取）
if ! getent passwd visitor > /dev/null; then
    useradd visitor
fi

# 3. 配置权限
if [ -f "$TASK_FILE" ]; then
    chown archiver:archive "$TASK_FILE"
    chmod 640 "$TASK_FILE"
fi

# 4. 验证权限（必须实际切换账号测试）
su -s /bin/bash archiver -c "cat $TASK_FILE" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "验证失败: archiver 无法读取文件"
    exit 1
fi
su -s /bin/bash visitor -c "cat $TASK_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "验证失败: visitor 竟然可以读取文件"
    exit 1
fi

echo "ARCHIVE-READY-6" > /workspace/flag