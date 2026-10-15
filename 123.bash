#第一关
cd /workspace
find /workspace -type f
# 或者使用 ls -R /workspace
/workspace/exam --help
cat /workspace/cabinet/key.txt
/workspace/exam -e "MOON"
cp /workspace/output /workspace/flag
ls -lh /workspace/flag

#第二关
cd /workspace
find /workspace -type f
grep -r "ACCESS_KEY=" /workspace/
cp /workspace/archive/2026/signal-A.bin /workspace/input
/workspace/exam -e "STAR"
cp /workspace/output /workspace/flag
cp /workspace/inbox/signal-B.bin /workspace/input
/workspace/exam -e "STAR"
cat /workspace/output >> /workspace/flag

#第三关
cat /var/log/ncuscc/exam.log
find /workspace -type f
cat /workspace/key.txt
cp /workspace/input.txt /workspace/input
/workspace/exam -e "NOVA"
sed '$ s/$/ /' /workspace/input.txt > /workspace/input
/workspace/exam -e "NOVA"
# 把处理结果复制为要求的 flag 文件（千万不能打开编辑）
cp /workspace/output /workspace/flag

# 检查文件大小和属性
ls -lh /workspace/flag
