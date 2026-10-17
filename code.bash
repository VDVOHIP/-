# 只写了部分核心代码
#第一题
int n = 0;
if (!(std::cin >> n)) {
    return 1; 
}

int b; // 只需要一个变量来临时存数字
int count = 0; // 初始化计数器
int sum = 0;
int max = -1001;
int min = 1001;

for (int i = 0; i < n; i++) { // 注意这里用的是 n，不是 a
    std::cin >> b; // 读入当前数字
    count++;       // 个数+1
    sum += b;
    if (b > max) max = b;
    if (b < min) min = b;
}


std::cout << "COUNT=" << count << std::endl;
std::cout << "SUM=" << sum << std::endl;
std::cout << "MIN=" << min << std::endl;
std::cout << "MAX=" << max << std::endl;

#第二题
#include <iostream>
#include <string>

using namespace std;

struct Device {
    string type;      
    int count;        
    int totalHours;   
};

int main() {
    int n;
    if (!(cin >> n)) return 0;

    Device devices[4] = {
        {"printer", 0, 0},
        {"scanner", 0, 0},
        {"router", 0, 0},
        {"server", 0, 0}
    };

    for (int i = 0; i < n; ++i) {
        string type, status;
        int hours;
        cin >> type >> status >> hours;

        for (int j = 0; j < 4; ++j) {
            if (devices[j].type == type) {
                devices[j].count++;
                devices[j].totalHours += hours;
                break;
            }
        }
    }

    for (int i = 0; i < 4; ++i) {
        cout << devices[i].type << " " << devices[i].count << " " << devices[i].totalHours << "\n";
    }

    int maxHours = -1;
    string busiestType = "";
    for (int i = 0; i < 4; ++i) {
        if (devices[i].totalHours > maxHours) {
            maxHours = devices[i].totalHours;
            busiestType = devices[i].type;
        }
    }

    cout << "busiest " << busiestType << "\n";

    return 0;
}
# 第三题
void print_report(int count, long long total, int smallest, int largest) {
    std::cout << "count=" << count << '\n'
              << "sum=" << total << '\n'
              << "min=" << smallest << '\n'
              << "max=" << largest << '\n';
}
cmake_minimum_required(VERSION 3.16)
project(recruit_stats LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_executable(main main.cpp stats.cpp format.cpp)
#第四题
#include <iostream>

int main() {
    int count = 0;
    if (!(std::cin >> count)) return 1;
    if (count <= 0) {
        std::cout << "count=" << count << "\n";
        std::cout << "sum=0\n";
        std::cout << "increases=0\n";
        std::cout << "drops=0\n";
        return 0;
    }

    long long sum = 0;
    int previous = 0;
    if (!(std::cin >> previous)) return 1;
    sum += previous;

    int increases = 0;
    int drops = 0;
    for (int i = 1; i < count; i++) {
        int value = 0;
        if (!(std::cin >> value)) return 1;
        
        sum += value;
        if (value > previous) {
            increases++;
        } else if (value < previous) {
            drops++;
        }
        
        previous = value;
    }

    std::cout << "count=" << count << "\n";
    std::cout << "sum=" << sum << "\n";
    std::cout << "increases=" << increases << "\n";
    std::cout << "drops=" << drops << "\n";
    
    return 0;
}
#第五题
#include <iostream>
#include <string>
#include <map>

// 定义图书结构体
struct Book {
    long long onShelf = 0;  // 在架数量
    long long borrowed = 0; // 借出数量
};

int main() {
    int count = 0;
    if (!(std::cin >> count)) return 1;

    // std::map 会自动按 key（编号）的字典序进行排序
    std::map<std::string, Book> library;

    std::string operation;
    std::string code;
    
    // 处理所有操作
    for (int i = 0; i < count; i++) {
        if (!(std::cin >> operation >> code)) return 1;
        
        long long copies = 0;
        if (operation != "return") {
            if (!(std::cin >> copies)) return 1;
        }

        // 按题目要求更新台账
        if (operation == "add") {
            library[code].onShelf += copies;
            
        } else if (operation == "borrow") {
            // 只有在架数量不少于指定册数时才能执行
            if (library[code].onShelf < copies) {
                std::cout << "rejected\n";
                return 0; // 退出码 0 结束程序
            }
            library[code].onShelf -= copies;
            library[code].borrowed += copies;
            
        } else if (operation == "return") {
            // 只有该编号借出至少 1 册时才能执行
            if (library[code].borrowed < 1) {
                std::cout << "rejected\n";
                return 0; // 退出码 0 结束程序
            }
            library[code].borrowed -= 1;
            library[code].onShelf += 1;
        }
    }

    // 统计汇总数据
    long long totalOnShelf = 0;
    long long totalBorrowed = 0;
    int titles = 0;

    for (const auto& pair : library) {
        const Book& book = pair.second;
        // 两边都变成 0 的编号不输出，也不计入 titles
        if (book.onShelf > 0 || book.borrowed > 0) {
            titles++;
            totalOnShelf += book.onShelf;
            totalBorrowed += book.borrowed;
        }
    }

    // 输出汇总（替换模板中原有的输出）
    std::cout << "titles=" << titles << "\n";
    std::cout << "onShelf=" << totalOnShelf << "\n";
    std::cout << "borrowed=" << totalBorrowed << "\n";

    // 按编号字典序输出明细
    for (const auto& pair : library) {
        const std::string& bookCode = pair.first;
        const Book& book = pair.second;
        if (book.onShelf > 0 || book.borrowed > 0) {
            std::cout << bookCode << " " << book.onShelf << " " << book.borrowed << "\n";
        }
    }

    return 0;
}
#好像丢了一个题
#include <iostream>

int main() {
    const int CAPACITY = 8;
    int window[CAPACITY] = {}; 
    int kept = 0;
    int count = 0;

    if (!(std::cin >> count)) return 1;

    for (int i = 0; i < count; ++i) {
        int value = 0;
        if (!(std::cin >> value)) return 1;
        if (kept < CAPACITY) {
            ++kept;
        }
    }
    long long sum = 0;
    for (int i = 0; i < kept; ++i) {
        sum += window[(oldest_idx + i) % CAPACITY];
    }

    std::cout << "kept=" << kept << "\n";
    std::cout << "oldest=" << window[oldest_idx] << "\n";
    std::cout << "last=" << window[last_idx] << "\n";
    std::cout << "sum=" << sum << "\n";

    return 0;
}