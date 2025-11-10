# Go 模块发布到 pkg.go.dev

本文档说明如何将 Go 模块发布到 pkg.go.dev。

## 概述

与其他语言的包管理器不同，pkg.go.dev 不需要手动上传包。当你推送一个 Git tag 时，pkg.go.dev 会自动索引和显示你的 Go 模块。

## 发布流程

### 1. 自动化发布（推荐）

我们已经配置了 GitHub Actions 工作流来自动化发布流程。

#### 触发自动发布的步骤：

1. **更新版本号**
   
   编辑 `go/version.go` 文件，更新版本号：
   ```go
   package hachi64

   // Version is the current version of the hachi64 package
   const Version = "0.1.1"  // 更新这里的版本号
   ```

2. **提交并推送到 main 分支**
   
   ```bash
   git add go/version.go
   git commit -m "Bump Go version to 0.1.1"
   git push origin main
   ```

3. **工作流自动执行**
   
   推送到 main 分支后，GitHub Actions 工作流会自动：
   - 运行所有测试（必须通过）
   - 检测到 `version.go` 文件变更
   - 提取新版本号
   - 验证 Go 模块
   - 创建 Git tag（格式：`go/v0.1.1`）
   - 推送 tag 到 GitHub
   - 创建 GitHub Release
   - pkg.go.dev 会在几分钟内自动索引新版本

4. **验证发布**
   
   几分钟后，访问以下链接验证：
   - pkg.go.dev: `https://pkg.go.dev/github.com/fengb3/Hachi64/go@v0.1.1`
   - GitHub Release: `https://github.com/fengb3/Hachi64/releases/tag/go-v0.1.1`

### 2. 手动发布

如果需要手动发布（不推荐），可以按照以下步骤操作：

1. **更新版本号**（同上）

2. **创建并推送 Git tag**
   ```bash
   git tag -a go/v0.1.1 -m "Release Go module version 0.1.1"
   git push origin go/v0.1.1
   ```

3. **等待 pkg.go.dev 索引**
   
   pkg.go.dev 会自动检测新 tag 并索引模块，通常需要几分钟。

4. **手动触发首次索引（可选）**
   
   如果等待时间过长，可以访问以下 URL 手动触发索引：
   ```
   https://pkg.go.dev/github.com/fengb3/Hachi64/go@v0.1.1
   ```

## 配置说明

### 需要的 Secrets

**好消息：不需要配置任何 Secrets！**

与 PyPI、npm、crates.io 等包管理器不同，pkg.go.dev 的发布完全基于 Git：
- ✅ 不需要 API Token
- ✅ 不需要认证凭证
- ✅ 只需要 `GITHUB_TOKEN`（GitHub Actions 自动提供）

`GITHUB_TOKEN` 是 GitHub Actions 自动提供的，用于：
- 创建 GitHub Release
- 推送 Git tags
- 无需手动配置

### 工作流配置

工作流文件位于：`.github/workflows/go-publish.yml`

**触发条件：**
- 推送到 `main` 分支
- `go/**` 目录下有文件变更
- 可以手动触发（workflow_dispatch）

**执行步骤：**
1. 运行测试（使用可重用工作流 `go-test.yml`）
2. 检查 `version.go` 是否被修改
3. 如果版本变更：
   - 验证 Go 模块
   - 创建 Git tag
   - 推送 tag
   - 创建 GitHub Release

## 版本号规范

遵循[语义化版本规范](https://semver.org/)：

- **MAJOR**（主版本）：不兼容的 API 变更
- **MINOR**（次版本）：向后兼容的功能新增
- **PATCH**（修订版本）：向后兼容的问题修复

示例：
- `0.1.0` → `0.1.1`（修复 bug）
- `0.1.1` → `0.2.0`（新增功能）
- `0.2.0` → `1.0.0`（重大变更）

## Git Tag 命名规范

Go 模块使用特殊的 tag 格式来支持 monorepo：

```
go/v{version}
```

示例：
- `go/v0.1.0`
- `go/v0.1.1`
- `go/v1.0.0`

**为什么需要 `go/` 前缀？**

因为这是一个 monorepo（包含多种语言的实现），Go 模块不在仓库根目录。根据 Go 模块规范，子目录模块的 tag 需要包含路径前缀。

## 常见问题

### Q: 为什么 pkg.go.dev 上看不到我的新版本？

A: pkg.go.dev 的索引不是实时的，可能需要几分钟到几小时。如果等待时间过长：
1. 确认 Git tag 已正确推送：`git tag -l "go/*"`
2. 访问模块页面手动触发索引：`https://pkg.go.dev/github.com/fengb3/Hachi64/go@v{version}`
3. 检查 GitHub Actions 工作流是否成功执行

### Q: 发布失败了怎么办？

A: 检查 GitHub Actions 工作流日志：
1. 进入仓库的 Actions 标签页
2. 找到失败的工作流运行
3. 查看详细日志找出问题
4. 常见问题：
   - 测试失败：修复测试后重新推送
   - Tag 已存在：不能发布相同版本，需要更新版本号
   - 权限问题：确认工作流有 `contents: write` 权限

### Q: 如何撤销一个发布？

A: Go 模块发布后不能完全撤销，但可以：
1. 发布一个新的修复版本（推荐）
2. 在 GitHub 上删除 Release（但 tag 和 pkg.go.dev 索引仍存在）
3. 如果确实需要，可以联系 pkg.go.dev 团队请求移除特定版本

### Q: 可以发布预发布版本吗？

A: 可以。使用预发布版本号，例如：
- `v0.1.0-alpha.1`
- `v0.1.0-beta.1`
- `v0.1.0-rc.1`

在 `version.go` 中设置相应的版本号即可。

### Q: 如何更新 go.mod 中的依赖？

A: 用户可以使用以下命令：
```bash
# 获取最新版本
go get github.com/fengb3/Hachi64/go@latest

# 获取特定版本
go get github.com/fengb3/Hachi64/go@v0.1.1

# 获取特定 commit
go get github.com/fengb3/Hachi64/go@commit-hash
```

## 参考资源

- [Go Modules 官方文档](https://go.dev/ref/mod)
- [pkg.go.dev 关于页面](https://pkg.go.dev/about)
- [语义化版本规范](https://semver.org/)
- [项目 CI/CD 工作流程模式](../../docs/ci_workflow_pattern.md)

## 发布检查清单

发布新版本前，请确认：

- [ ] 所有测试通过：`go test -v ./...`
- [ ] 代码已格式化：`go fmt ./...`
- [ ] 无 lint 错误：`go vet ./...`
- [ ] 文档已更新（如有 API 变更）
- [ ] README.md 中的示例仍然有效
- [ ] 遵循语义化版本规范更新版本号
- [ ] 在 `version.go` 中更新了版本号

完成以上检查后，提交并推送到 main 分支，工作流会自动处理发布流程。
