## 项目 TODO 列表

本项目旨在为多种编程语言提供健壮、经过测试且易于使用的库。

### 第一阶段：核心逻辑与参考实现

-   [x] **设计核心算法：** 确定核心的编码/解码逻辑，包括处理填充（`=`）和边界情况。
-   [x] **创建参考实现 (伪代码)：**
-   [x] **编写初始文档：** 扩展`README.md`

### 第二阶段：多语言原生实现

目标是参考项目根目录 `README.md` 中定义的伪代码，为每种主流编程语言提供独立、原生的实现。这确保了每个库都能最好地融入其生态系统，并且没有外部依赖。

-   [x] **Rust 实现:** [#1](https://github.com/fengb3/Hachi64/issues/1)
-   [ ] **Python 实现:** [#2](https://github.com/fengb3/Hachi64/issues/2)
-   [ ] **JavaScript/TypeScript 实现:** [#3](https://github.com/fengb3/Hachi64/issues/3)
-   [ ] **Go 实现:** [#4](https://github.com/fengb3/Hachi64/issues/4)
-   [ ] **Java 实现:** [#5](https://github.com/fengb3/Hachi64/issues/5)
-   [ ] **C# (.NET) 实现:** [#6](https://github.com/fengb3/Hachi64/issues/6)
-   [ ] **Swift 实现:** [#7](https://github.com/fengb3/Hachi64/issues/7)
-   [ ] **C++ 实现:** [#8](https://github.com/fengb3/Hachi64/issues/8)
-   [ ] **PHP 实现:** [#9](https://github.com/fengb3/Hachi64/issues/9)
-   [ ] **Ruby 实现:** [#10](https://github.com/fengb3/Hachi64/issues/10)
-   [ ] **Kotlin 实现:** [#11](https://github.com/fengb3/Hachi64/issues/11)
-   [ ] **Dart 实现:** [#12](https://github.com/fengb3/Hachi64/issues/12)

### 第三阶段：CI/CD 与社区

-   [ ] **设置 CI/CD 流水线 (GitHub Actions):**
    -   [ ] 在每次推送时为所有支持的语言自动化测试。
    -   [ ] 自动化每个包的构建和发布过程。
-   [ ] **创建项目网站/文档中心:**
    -   [ ] 使用静态站点生成器 (如 MkDocs, Docusaurus, 或 Sphinx) 来托管详细文档。
-   [ ] **添加贡献指南：** 创建 `CONTRIBUTING.md`。
-   [ ] **添加行为准则：** 创建 `CODE_OF_CONDUCT.md`。
-   [ ] **创建示例：** 提供一个包含每种语言清晰示例的文件夹。
