# Hachi64 C++ 实现

哈吉米64 (Hachi64) 的 C++ 头文件库实现，使用64个中文字符进行 Base64 风格的编码和解码。

## 特性

- **头文件-only 库**：无需编译，只需包含头文件即可使用
- **C++11 标准**：兼容现代 C++ 编译器
- **Google Test 单元测试**：全面的测试覆盖
- **CMake 构建支持**：简单的集成和安装

## 快速开始

### 系统要求

- C++11 或更高版本的编译器
- CMake 3.14 或更高版本（如果需要构建测试）

### 使用方法

#### 作为头文件-only 库使用

只需将 `include/hachi64/` 目录添加到您的项目中，并包含头文件：

```cpp
#include "hachi64/hachi64.hpp"
#include <iostream>
#include <vector>

int main() {
    // 编码
    std::string text = "Hello";
    std::vector<uint8_t> data(text.begin(), text.end());
    std::string encoded = hachi64::encode(data);
    std::cout << "编码结果: " << encoded << std::endl;
    // 输出: 豆米啊拢嘎米多=

    // 解码
    std::vector<uint8_t> decoded = hachi64::decode(encoded);
    std::string result(decoded.begin(), decoded.end());
    std::cout << "解码结果: " << result << std::endl;
    // 输出: Hello

    return 0;
}
```

#### 使用 CMake 集成

1. 克隆或复制项目到您的工作目录
2. 在您的 CMakeLists.txt 中添加：

```cmake
add_subdirectory(path/to/hachi64/cpp)
target_link_libraries(your_target PRIVATE hachi64)
```

或者使用 FetchContent:

```cmake
include(FetchContent)
FetchContent_Declare(
    hachi64
    GIT_REPOSITORY https://github.com/fengb3/Hachi64.git
    GIT_TAG main
    SOURCE_SUBDIR cpp
)
FetchContent_MakeAvailable(hachi64)

target_link_libraries(your_target PRIVATE hachi64)
```

## 构建和测试

### 构建测试

```bash
cd cpp
mkdir build && cd build
cmake ..
cmake --build .
```

### 运行测试

```bash
ctest --output-on-failure
# 或直接运行测试可执行文件
./hachi64_test
```

## API 文档

### 编码函数

```cpp
std::string encode(const std::vector<uint8_t>& data, bool padding = true);
```

将字节数据编码为哈吉米64字符串。

- **参数**：
  - `data`: 要编码的字节数据
  - `padding`: 是否使用 '=' 进行填充（默认为 true）
- **返回值**：编码后的字符串

### 解码函数

```cpp
std::vector<uint8_t> decode(const std::string& encoded_str, bool padding = true);
```

将哈吉米64字符串解码为字节数据。

- **参数**：
  - `encoded_str`: 要解码的字符串
  - `padding`: 输入字符串是否使用 '=' 填充（默认为 true）
- **返回值**：解码后的字节数据
- **异常**：当输入包含无效字符时抛出 `hachi64::HachiError`

### 字符集常量

```cpp
constexpr const char* HACHI_ALPHABET;
```

哈吉米64使用的64个中文字符集。

## 编码示例

| 原始数据 | 编码结果 |
|---------|---------|
| `"Hello"` | `豆米啊拢嘎米多=` |
| `"abc"` | `西阿南呀` |
| `"Python"` | `抖咪酷丁息米都慢` |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `"Base64"` | `律苦集叮希斗西丁` |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` |

## 实现细节

- **UTF-8 支持**：正确处理多字节 UTF-8 字符
- **单例模式**：字符集和反向映射表使用单例模式，避免重复初始化
- **异常安全**：解码时检测无效输入并抛出异常
- **性能优化**：预分配内存，减少动态分配

## 许可证

与主项目保持一致。

## 相关链接

- [项目主页](https://github.com/fengb3/Hachi64)
- [实现指南](../docs/implemtation_guide.md)
