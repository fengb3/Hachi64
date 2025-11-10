# Hachi64 C# (.NET) 实现

哈吉米64编解码器的 C# (.NET) 实现，使用64个中文字符进行 Base64 风格的编码和解码。

## 特性

- 使用固定的哈吉米64字符集（64个中文字符）
- 支持带填充和不带填充两种模式
- 提供静态方法调用方式
- 完全符合 Base64 编码标准
- 类型安全，性能优异
- 支持 .NET 8.0+

## 安装

### 从 NuGet 安装

```bash
dotnet add package Hachi64 --version 0.1.0
```

或在项目的 `.csproj` 文件中添加：

```xml
<PackageReference Include="Hachi64" Version="0.1.0" />
```

### 从源码构建

```bash
cd csharp/Hachi64
dotnet build
```

### 运行测试

```bash
cd csharp/Hachi64.Tests
dotnet test
```

## 快速开始

### 基本用法

```csharp
using System;
using System.Text;
using Hachi64;

class Program
{
    static void Main()
    {
        // 编码示例
        byte[] data = Encoding.UTF8.GetBytes("Hello");
        string encoded = Hachi64.Encode(data);
        Console.WriteLine($"编码结果: {encoded}");  // 豆米啊拢嘎米多=
        
        // 解码示例
        byte[] decoded = Hachi64.Decode(encoded);
        string result = Encoding.UTF8.GetString(decoded);
        Console.WriteLine($"解码结果: {result}");  // Hello
    }
}
```

### 不使用填充

```csharp
using System.Text;
using Hachi64;

byte[] data = Encoding.UTF8.GetBytes("Hello");
string encoded = Hachi64.Encode(data, padding: false);
Console.WriteLine(encoded);  // 豆米啊拢嘎米多

byte[] decoded = Hachi64.Decode(encoded, padding: false);
```

## 编码示例

根据主 README 文档中的示例：

| 原始数据 | 编码结果 | 
|---------|---------|
| `"Hello"` | `豆米啊拢嘎米多=` |
| `"abc"` | `西阿南呀` |
| `"Python"` | `抖咪酷丁息米都慢` |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `"Base64"` | `律苦集叮希斗西丁` |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` |

## API 文档

### 类

#### `Hachi64`

哈吉米64编码器/解码器。

**常量:**

- `HachiAlphabet` - 哈吉米64字符集字符串（64个中文字符）

**静态方法:**

- `Encode(byte[] data, bool padding = true)` - 编码字节数组
  - `data`: 要编码的字节数组
  - `padding`: 是否使用 '=' 进行填充（默认为 `true`）
  - 返回: 编码后的字符串
  - 抛出: `ArgumentNullException` 如果 data 为 null

- `Decode(string encodedStr, bool padding = true)` - 解码字符串
  - `encodedStr`: 要解码的字符串
  - `padding`: 输入字符串是否使用 '=' 进行填充（默认为 `true`）
  - 返回: 解码后的字节数组
  - 抛出: `ArgumentNullException` 如果 encodedStr 为 null
  - 抛出: `ArgumentException` 如果输入字符串包含无效字符

## 单元测试

本项目使用 xUnit 进行单元测试，包含以下测试用例：

- 编码解码一致性测试
- 特定编码结果验证
- 二进制数据处理
- 带填充/不带填充模式
- 无效输入处理
- 边界条件测试
- 各种长度数据测试
- UTF-8 文本往返测试

所有测试都通过，确保实现的正确性和可靠性。

## 项目结构

```
csharp/
├── Hachi64/                  # 主库项目
│   ├── Hachi64.cs           # 核心实现
│   └── Hachi64.csproj       # 项目文件
├── Hachi64.Tests/           # 测试项目
│   ├── Hachi64Tests.cs      # 单元测试
│   └── Hachi64.Tests.csproj # 测试项目文件
├── .gitignore               # Git 忽略文件
└── README.md                # 本文件
```

## 依赖项

- .NET 8.0 SDK 或更高版本
- xUnit (测试框架)

## 发布到 NuGet

如需发布到 NuGet，请执行以下步骤：

1. 更新项目文件 (Hachi64.csproj) 中的包信息：
   ```xml
   <PropertyGroup>
     <PackageId>Hachi64</PackageId>
     <Version>1.0.0</Version>
     <Authors>Your Name</Authors>
     <Description>哈吉米64编解码器 - 使用64个中文字符的 Base64 风格编码</Description>
     <PackageTags>encoding;base64;chinese;hachi64</PackageTags>
   </PropertyGroup>
   ```

2. 打包项目：
   ```bash
   cd Hachi64
   dotnet pack -c Release
   ```

3. 发布到 NuGet：
   ```bash
   dotnet nuget push bin/Release/Hachi64.*.nupkg --api-key YOUR_API_KEY --source https://api.nuget.org/v3/index.json
   ```

**注意**: 发布到 NuGet 需要手动操作和有效的 API 密钥。

## 许可证

MIT
