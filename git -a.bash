# 1. 进入目标目录
cd /workspace/repo

# 2. 如果之前已经执行过 init，为了确保是个干净的仓库，先删除原有的 git 记录（可选，保险起见）
rm -rf .git

# 3. 初始化仓库并指定默认分支为 main
git init -b main

# 4. 检查状态（确保 notes.txt 是未追踪状态，且没有任何提交和暂存）
git status
