# Hachi64 Swift Implementation

Swift 实现的哈吉米64(Hachi64)编解码器，使用64个中文字符进行 Base64 风格的编码和解码。

## 功能特性

- ✅ 使用原生 Swift 实现
- ✅ 符合 Swift 代码规范
- ✅ 支持 Swift Package Manager
- ✅ 完整的单元测试覆盖
- ✅ 支持填充(padding)和无填充模式
- ✅ 详细的文档注释

## 安装

### Swift Package Manager

由于本项目是多语言 monorepo，Swift 包位于 `swift/` 子目录中。有以下几种引用方式：

#### 方式 1：使用带路径的 URL（推荐）

在你的 `Package.swift` 文件中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/fengb3/Hachi64.git", from: "0.1.1")
]
```

**注意**：引用时需要指定完整的模块路径。由于 SPM 会克隆整个仓库，它会自动找到 `swift/Package.swift`。

然后在目标中添加 "Hachi64" 依赖：

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Hachi64", package: "Hachi64")
    ]),
```

#### 方式 2：使用 Git 标签（更明确）

```swift
dependencies: [
    .package(url: "https://github.com/fengb3/Hachi64.git", .exact("swift-v0.1.1"))
]
```

使用项目的 Swift 专用标签（格式：`swift-v{version}`），这样可以明确引用 Swift 包的特定版本。

#### 方式 3：在 Xcode 中添加

1. 在 Xcode 中打开你的项目
2. 选择 **File** > **Add Package Dependencies...**
3. 在搜索框中输入：`https://github.com/fengb3/Hachi64.git`
4. 选择版本规则（推荐使用标签 `swift-v0.1.1` 或更高版本）
5. 点击 **Add Package**

## 使用方法

### 基本使用

```swift
import Hachi64

// 编码
let data = "Hello".data(using: .utf8)!
let encoded = Hachi64.encode(data)
print(encoded)  // 输出: 豆米啊拢嘎米多=

// 解码
do {
    let decoded = try Hachi64.decode(encoded)
    let decodedString = String(data: decoded, encoding: .utf8)!
    print(decodedString)  // 输出: Hello
} catch {
    print("解码失败: \(error)")
}
```

### 无填充模式

```swift
import Hachi64

let data = "Hello".data(using: .utf8)!

// 编码时不添加填充
let encoded = Hachi64.encode(data, padding: false)
print(encoded)  // 输出: 豆米啊拢嘎米多

// 解码时指定无填充
do {
    let decoded = try Hachi64.decode(encoded, padding: false)
    let decodedString = String(data: decoded, encoding: .utf8)!
    print(decodedString)  // 输出: Hello
} catch {
    print("解码失败: \(error)")
}
```

### 错误处理

```swift
import Hachi64

do {
    let decoded = try Hachi64.decode("包含无效字符X")
    print("解码成功")
} catch Hachi64Error.invalidCharacter(let char) {
    print("发现无效字符: \(char)")
} catch {
    print("其他错误: \(error)")
}
```

## API 文档

### `Hachi64`

主要的编解码器结构体。

#### 静态属性

- `hachiAlphabet: String` - 哈吉米64字符集（64个中文字符）

#### 静态方法

##### `encode(_:padding:)`

编码数据为哈吉米64字符串。

```swift
static func encode(_ data: Data, padding: Bool = true) -> String
```

**参数：**
- `data`: 要编码的数据
- `padding`: 是否使用 '=' 进行填充（默认为 true）

**返回值：** 编码后的字符串

##### `decode(_:padding:)`

解码哈吉米64字符串。

```swift
static func decode(_ encodedString: String, padding: Bool = true) throws -> Data
```

**参数：**
- `encodedString`: 要解码的字符串
- `padding`: 输入字符串是否使用 '=' 进行填充（默认为 true）

**返回值：** 解码后的数据

**抛出：** 当输入包含无效字符时抛出 `Hachi64Error.invalidCharacter`

### `Hachi64Error`

编解码错误类型。

#### 错误情况

- `invalidCharacter(Character)` - 输入包含不在哈吉米64字符集中的字符

## 测试

运行单元测试：

```bash
cd swift
swift test
```

测试覆盖内容：
- ✅ 文档中的编码示例
- ✅ 文档中的解码示例
- ✅ 边界情况测试
- ✅ 无效输入测试
- ✅ 往返编解码测试
- ✅ 二进制数据测试
- ✅ 填充行为测试
- ✅ 字母表覆盖率测试

## 编码示例

| 原始数据 | 编码结果 | 说明 |
|---------|---------|------|
| `"Hello"` | `豆米啊拢嘎米多=` | 英文单词编码 |
| `"abc"` | `西阿南呀` | 简单三字符 |
| `"Python"` | `抖咪酷丁息米都慢` | 编程语言名称 |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` | 经典问候语 |
| `"Base64"` | `律苦集叮希斗西丁` | 标准编码名称 |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` | 本项目名称 |

## 要求

- Swift 5.7 或更高版本
- macOS 12.0+ / iOS 15.0+ / tvOS 15.0+ / watchOS 8.0+ / Linux

## Monorepo 说明

本项目是一个多语言单仓库（monorepo），Swift 包位于 `swift/` 子目录中。

### SPM 兼容性

- ✅ **Swift Package Manager 会自动识别子目录中的 `Package.swift`**
- ✅ 引用时使用完整的仓库 URL，SPM 会自动找到正确的包定义
- ✅ 使用 `swift-v{version}` 格式的 Git 标签来明确 Swift 包版本
- ✅ 仓库中的其他语言实现不会影响 Swift 包的使用

### 工作原理

当你添加依赖时：
1. SPM 克隆整个 `Hachi64` 仓库
2. 自动扫描并找到 `swift/Package.swift`
3. 解析包定义并构建 Swift 模块
4. 其他语言的目录（`python/`, `rust/`, `js/` 等）会被忽略

### 版本管理

- Swift 包使用独立的版本标签：`swift-v0.1.0`, `swift-v0.1.1` 等
- 这样可以独立于其他语言版本进行发布
- 查看所有 Swift 版本：https://github.com/fengb3/Hachi64/releases?q=swift-v

## 发布流程

本项目使用 GitHub Actions 自动化发布流程。

### 配置说明

**无需配置额外的 Secrets**

Swift Package Manager 通过 Git 标签分发包，不需要发布到中央注册表。GitHub Actions 使用自动提供的 `GITHUB_TOKEN` 创建 Release，无需额外配置。

### 如何触发发布

1. **更新版本号**
   
   编辑 `swift/VERSION` 文件，修改版本号：
   ```bash
   # 例如从 0.1.0 更新到 0.1.1
   echo "0.1.1" > swift/VERSION
   ```

2. **提交并推送到 main 分支**
   ```bash
   git add swift/VERSION
   git commit -m "Bump Swift package version to 0.1.1"
   git push origin main
   ```

3. **自动发布**
   
   当 `swift/VERSION` 文件被修改并推送到 main 分支时，GitHub Actions 会自动：
   - 运行所有测试
   - 创建 GitHub Release
   - 创建 Git 标签（格式：`swift-v{version}`，例如 `swift-v0.1.1`）

### 版本号规范

使用[语义化版本](https://semver.org/lang/zh-CN/)：`MAJOR.MINOR.PATCH`

- **MAJOR**: 不兼容的 API 修改
- **MINOR**: 向下兼容的功能性新增
- **PATCH**: 向下兼容的问题修正

### 手动触发工作流

也可以在 GitHub 网页上手动触发工作流：

1. 进入仓库的 Actions 标签页
2. 选择 "Swift Package CI" 工作流
3. 点击 "Run workflow" 按钮
4. 选择分支并运行

## 许可证

与主项目保持一致。

## 相关链接

- [主项目 README](../README.md)
- [实现指南](../docs/implemtation_guide.md)
- [CI 工作流程模式](../docs/ci_workflow_pattern.md)
