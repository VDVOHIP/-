#include <iostream>
#include <vector>
#include <thread>
#include <algorithm>
#include <mutex>

// 全局变量：当前工作线程总数（主线程算1个）
int thread_count = 1; 
const int MAX_THREADS = 4; // 题目要求最多4个

// 互斥锁，保护 thread_count，防止多个线程同时抢着修改
std::mutex mtx; 

// =============== 划分子函数 ===============
int partition(std::vector<int>& arr, int left, int right) {
    int pivot = arr[right]; // 取最后一个数作为基准值
    int i = left - 1;
    for (int j = left; j < right; ++j) {
        if (arr[j] <= pivot) { // 比基准值小的扔到左边
            i++;
            std::swap(arr[i], arr[j]);
        }
    }
    std::swap(arr[i + 1], arr[right]); // 把基准值放到最终位置
    return i + 1; // 返回基准值现在的坐标
}

// =============== 核心并行快排函数 ===============
void parallelQuickSort(std::vector<int>& arr, int left, int right, int depth) {
    if (left >= right) return;

    // 【1. 串行截止条件】
    // 数据量 <= 4，或者递归深度 >= 2，就不叫新线程了，直接串行排序
    if ((right - left + 1) <= 4 || depth >= 2) {
        std::sort(arr.begin() + left, arr.begin() + right + 1);
        return;
    }

    // 【2. 划分数据】
    int pivotIndex = partition(arr, left, right);

    // 【3. 决定是否叫朋友（创建新线程）】
    bool canCreate = false;
    {
        // 加锁，检查人数是否超标
        std::lock_guard<std::mutex> lock(mtx);
        if (thread_count < MAX_THREADS) {
            thread_count++; // 名额减1
            canCreate = true;
        }
    }

    if (canCreate) {
        // 叫来一个朋友（子线程）帮忙排左半边
        std::thread leftThread(parallelQuickSort, std::ref(arr), left, pivotIndex - 1, depth + 1);
        
        // 自己没闲着，去排右半边
        parallelQuickSort(arr, pivotIndex + 1, right, depth + 1);

        // 【4. 汇合】
        // 等朋友把左半边干完（join）
        leftThread.join();

        // 朋友干完了，把名额还回去
        std::lock_guard<std::mutex> lock(mtx);
        thread_count--;
    } else {
        // 人满了（已达4个），当前线程老老实实自己把左右两边都排完
        parallelQuickSort(arr, left, pivotIndex - 1, depth + 1);
        parallelQuickSort(arr, pivotIndex + 1, right, depth + 1);
    }
}

// =============== 主函数 ===============
int main() {
    // 题目给的16个数字
    std::vector<int> data = {42, 7, 19, 42, 3, 88, 15, 7, 61, 0, 54, 23, 91, 15, 36, 100};

    std::cout << "排序前: ";
    for (int n : data) std::cout << n << " ";
    std::cout << "\n";

    // 主线程亲自下场干活，深度设为0
    parallelQuickSort(data, 0, data.size() - 1, 0);

    std::cout << "排序后: ";
    for (int n : data) std::cout << n << " ";
    std::cout << "\n";
    // =============== 验证 ===============
    bool isSorted = true;

    for (int i = 1; i < data.size(); i++) {
    if (data[i] < data[i - 1]) {
        isSorted = false;
        break;
       }
    }

    if (isSorted) {
    std::cout << "排序成功：数组已经升序排列" << "\n";
    } else {
    std::cout << "排序失败：数组中存在逆序元素" << "\n";
    }
    return 0;
}