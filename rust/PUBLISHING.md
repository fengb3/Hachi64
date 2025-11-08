# Publishing to Crates.io

本文档说明如何将 hachi64 发布到 Crates.io。

## 自动化发布（推荐）

本项目已配置 GitHub Actions 自动发布工作流。当 `Cargo.toml` 中的版本号更新并推送到 `main` 分支时，会自动触发发布流程。

### 配置 GitHub Secrets

在使用自动发布之前，需要配置 Crates.io API Token：

#### 1. 获取 Crates.io API Token

1. 访问 [Crates.io](https://crates.io/)
2. 使用 GitHub 账号登录
3. 点击右上角的账号名，选择 **Account Settings**
4. 在左侧菜单中选择 **API Tokens**
5. 点击 **New Token** 按钮
6. 输入 Token 名称（例如：`github-actions-hachi64`）
7. 点击 **Create** 按钮
8. **重要**：立即复制生成的 Token，它只会显示一次

#### 2. 配置 GitHub Repository Secret

1. 访问仓库页面：https://github.com/fengb3/Hachi64
2. 点击 **Settings** 标签
3. 在左侧菜单中选择 **Secrets and variables** → **Actions**
4. 点击 **New repository secret** 按钮
5. 设置 Secret：
   - **Name**: `CARGO_REGISTRY_TOKEN`
   - **Value**: 粘贴从 Crates.io 复制的 API Token
6. 点击 **Add secret** 按钮

### 发布新版本的步骤

1. **更新版本号**：编辑 `rust/Cargo.toml` 文件，修改 `version` 字段
   ```toml
   [package]
   version = "0.2.0"  # 从 0.1.0 更新到 0.2.0
   ```

2. **提交更改**：
   ```bash
   git add rust/Cargo.toml
   git commit -m "chore(rust): bump version to 0.2.0"
   ```

3. **推送到 main 分支**：
   ```bash
   git push origin main
   ```

4. **自动发布**：
   - GitHub Actions 会自动检测到 `Cargo.toml` 的变更
   - 运行测试确保代码质量
   - 验证包的完整性 (`cargo package --verify`)
   - 自动发布到 Crates.io
   - 创建 GitHub Release 并打上版本标签

5. **验证发布**：
   - 查看 GitHub Actions 工作流运行状态：https://github.com/fengb3/Hachi64/actions
   - 访问 Crates.io 确认包已发布：https://crates.io/crates/hachi64
   - 检查 GitHub Releases：https://github.com/fengb3/Hachi64/releases

### 注意事项

- **版本号规范**：遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范
- **仅在 main 分支生效**：自动发布仅在 `main` 分支触发
- **必须修改 Cargo.toml**：只有 `rust/Cargo.toml` 文件被修改时才会触发发布
- **测试必须通过**：如果测试失败，发布流程不会执行
- **不可撤销**：发布到 Crates.io 的版本不能删除，只能使用 `cargo yank` 撤回

## 手动发布（备用方案）

如果自动发布失败或需要手动控制发布流程，可以使用以下步骤。

### 前提条件

1. 拥有 Crates.io 账号
2. 已使用 `cargo login` 登录
3. 代码已准备就绪，所有测试通过

## 发布步骤

### 1. 验证包配置

```bash
cd rust
cargo package --list
```

确保没有警告信息，所有必要的文件都包含在内。

### 2. 本地测试打包

```bash
cargo package
```

这将创建一个 `.crate` 文件在 `target/package/` 目录中。

### 3. 测试打包后的版本

```bash
cargo package --verify
```

这会解压打包文件并运行测试，确保打包后的版本能正常工作。

### 4. 登录 Crates.io

```bash
cargo login
```

系统会提示输入 API Token（从 Crates.io 获取，参见上文"获取 Crates.io API Token"部分）。

### 5. 发布到 Crates.io

```bash
cargo publish
```

如果需要先进行试运行（不实际发布），可以使用：

```bash
cargo publish --dry-run
```

### 6. 验证发布

发布成功后，访问 https://crates.io/crates/hachi64 确认包已正确发布。

### 7. 手动创建 Git Tag

```bash
git tag rust-v0.1.0
git push origin rust-v0.1.0
```

## 版本管理

后续版本发布时，需要：

1. 更新 `Cargo.toml` 中的版本号
2. 更新 `CHANGELOG.md`（如果有）
3. 提交更改并推送到 main 分支（自动发布）或手动执行发布步骤

## 注意事项

- 版本号遵循语义化版本规范 (SemVer)
- 发布后的版本不能删除或修改
- 如果需要撤回版本，使用 `cargo yank`
- 发布前务必确保代码质量和文档完整性

## 问题排查

如果遇到发布问题：

1. 确保 Cargo.toml 中的所有必需字段都已填写
2. 检查是否有重名的包
3. 确认是否有未提交的更改
4. 查看 https://doc.rust-lang.org/cargo/reference/publishing.html 获取更多信息
