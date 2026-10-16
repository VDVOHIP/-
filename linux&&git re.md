- 前三关主要是一些基础操作
目录切换：cd  作用：切换当前工作目录。
文件查找：find  作用：按照指定条件查找文件或目录。
    find 查找路径 查找条件
ls -R /workspace 
ls -R 会递归列出目录内容，但它主要用于展示目录结构；
find 则更适合按照文件名、类型等条件进行筛选。
查看程序帮助：--help  作用：查看命令或程序支持的参数和使用方法。
查看文件内容：cat 作用：读取并输出文件内容。
cat 的另一个重要用途：合并内容
eg：cat file1.txt file2.txt 会依次输出两个文件的内容。
文本搜索：grep 作用：在文本中搜索符合条件的内容。
    grep "搜索内容" 文件路径 
    eg：grep -r "ACCESS_KEY=" /workspace/
与 find 的区别：
    find：查找文件。
    grep：查找文件中的文本内容。
复制文件：cp 作用：复制文件或目录。
    cp 源文件 目标文件
    eg：cp /workspace/output /workspace/flag
    含义是将 output 的内容复制到 flag。
    将文件复制到指定位置
    eg：cp /workspace/archive/2026/signal-A.bin /workspace/input
    这条命令将 signal-A.bin 复制到 /workspace/input
    复制另一个输入文件
    eg：cp /workspace/inbox/signal-B.bin /workspace/input
    这条命令用于将另一个文件复制到指定输入位置
文件重定向：> 和 >>
    >：输出重定向
    作用：将命令的输出写入文件，通常会覆盖目标文件原有内容。
    eg：echo "hello" > test.txt
    执行后，test.txt 的内容就是：hello（如果原文件中存在其他内容，这些内容通常会被覆盖）
    >>：追加重定向
    作用：将命令的输出追加到文件末尾，而不是覆盖原有内容
    eg：cat /workspace/output >> /workspace/flag
    它的执行过程可以理解为：
        1. cat 读取 /workspace/output。
        2. 将文件内容输出。
        3. >> 把这些内容追加到 /workspace/flag 的末尾
    两者的核心区别：
    >|输出重定向 | 通常覆盖原有内容 |
    >>| 追加重定向 | 保留原有内容，在末尾追加 |
文本处理：sed
    sed 是 Linux 中常用的流编辑工具，可以按照指定规则处理文本
    eg：sed '$ s/$/ /' /workspace/input.txt > /workspace/input
    用法：sed '处理规则' 文件路径
    sed` | 文本处理工具 |
    第一个 `$` | 在这个位置表示最后一行 |
    s/.../.../| 替换操作 |
    s/$/ / | 在行尾匹配位置插入一个空格 |
    /workspace/input.txt| 原始输入文件 |
    >| 将处理结果重定向到另一个文件 |
    /workspace/input| 处理结果的输出位置 |
    整条命令的目的，是在原始文本的最后一行末尾添加一个空格，再将处理后的内容写入 /workspace/input。
文件属性查看：ls -lh
    作用：查看文件或目录的信息。
    -l	使用详细列表格式展示信息
    -h	以更容易阅读的方式显示文件大小
    /workspace/flag	要检查的文件
程序执行：/workspace/exam -e
    eg：/workspace/exam -e "MOON"
    /workspace/exam -e "STAR"
    /workspace/exam -e "NOVA"
    这些命令都在运行 /workspace/exam 程序，并通过 -e 参数向程序传入不同的字符串。
    运行 exam 程序
           ↓
    传入 -e 参数
           ↓
    程序接收指定字符串
           ↓
    程序根据自身逻辑执行操作
- 第四关（感觉第四关完全不像是给人做的。。。难度陡增）
一、报告对象与总体功能
本文讲解文件 /Users/ahs/Desktop/4.bash 中的 Bash 脚本。脚本的目标是：接收两个命令行参数，检查参数格式，加载配置，调用 task-probe 工具，再根据工具的退出码写入不同的结果，并以相应状态码结束
整体流程如下：
检查参数数量和格式
        ↓
加载配置文件并导出变量
        ↓
调整 PATH
        ↓
调用 task-probe，保存输出和退出码
        ↓
清洗输出
        ↓
按退出码写结果文件并退出
if [ $# -ne 2 ]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
fi
检查参数；
    $# 表示传入的参数个数。
    -ne 表示“不等于”。
    $0 表示脚本自身的名称。
    >&2 表示把提示信息写到标准错误，而不是标准输出。
    exit 64 表示结束脚本，并返回状态码 64。
因此，脚本要求调用时必须提供两个参数：
    ./4.bash <MODE> <ITEM>  
保存并校验参数：
    MODE="$1"
    ITEM="$2"
接着检查 MODE：
    if [ "$MODE" != "ok" ] && [ "$MODE" != "retry" ] && [ "$MODE" != "fatal" ]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
    fi
    && 表示“并且”。这段条件表示：当 MODE 同时不等于 ok、retry 和 fatal 时，参数无效。
然后检查 ITEM：
    if ! [[ "$ITEM" =~ ^[a-zA-Z0-9]{1,32}$ ]]; then
    echo "usage: $0 <MODE> <ITEM>" >&2
    exit 64
    fi
这里使用了 Bash 的正则匹配：
    [[ ... ]] 是 Bash 的条件表达式。
    =~ 用于判断字符串是否匹配正则表达式。
    ^ 表示字符串开头，$ 表示结尾。
    [a-zA-Z0-9] 表示英文字母或数字。
    {1,32} 表示长度在 1 到 32 个字符之间。
    ! 表示取反。
因此，ITEM 不能包含空格、标点或非 ASCII 英文字母和数字。
需要留意：脚本检查了 MODE 的合法值，但后续逻辑没有使用 MODE。实际调用工具时只传入了 ITEM。如果 MODE 本来应该影响工具行为或结果分支，这部分逻辑还没有实现。
加载配置文件并导出变量：
    ENV_FILE="/workspace/job.env"
    if [ ! -f "$ENV_FILE" ]; then
    echo "Error: config file $ENV_FILE not found" >&2
    exit 1
    fi

    source "$ENV_FILE"
    export TASK_TOOL_DIR ROUTE_RESULT ACCESS_TOKEN
    /workspace/job.env 是配置文件路径。
    -f 检查路径是否为普通文件，! -f 表示文件不存在或不是普通文件。
    source 在当前 shell 环境中读取并执行配置文件内容。它也可以写成点号形式：. "$ENV_FILE"。
    export 会把列出的变量导出到环境中，让后续启动的子进程也能读取它们。
这段代码假设配置文件会定义 TASK_TOOL_DIR、ROUTE_RESULT 和 ACCESS_TOKEN 等变量。
实际使用时应确认：配置文件存在，并且其中的变量名称、路径和权限都正确。source 会执行文件中的 shell 代码，因此配置文件应来自可信来源。
调整 PATH：
    export PATH="$TASK_TOOL_DIR:$PATH"
PATH 是系统查找可执行命令的目录列表。把 $TASK_TOOL_DIR 放在原有 PATH 前面后，shell 就可以按命令名查找该目录中的程序。
调用工具并捕获输出：
    TOOL_OUTPUT=$(task-probe "$ITEM" 2>/dev/null)
    $(...) 是命令替换，会运行括号里的命令，并把标准输出保存到变量。
    "$ITEM" 把参数作为单个整体传入工具。
    2>/dev/null 把工具的标准错误丢弃。
脚本随后立即保存退出码：
    TOOL_EXIT_CODE=$?
    $? 表示最近一条命令的退出码。必须紧跟在 task-probe 后保存，因为运行其他命令后，$? 会变成其他命令的状态。
关键限制：注释明确指出，工具参数应该根据 task-probe --help 的真实用法调整。目前的调用是 task-probe "$ITEM"，只是脚本采用的一种假设。若工具实际要求不同的参数，这行就需要修改。
清洗工具输出：
    CLEAN_OUTPUT=$(echo "$TOOL_OUTPUT" | tr -d '\r\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    这段管道依次处理工具输出：
    1. echo "$TOOL_OUTPUT" 输出变量内容。
    2. tr -d '\r\n' 删除回车和换行符。
    3. sed 删除开头和结尾的空白字符。
清洗后的结果放入 CLEAN_OUTPUT，后续用于生成单行结果。
这里的“删除换行”意味着多行输出会被直接拼接到一起。如果工具可能返回多行内容，拼接后的文本是否仍有意义，需要根据实际格式要求判断。
根据工具退出码分支：
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
case 根据变量的值选择对应分支，适合处理多个明确状态：
工具退出码	写入结果文件的内容	      脚本退出码	  含义
0	       receipt:<清洗后的输出>	0	    工具成功
11	       retry:<ITEM>	          75	  请求重试
23	       rejected:<ITEM>	      65	  请求被拒绝
其他	不写结果文件，向标准错误输出错误信息	1	未知错误
每个分支末尾的 ;; 表示该分支结束。> 是输出重定向，会创建结果文件；如果文件已经存在，会覆盖其原有内容。
这也意味着：未知退出码分支不会更新结果文件。若文件此前已存在，旧文件可能继续留在那里；调用者需要确认这是否符合预期
设置脚本执行权限：
    chmod +x /workspace/route.sh
    chmod +x 为指定文件增加可执行权限。设置后可以直接运行该文件，例如：
        /workspace/route.sh ok item123
    这行命令作用于 /workspace/route.sh，不一定是当前展示的 /Users/ahs/Desktop/4.bash。如果脚本实际保存为 4.bash，需要对实际文件路径执行 chmod +x，或确认部署时确实会把它放到 /workspace/route.sh。
- 第五关
这份是一段生成管理脚本的命令：它使用 Shell 的 Here Document，把 EOF 之间的文本写入 /workspace/manage.sh。生成的脚本用于启动、查看状态、停止和报告一个后台 worker 进程
Here Document：把多行内容写入文件：
    cat > /workspace/manage.sh << 'EOF'
    ...
    EOF
    << 'EOF' 表示从后续文本读取内容，直到遇到单独一行的 EOF，再把内容交给 cat。> 将内容写入 /workspace/manage.sh，如果文件已存在就会覆盖。
    EOF 被单引号括住，因此其中的 $变量、命令替换等内容不会在生成文件时展开，而会原样写进文件，留待脚本运行时处理
工作目录和 PID 文件：
    WORKER_BIN="/opt/recruitment/bin/slow-worker"
    WORK_DIR="${WORK_DIR:-/workspace}"
    PID_FILE="$WORK_DIR/worker.pid"
WORKER_BIN 指定 worker 程序的位置。
${WORK_DIR:-/workspace} 表示：如果环境变量 WORK_DIR 已设置且非空，就使用它；否则使用 /workspace。
PID_FILE 用来保存 worker 的进程 ID（PID），之后状态查询和停止操作会用它找到目标进程。
函数与退出状态：
    脚本把不同操作封装成函数，例如 start_worker 和 stop_worker。在 Bash 中，函数可以把重复或独立的操作分块组织起来。
    函数通过 return 返回状态码；此脚本中的操作函数则常用 exit 直接结束整个脚本。这意味着调用操作函数后不会继续运行后面的代码。
检查进程：is_running：
    is_running() {
    ...
    }
这个函数通过 PID 文件判断 worker 是否运行：
    1. PID 文件不存在：返回 1，表示未运行。
    2. PID 文件为空或不是数字：删除文件并返回 1。
    3. PID 合法时，执行 kill -0 "$pid" 检查对应进程是否存在。
    4. 进程存在则返回 0；不存在则清除过期 PID 文件并返回 1。
kill -0 不发送实际信号，只进行存在性和权限检查。shell 条件中的退出状态常用来表示真假：0 通常表示成功或“真”，非零表示失败或“假”。
启动后台进程：start_worker：
    nohup "$WORKER_BIN" > "$WORK_DIR/heartbeat.log" 2>&1 &
    echo $! > "$PID_FILE"
nohup 让程序在终端退出后继续运行。
    > ... 把标准输出写入日志文件。
    2>&1 把标准错误也重定向到标准输出的位置，因此标准输出和错误输出都进入同一个日志。
    & 让命令在后台运行。
    $! 是最近一个后台命令的 PID，这里将它写入 PID 文件。
启动前，函数会检查进程是否已运行；若已运行就直接以状态码 0 结束，避免重复启动。目录则通过 mkdir -p 创建，已存在时不会报错。
查看状态：status_worker：
    运行状态会输出 running，并以 0 退出；停止状态会输出 stopped，并以 1 退出。
    因此，调用者既能查看文本，也能通过退出码判断状态。例如自动化脚本可以根据退出码决定后续步骤
停止进程：stop_worker：
    kill -15 "$pid"
    信号 15 通常对应 SIGTERM，请求进程正常退出。之后脚本用循环反复执行 kill -0，每次等待 0.1 秒，最多检查 50 次，约等待 5 秒。
    然后它写入停止日志并删除 PID 文件。这里有一个需要注意的地方：循环达到上限后，脚本没有再次确认进程已经退出，就会继续写日志和删除 PID 文件。因此，若进程在约 5 秒内没有停止，PID 文件可能被删掉，但进程仍在运行。
生成资源报告：report_worker：
    如果 worker 没有运行，函数以 1 退出。若在运行，则把报告写到 resource.txt，包含：
        PID=...：进程 ID。
        ps：进程号、父进程号、用户、状态、启动时间、运行时间和命令行等信息。
        top：一次进程资源状态快照。
        > 会覆盖已有的报告文件。
按命令参数分发操作：
    case "$1" in
        start) ...
        status) ...
        stop) ...
        report) ...
        *) ...
    esac
case 根据第一个参数 $1 选择操作。支持的命令是 start、status、stop 和 report。其他输入会显示用法说明，并以 64 退出。
- 第六关（感觉又活过来了喵）
这份 Bash 脚本的目标是：建立一个专用用户和用户组，为 /workspace/task.txt 设置访问权限，并实际切换用户验证权限是否生效。全部检查通过后，在 /workspace/flag 写入标记
检查并创建用户组:
    if ! getent group archive > /dev/null; then
        groupadd archive
    fi
    getent group archive 查询系统账户数据库中是否存在 archive 组。
    > /dev/null 丢弃查询结果，只用命令的退出状态判断是否存在。
    ! 对条件取反：组不存在时执行 groupadd 创建它。
检查并校正用户属性:
    脚本用 getent passwd archiver 检查 archiver 用户是否存在。如果存在，则读取它的 UID、主组 GID、主目录和登录 shell：
        id -u archiver
        id -g archiver
        getent passwd archiver | cut -d: -f6
        getent passwd archiver | cut -d: -f7
        cut -d: -f6 表示以冒号为字段分隔符，读取第六个字段；在 passwd 记录中，第六、七个字段分别是主目录和登录 shell。
    脚本规定的属性条件是：
        - UID 在 200 到 999 之间；
        - 主组是 archive；
        - 主目录为空；
        - shell 为 /usr/sbin/nologin。
    若任一条件不符合，就执行 userdel archiver 删除用户，然后在用户不存在时重新创建：
    useradd -r -u 200 -g archive -M -s /usr/sbin/nologin archiver
    各选项含义：
        -r：创建系统账号；
        -u 200：指定 UID 为 200；
        -g archive：指定主组；
        -M：不创建主目录；
        -s /usr/sbin/nologin：禁止通过常规登录 shell 登录。
容易忽略的地方：-M 是“不创建主目录”，不等于 passwd 中的主目录字段必然为空。具体记录内容取决于系统工具和配置，因此脚本需要确认自己的主目录判断条件与目标系统行为一致。
确保测试用户存在:
    if ! getent passwd visitor > /dev/null; then
    useradd visitor
    fi
如果系统没有 visitor 用户，就创建它。该账号用于后续验证：普通用户是否能读取目标文件
设置文件所有者和权限:
    chown archiver:archive "$TASK_FILE"
    chmod 640 "$TASK_FILE"
    chown archiver:archive 将文件所有者设为 archiver，所属组设为 archive
    chmod 640 设置权限：
        所有者 6：读、写；
        所属组 4：只读；
        其他用户 0：无权限。
因此，目标设计是让 archiver 可以读取文件，而不属于 archive 组的 visitor 无法读取。
这段操作只有在 /workspace/task.txt 存在时才执行；文件不存在时，脚本会跳过权限设置，随后仍会进入验证阶段。
切换账号进行实际验证:
    su -s /bin/bash archiver -c "cat $TASK_FILE" > /dev/null 2>&1
    su 用于切换到指定账号。这里：
        -s /bin/bash 指定运行命令时使用的 shell；
        -c 指定要执行的命令；
        > /dev/null 2>&1 丢弃标准输出和标准错误。
随后脚本检查 $?：
    if [ $? -ne 0 ]; then
        echo "验证失败: archiver 无法读取文件"
        exit 1
    fi
如果上一个 su 命令失败，退出码不是 0，脚本就报告验证失败并退出
接着对 visitor 做相反测试：如果 visitor 的 cat 命令成功，脚本就认为权限配置失败。这里 $? -eq 0 表示上一个命令成功
写入成功标记:
    echo "ARCHIVE-READY-6" > /workspace/flag
只有两项权限验证都通过，脚本才会写入 /workspace/flag。> 会覆盖目标文件已有内容。
- 第七关
这个文件记录了一套在 Linux 环境中准备 C 语言编译环境、编写构建脚本，并创建一个简单 C 程序的步骤。内容主要包括包管理、脚本权限、C 程序参数处理、文件写入和编译错误识别
安装构建工具：
    apt-get update
    apt-get install -y build-essential
    - apt-get update 刷新本地软件包索引，让系统获取最新的包信息。
    - apt-get install -y build-essential 安装常用的编译工具集合；-y 表示自动确认安装提示。
后面的构建脚本也会重复这些步骤，并增加依赖修复：
    apt-get -f install -y
    -f 表示尝试修复依赖关系。它可用于处理部分依赖问题，但是否能解决包冲突取决于具体环境。
写入并赋予构建脚本执行权限：
    文件通过 nano /workspace/setup-build.sh 编辑构建脚本。脚本内容中：
        #!/bin/bash
指定由 Bash 解释。安装命令执行后会输出：
    echo "Environment setup complete."
之后使用：
    chmod +x /workspace/setup-build.sh
    增加脚本的可执行权限，使它可以直接运行。
C 程序的参数检查：
    int main(int argc, char **argv) {
        if (argc != 2) return 64;
    - argc 是命令行参数的数量，包含程序自身名称。
    - argv 是参数字符串数组。
    - argc != 2 表示除了程序名之外，必须恰好再提供一个参数。
    - 不满足条件时，程序返回 64。这个返回值可被调用它的 shell 脚本用作错误状态判断。
追加写入日志文件：
    FILE *log = fopen("/workspace/run.log", "a");
    if (log == NULL) return 1;
    fprintf(log, "processed:%s\n", argv[1]);
    fclose(log);
    - fopen(..., "a") 以追加模式打开日志文件，保留原有内容，并把新内容写到末尾；文件不存在时通常会创建文件。
    - 如果打开失败，fopen 返回 NULL，程序以 1 退出。
    - fprintf 将格式化内容写入文件。%s 会被 argv[1] 的字符串替换，\n 表示换行。
    - fclose 关闭文件，确保文件使用完毕后释放资源，并完成缓冲数据的写入。
输出到终端与编译错误：
    printf("hello:%s\n", argv[1])   // <--- 缺少分号
    return 0;
这里的 printf 语句末尾缺少分号，C 编译器会报语法错误。修正为：
    printf("hello:%s\n", argv[1]);
这是文件中明确的一处代码错误。需要先修正，才能成功编译 C 程序。
- 第八关（开始git）
cd /workspace/repo：
    cd：Change Directory（切换目录）。
    /workspace/repo：目标文件夹的绝对路径。
    作用：告诉终端“我要进入 /workspace/repo 这个文件夹工作”。之后的 Git 命令都会在这个目录下生效。
rm -rf .git：
    rm：Remove（删除）。
    -r：Recursive（递归），表示删除目录及其里面的所有内容。
    -f：Force（强制），表示无需系统提示确认，直接删除。
    .git：Git 仓库的隐藏核心文件夹，里面存放着所有的版本记录、配置和暂存区信息。
    作用：强制删除当前目录下已有的 .git 文件夹。
git init -b main：
    git init：Initialize（初始化）。在当前目录下创建一个全新的 Git 仓库（会重新生成一个干净的 .git 文件夹）。
    -b main：-b 是 --initial-branch 的缩写，指定初始分支的名称为 main
    git init -b main
    作用：在 /workspace/repo 目录下成功建立了一个全新的本地仓库，并且让 HEAD 指针默认指向 main 分支
git status：
    git status：查看当前仓库的状态。
    作用：用来验收成果，检查当前工作区是什么样子的。
- 第九关
git add notes.txt：
    作用：将工作区的修改添加到暂存区
git commit -m "learn: first local commit"：
    作用：将暂存区的内容正式提交到本地仓库，生成一个新的版本节点（快照）。-m 后面跟的是本次提交的说明
- 第十关
git log --oneline：
    作用：以精简的一行格式查看提交历史，方便找到目标的 commit ID（如 c0）
git show c0:notes.txt：
    作用：直接查看历史提交 c0 中 notes.txt 的具体内容，验证是否为 version one。
git diff -- notes.txt：
    作用：对比工作区和暂存区的差异。红色 -version two 和绿色 +temporary note，说明工作区有未暂存的临时修改。
git diff --cached：
    作用：对比暂存区和最新提交（HEAD）的差异。无输出说明暂存区和 c1 是一致的。
git restore . + GIT_EDITOR=true git revert HEAD（或 git revert HEAD --no-edit）：
    git restore .：清空工作区的临时修改，让环境回到绝对干净的 c1 状态，为后续操作铺路
    git revert HEAD：核心操作。它会创建一个全新的提交（c2），而这个新提交的内容正好是撤销 c1 恢复回 c0 的 version one
    GIT_EDITOR=true：环境变量，强制 Git 使用默认信息直接提交，防止掉入 nano 文本编辑器导致卡死
- 第十一关
cd /workspace/repo
ls -a
cat notes.txt：
    cd /workspace/repo：进入名为 repo 的项目文件夹。
    ls -a：看看文件夹里现在有什么（包括隐藏文件），确认 .git 仓库已初始化。
    cat notes.txt：打开 notes.txt 看看里面的内容（确认初始状态，一般作为校验基准）。
    目的：确认目前在一个干净的初始状态，方便后续观察 Git 的变化
创建分支并准备主干提交：
    git branch topic
    printf 'main ready\n' > main.txt
    git add -- main.txt
    git commit -m "learn: prepare main"
git branch topic：
    创建一个叫 topic 的分支。注意：此时还在 main 分支上，topic 只是一张写着名字的便签
printf 'main ready\n' > main.txt：
    在电脑上新建了一个文件（Shell命令）。在 main 分支下，生成了 main.txt，内容是“main ready”
git add -- main.txt：
    把文件放进“待发货区”（暂存区）。告诉 Git：“等下提交要带上这个文件”
git commit -m "..."：
    正式提交。把刚才的文件打包成一个历史节点，写在 main 分支的记事本上。此时 main 分支往前走了一步
切换分支并准备分支提交：
    git switch topic
    printf 'topic ready\n' > topic.txt
    git add -- topic.txt
    git commit -m "learn: prepare topic"
git switch topic：
    切换到 topic 分支。你的工作区瞬间变成了 topic 分支的状态（此时里面没有 main.txt，因为那是 main 分支刚写的）。
printf 'topic ready\n' > topic.txt：
    新建 topic.txt 文件
git add -- topic.txt：加入暂存区
git commit -m "..."：
    在 topic 分支上提交。此时 topic 分支也往前走了一步
此时状态：main 和 topic 就像两条腿，从同一个原点（c0）分岔了，各自有了自己的成果
切回主干并合并：
    git switch main
    git merge --no-edit topic
git switch main：切回主干道。准备迎接 topic 的成果。
git merge --no-edit topic：
    合并命令。把 topic 分支里的所有改动，合并到当前的 main 分支里。由于两个分支都有新提交，Git 会自动创建一个“双亲合并提交”（像是一个“Y”字形的交汇点）。--no-edit 表示自动使用默认的合并日志，不弹窗让你输入。
结果：main 分支同时拥有了 main.txt 和 topic.txt
Git 层面检查：
git log --graph --oneline --all：
    查看历史提交记录图。你会看到一个“Y”字形结构：一个原点分岔出两条线（main 和 topic），最后又合并成一个节点（双亲合并）。--oneline 让记录更简短，--all 表示显示所有分支的历史
git status --short --branch：   
    检查当前状态。如果输出很干净（没有 modified 文件），说明工作区干净，合并后没有遗留未提交的冲突
文件层面检查：
    cat main.txt topic.txt
直接查看这两个文件的内容。检查是否分别是 main ready 和 topic ready
- 第十二关
git switch -c trial：
    解释：git switch 用于切换分支。-c 是 --create 的缩写。这行命令的意思是创建一个名为 trial 的新分支，并立即切换到这个新分支上
printf 'local git practice\n\nfirst local note\n' > notes.txt：
    解释：printf 是一个格式化输出命令。\n 表示换行符。> 是重定向符号，表示将前面的字符串覆盖写入到 notes.txt 文件中。此时，notes.txt 里的内容变成了两行文本。
git add -- notes.txt：
    解释：将 notes.txt 的修改添加到 Git 的暂存区（Staging Area）。中间的 -- 是一个可选的保护性写法，用于明确告诉 Git 后面的 notes.txt 是文件路径，防止把它误认为是分支名或命令参数。
git commit -m "learn: first local commit"：
    解释：将暂存区的修改提交到本地仓库。-m 表示附带提交信息（Message）。此时 trial 分支产生了一个新的提交节点。
git merge --ff-only trial：
    解释：将 trial 分支合并到当前的 main 分支。--ff-only 全称是 fast-forward only（仅快进合并）。它强制要求必须能进行快进合并（即 main 分支在切换后没有产生新提交），这样合并后不会产生额外的合并提交
git revert --no-edit HEAD：
    revert：撤销指定的提交。它不是抹除历史，而是创建一个新的提交，这个新提交的内容正好抵消掉目标提交的修改。
    HEAD：代表当前最新的提交（也就是刚刚从 trial 快进合并过来的那次提交）。
    --no-edit：在执行 revert 时，Git 默认会弹出一个文本编辑器让你确认提交信息。加上这个参数后，直接使用默认的提交信息（通常是 "Revert '...'"），不弹编辑器。
结果：notes.txt 的内容被还原了，但 main 分支的历史上多了一条“反向提交”记录
git log --graph --oneline --all：查看提交历史。
    --graph：以图形化的方式（ASCII 字符画）展示分支的衍合与合并情况。
    --oneline：将每个提交压缩成一行显示（只显示短哈希值和提交信息）。
    --all：显示所有分支的历史，而不仅仅是当前分支
git status --short --branch：检查当前仓库的状态。
    --short：以简洁的格式输出。
    --branch：在输出中显示当前所在的分支信息