# npm 发布设置指南

## 问题

npm 发布失败，错误：`403 Forbidden - You may not perform that action with these credentials.`

## 原因

1. GitHub Actions 需要 NPM_TOKEN 才能发布到 npm
2. 包名 `hachi64` 可能已被占用

## 解决步骤

### 步骤 1: 检查包名是否可用

```bash
npm view hachi64
```

如果返回包信息，说明包名已被占用。需要更改包名。

### 步骤 2: 更改包名（如果需要）

如果 `hachi64` 已被占用，可以使用带作用域的包名。在 `package.json` 中修改：

```json
{
  "name": "@fengb3/hachi64",
  ...
}
```

或使用其他名称如：
- `hachi64-encoding`
- `hachi64-codec`
- `@hachi64/core`

### 步骤 3: 创建 npm 账号和访问令牌

1. 在 https://www.npmjs.com/ 注册账号
2. 登录后，进入 **Account Settings** → **Access Tokens**
3. 点击 **Generate New Token** → 选择 **Automation** 类型
4. 复制生成的令牌（格式：`npm_xxxxxxxxxxxx`）

### 步骤 4: 在 GitHub 中添加 Secret

1. 进入 GitHub 仓库设置：https://github.com/fengb3/Hachi64/settings/secrets/actions
2. 点击 **New repository secret**
3. Name: `NPM_TOKEN`
4. Value: 粘贴刚才复制的 npm 令牌
5. 点击 **Add secret**

### 步骤 5: 测试本地发布（可选）

在本地测试发布前先进行 dry-run：

```bash
cd js
npm login  # 使用你的 npm 账号登录
npm publish --dry-run  # 测试发布但不实际发布
```

如果一切正常，可以手动发布：

```bash
npm publish
```

### 步骤 6: 触发 GitHub Actions

在配置好 NPM_TOKEN 后，更新 package.json 的版本号：

```bash
cd js
# 修改 package.json 中的 version
git add package.json
git commit -m "chore: bump js package version to 0.1.2"
git push
```

## 临时方案：禁用自动发布

如果暂时不想发布到 npm，可以：

1. 移除或注释掉 `.github/workflows/js-npm-publish.yml` 中的 publish job
2. 或者在 workflow 文件开头添加条件：
   ```yaml
   on:
     workflow_dispatch:  # 仅手动触发
   ```

## 包名建议

由于 `hachi64` 可能已被占用，建议使用：

1. **带作用域的包名**（推荐）：
   - `@fengb3/hachi64`
   - 好处：不会与其他包冲突，明确所有者

2. **描述性名称**：
   - `hachi64-encoding`
   - `hachi64-base64`
   - `chinese-base64`

## 验证发布成功

发布成功后，可以通过以下方式验证：

```bash
npm view hachi64  # 或你的包名
npm install hachi64  # 测试安装
```

## 相关链接

- [npm 文档：创建和发布作用域包](https://docs.npmjs.com/creating-and-publishing-scoped-public-packages)
- [GitHub Actions 文档：加密 secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [npm 自动化令牌](https://docs.npmjs.com/creating-and-viewing-access-tokens)
