# Packagist 发布设置指南

## 配置方式：GitHub Actions + API Token

为了与其他语言的发布流程保持一致，PHP 包使用 GitHub Actions workflow 通过 Packagist API 触发更新。

## 问题修复

之前的 API 调用失败，错误：`{"status":"error","message":"Missing payload parameter"}`

**原因**：API 请求体格式不正确，需要包含 `repository.url` 字段。

**已修复**：更新了 API 调用格式，使用正确的 JSON payload。

## 设置步骤

### 步骤 1: 首次提交包到 Packagist

1. 访问 https://packagist.org/packages/submit
2. 输入 GitHub 仓库 URL：`https://github.com/fengb3/Hachi64`
3. 点击 "Check" 并提交

### 步骤 2: 获取 API Token

1. 登录 https://packagist.org/
2. 进入 **Profile** → **Show API Token**
3. 复制 API token

### 步骤 3: 配置 GitHub Secrets

1. 访问 https://github.com/fengb3/Hachi64/settings/secrets/actions
2. 添加两个 repository secrets：
   - **Name**: `PACKAGIST_USERNAME`  
     **Value**: 你的 Packagist 用户名
   - **Name**: `PACKAGIST_TOKEN`  
     **Value**: 你的 Packagist API token

### 步骤 4: 触发发布

更新 `php/composer.json` 中的 `version` 字段并提交到 main 分支：

```bash
cd php
# 编辑 composer.json，更新 version 字段
git add composer.json
git commit -m "chore: bump php package version to 0.1.2"
git push
```

GitHub Actions 会自动：
1. ✅ 检测版本变更
2. ✅ 运行测试
3. ✅ 验证 composer.json
4. ✅ 调用 Packagist API 触发更新
5. ✅ 创建 GitHub Release（tag: `php-v0.1.2`）

## Workflow 工作流程

`php-publish.yml` workflow 执行流程：

1. ✅ 检测 `composer.json` 版本变更
2. ✅ 运行测试（调用 `php-test.yml`）
3. ✅ 验证 composer.json（不使用 --strict，允许 version 字段）
4. ✅ 通过 Packagist API 触发包更新
5. ✅ 创建 GitHub Release 和 Git Tag（格式：`php-v{version}`）

## Monorepo 特殊配置

由于这是 monorepo，需要注意：

### composer.json 配置

```json
{
  "name": "hachi64/hachi64",
  "type": "library",
  "version": "0.1.1",  // 保留此字段用于 CICD 版本检测
  ...
}
```

**为什么保留 `version` 字段？**
- Composer 官方建议发布到 Packagist 时省略 `version`，由 Git 标签控制
- 但在 monorepo 中，我们需要 `version` 字段来：
  1. 触发每个语言独立的 CICD
  2. 区分不同语言包的版本
  3. 自动化版本检测逻辑
- 使用 `composer validate`（不加 `--strict`）来允许此字段

### Git 标签格式

- **格式**：`php-v{version}`（例如：`php-v0.1.1`）
- **原因**：避免与其他语言的标签冲突
- Packagist 会正确识别这些带前缀的标签

### Packagist 包位置

- 仓库 URL：`https://github.com/fengb3/Hachi64`
- Packagist 会自动检测子目录中的 `php/composer.json`
- 确保 composer.json 中的 `name` 字段正确：`hachi64/hachi64`

## 验证配置

### 检查 Secrets 是否配置

在 GitHub Actions 运行日志中查看：
- 如果 secrets 未配置，workflow 会失败并提示
- 如果 API 调用成功，会显示 "✅ Packagist updated successfully"

### 检查 Packagist 是否更新

1. 访问 https://packagist.org/packages/hachi64/hachi64
2. 查看 "Versions" 标签页
3. 应该看到最新的版本号和对应的 Git 标签

## 故障排除

### API 调用失败

**错误**: `{"status":"error","message":"Missing payload parameter"}`
- **原因**: 请求体格式不正确
- **解决**: 已在最新的 workflow 中修复

**错误**: `403 Forbidden`
- **原因**: Username 或 Token 不正确
- **解决**: 检查 GitHub Secrets 中的 `PACKAGIST_USERNAME` 和 `PACKAGIST_TOKEN`

**错误**: `404 Not Found`
- **原因**: 包还未在 Packagist 上提交
- **解决**: 先在 https://packagist.org/packages/submit 提交包

### Packagist 没有显示新版本

1. **检查 Git 标签**
   - 确认 GitHub Release 和 tag 已创建
   - Tag 格式应为 `php-v{version}`

2. **手动触发更新**
   - 访问 https://packagist.org/packages/hachi64/hachi64
   - 点击 "Update" 按钮强制同步

3. **检查包权限**
   - 确保 Packagist 账号有权限访问 GitHub 仓库
   - 可能需要重新授权 GitHub OAuth

## API 调用详解

### 正确的 API 格式

```bash
curl -X POST \
  "https://packagist.org/api/update-package?username=YOUR_USERNAME&apiToken=YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"repository":{"url":"https://github.com/fengb3/Hachi64"}}'
```

**关键点**：
- ✅ 使用 POST 方法
- ✅ 在 query string 中传递 `username` 和 `apiToken`
- ✅ 在请求体中包含 `repository.url` 字段（GitHub 仓库 URL）
- ✅ 设置 `Content-Type: application/json`

**返回示例**：
```json
{
  "status": "success"
}
```

## 与其他语言保持一致

PHP 包发布流程与其他语言（Python、Rust、Go、Dart、Ruby 等）保持一致：

1. ✅ 通过修改版本文件（`composer.json` 中的 `version`）触发
2. ✅ 运行自动化测试
3. ✅ 通过 API 推送到包管理器
4. ✅ 创建 GitHub Release 和标签

**不使用 GitHub Webhook 的原因**：
- 保持所有语言发布流程的一致性
- 完全通过 workflow 控制，便于调试和监控
- 与 monorepo 的版本管理策略一致

## 相关链接

- [Packagist API 文档](https://packagist.org/apidoc)
- [Packagist 文档](https://packagist.org/about)
- [Composer Schema](https://getcomposer.org/doc/04-schema.md)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
