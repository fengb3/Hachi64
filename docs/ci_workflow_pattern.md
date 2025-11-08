# CI/CD 工作流程模式

本文档总结了项目中使用的 CI/CD 工作流程模式，以 Python 为例，可以套用到其他语言的包发布流程。

## 工作流程概述

该工作流程设计用于自动化测试、构建和发布包到包管理器（如 PyPI、npm、Maven Central 等），并自动创建 GitHub Release。

## 触发条件

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'language/**'  # 只有特定语言目录下的文件变更时触发
  workflow_dispatch:      # 允许手动触发
```

**关键点：**
- 仅在推送到 `main` 分支时触发
- 使用 `paths` 过滤，仅当特定语言目录有变更时触发
- 支持手动触发以便测试和紧急发布

## 工作流程结构

工作流程分为两个主要 Job：

### 1. Test Job（测试作业）

```yaml
jobs:
  test:
    uses: ./.github/workflows/language-test.yml
```

**职责：**
- 运行所有单元测试
- 验证代码质量
- 确保包可以正确构建

**实现方式：**
- 使用可重用工作流（Reusable Workflow）
- 将测试逻辑独立到单独的 workflow 文件中
- 便于在 PR 和主分支上复用相同的测试逻辑

### 2. Publish Job（发布作业）

```yaml
publish:
  name: Build and publish distributions
  runs-on: ubuntu-latest
  needs: test  # 依赖测试通过
  permissions:
    contents: write  # 需要写权限以创建 Release
```

**职责：**
- 检查版本是否更新
- 构建包
- 发布到包管理器
- 创建 GitHub Release

## 核心步骤详解

### 步骤 1：检出代码

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0  # 获取完整历史，用于版本比较
```

**关键配置：**
- `fetch-depth: 0`：获取完整的 Git 历史记录，使得可以比较提交之间的差异

### 步骤 2：版本变更检查 ⭐

```yaml
- name: Check if version was updated
  id: version_check
  run: |
    # 检查版本文件是否在本次提交中被修改
    if git diff HEAD^ HEAD --name-only | grep -q "language/version-file"; then
      echo "Version file was modified"
      echo "version_changed=true" >> $GITHUB_OUTPUT
      
      # 从版本文件中提取版本号
      VERSION=$(extract-version-command)
      echo "version=$VERSION" >> $GITHUB_OUTPUT
      echo "Detected version: $VERSION"
    else
      echo "Version file was not modified"
      echo "version_changed=false" >> $GITHUB_OUTPUT
    fi
```

**核心逻辑：**
1. 使用 `git diff HEAD^ HEAD --name-only` 检查本次提交修改的文件
2. 检查版本文件（如 `setup.py`、`package.json`、`pom.xml` 等）是否被修改
3. 如果被修改，提取新版本号并保存到输出变量
4. 设置 `version_changed` 标志

**输出变量：**
- `version_changed`: `true` 或 `false`
- `version`: 提取的版本号（仅当版本变更时）

**各语言版本文件示例：**
- Python: `python/setup.py` → `version="x.x.x"`
- Node.js: `package.json` → `"version": "x.x.x"`
- Java: `pom.xml` → `<version>x.x.x</version>`
- Go: `version.go` 或使用 Git tags
- Rust: `Cargo.toml` → `version = "x.x.x"`
- Ruby: `gemspec` → `version = "x.x.x"`

### 步骤 3：环境设置（条件执行）

```yaml
- name: Set up Language Environment
  if: steps.version_check.outputs.version_changed == 'true'
  uses: setup-action
  with:
    version: 'stable'
```

**关键点：**
- 使用 `if` 条件，仅在版本变更时执行
- 引用前面步骤的输出：`steps.version_check.outputs.version_changed`

### 步骤 4：安装依赖（条件执行）

```yaml
- name: Install dependencies
  if: steps.version_check.outputs.version_changed == 'true'
  run: |
    # 安装构建和发布所需的工具
```

### 步骤 5：构建包（条件执行）

```yaml
- name: Build package
  if: steps.version_check.outputs.version_changed == 'true'
  working-directory: ./language
  run: build-command
```

**关键配置：**
- `working-directory`: 指定语言项目的目录
- 执行特定语言的构建命令

### 步骤 6：发布到包管理器（条件执行）

```yaml
- name: Publish package
  if: steps.version_check.outputs.version_changed == 'true'
  uses: publish-action
  with:
    token: ${{ secrets.REGISTRY_TOKEN }}
    package-dir: language/dist/
```

**安全注意事项：**
- 使用 GitHub Secrets 存储 API Token
- 不要在代码中硬编码凭证
- 为不同的包管理器创建专用的 Token

### 步骤 7：创建 GitHub Release ⭐

```yaml
- name: Create GitHub Release
  if: steps.version_check.outputs.version_changed == 'true'
  uses: softprops/action-gh-release@v1
  with:
    tag_name: language-v${{ steps.version_check.outputs.version }}
    name: Language v${{ steps.version_check.outputs.version }}
    body: |
      ## Language Package Release v${{ steps.version_check.outputs.version }}
      
      ### 📦 Installation
      ```bash
      install-command package==${{ steps.version_check.outputs.version }}
      ```
      
      ### 🔗 Links
      - [Package Registry](https://registry-url/package/${{ steps.version_check.outputs.version }}/)
      - [Documentation](https://github.com/${{ github.repository }}/tree/main/language)
      
      ### 📋 Changes
      This release includes updates to the Language package.
    files: |
      language/dist/*
    draft: false
    prerelease: false
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Release 内容：**
- **Tag 命名规范**: `language-v*.*.*`（例如 `python-v0.1.1`, `node-v1.2.3`）
- **Release 名称**: `Language v*.*.*`
- **Release 描述**: 包含安装说明、包管理器链接、文档链接
- **附加文件**: 构建产物（如 `.whl`, `.tar.gz`, `.jar`, `.gem` 等）

## 套用到其他语言

### Python 示例

```yaml
# 版本文件: python/setup.py
VERSION=$(grep -oP 'version="\K[^"]+' python/setup.py)

# 构建: python -m build
# 发布: pypa/gh-action-pypi-publish@release/v1
# Tag: python-v0.1.1
```

### Node.js/JavaScript 示例

```yaml
# 版本文件: js/package.json
VERSION=$(node -p "require('./js/package.json').version")

# 构建: npm run build
# 发布: npm publish
# Tag: js-v1.0.0
```

### Java 示例

```yaml
# 版本文件: java/pom.xml
VERSION=$(grep -oP '<version>\K[^<]+' java/pom.xml | head -1)

# 构建: mvn clean package
# 发布: mvn deploy
# Tag: java-v1.0.0
```

### Go 示例

```yaml
# 版本文件: go/version.go 或使用 Git tag
VERSION=$(grep -oP 'const Version = "\K[^"]+' go/version.go)

# 构建: go build
# 发布: 通常使用 Git tags，Go modules 直接引用
# Tag: go-v1.0.0
```

### Rust 示例

```yaml
# 版本文件: rust/Cargo.toml
VERSION=$(grep -oP '^version = "\K[^"]+' rust/Cargo.toml)

# 构建: cargo build --release
# 发布: cargo publish
# Tag: rust-v0.1.0
```

### Ruby 示例

```yaml
# 版本文件: ruby/hachi64.gemspec
VERSION=$(grep -oP "version\s*=\s*['\"](\K[^'\"]+)" ruby/hachi64.gemspec)

# 构建: gem build
# 发布: gem push
# Tag: ruby-v0.1.0
```

### C# 示例

```yaml
# 版本文件: csharp/Project.csproj
VERSION=$(grep -oP '<Version>\K[^<]+' csharp/Project.csproj)

# 构建: dotnet build
# 发布: dotnet nuget push
# Tag: csharp-v1.0.0
```

## 最佳实践

### 1. 版本管理
- ✅ 使用语义化版本（Semantic Versioning）：`MAJOR.MINOR.PATCH`
- ✅ 在版本文件中明确声明版本号
- ✅ 每次发布前必须更新版本号
- ✅ 版本号变更应该在独立的提交中完成

### 2. 安全性
- ✅ 使用 GitHub Secrets 存储所有敏感信息
- ✅ 为每个包管理器使用单独的 Token
- ✅ 定期轮换 API Token
- ✅ 使用 `permissions` 明确声明所需权限

### 3. 测试
- ✅ 发布前必须通过所有测试
- ✅ 使用 `needs: test` 确保测试先于发布执行
- ✅ 测试工作流独立可复用

### 4. 发布
- ✅ 仅在版本变更时执行发布
- ✅ 自动创建 GitHub Release 便于追踪
- ✅ 在 Release 中包含安装说明和链接
- ✅ 附加构建产物到 Release

### 5. 可维护性
- ✅ 使用可重用工作流（Reusable Workflows）
- ✅ 保持工作流程简洁清晰
- ✅ 添加注释说明关键步骤
- ✅ 统一命名规范（tag、job、step 名称）

## 权限配置

```yaml
permissions:
  contents: write  # 创建 Release 和 tags
  packages: write  # 发布包（如果使用 GitHub Packages）
```

## 必需的 Secrets

根据目标包管理器配置相应的 Secrets：

| 包管理器 | Secret 名称 | 用途 |
|---------|------------|------|
| PyPI | `PYPI_API_TOKEN` | Python 包发布 |
| npm | `NPM_TOKEN` | JavaScript/TypeScript 包发布 |
| Maven Central | `MAVEN_GPG_KEY`, `MAVEN_USERNAME`, `MAVEN_PASSWORD` | Java 包发布 |
| crates.io | `CARGO_REGISTRY_TOKEN` | Rust 包发布 |
| RubyGems | `RUBYGEMS_API_KEY` | Ruby gem 发布 |
| NuGet | `NUGET_API_KEY` | .NET 包发布 |

注：`GITHUB_TOKEN` 由 GitHub Actions 自动提供，无需手动配置。

## 故障排查

### 问题：版本检查失败
**解决方案：**
- 确保 `fetch-depth: 0` 已配置
- 检查版本文件路径是否正确
- 验证正则表达式是否匹配版本格式

### 问题：发布失败
**解决方案：**
- 检查 API Token 是否有效
- 确认版本号未在包管理器中已存在
- 查看包管理器的具体错误信息

### 问题：Release 创建失败
**解决方案：**
- 确认 `permissions: contents: write` 已配置
- 检查 tag 是否已存在
- 验证构建产物路径是否正确

## 总结

这个 CI/CD 模式的核心优势：

1. **智能发布**：仅在版本变更时才执行发布，避免不必要的操作
2. **安全可靠**：测试通过后才发布，减少错误发布的风险
3. **自动化完整**：从测试、构建、发布到创建 Release 全程自动化
4. **可追溯性**：通过 GitHub Release 和 tags 清晰追踪每个版本
5. **易于复用**：模式清晰，可快速套用到不同语言项目

通过遵循这个模式，可以确保所有语言的包发布流程保持一致性和可靠性。
