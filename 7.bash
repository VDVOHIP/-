apt-get update
apt-get install -y build-essential
nano /workspace/setup-build.sh
#!/bin/bash
# setup-build.sh

# 1. 更新本地索引
apt-get update

# 2. 修复依赖关系（处理潜在的包冲突）
apt-get -f install -y

# 3. 安装构建必备工具（如果已安装会自动跳过）
apt-get install -y build-essential

echo "Environment setup complete."
chmod +x /workspace/setup-build.sh

nano /workspace/hello.c
#include <stdio.h>

int main(int argc, char **argv) {
    if (argc != 2) return 64;
    FILE *log = fopen("/workspace/run.log", "a");
    if (log == NULL) return 1;
    fprintf(log, "processed:%s\n", argv[1]);
    fclose(log);
    printf("hello:%s\n", argv[1])   // <--- 缺少分号
    return 0;
}
