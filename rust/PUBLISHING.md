# Publishing to Crates.io

本文档说明如何将 hachi64 发布到 Crates.io。

## 前提条件

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

### 4. 发布到 Crates.io

**注意：此步骤需要人工操作**

```bash
cargo publish
```

如果需要先进行试运行（不实际发布），可以使用：

```bash
cargo publish --dry-run
```

### 5. 验证发布

发布成功后，访问 https://crates.io/crates/hachi64 确认包已正确发布。

## 更新版本

后续版本发布时，需要：

1. 更新 `Cargo.toml` 中的版本号
2. 更新 `CHANGELOG.md`（如果有）
3. 提交并打标签
4. 重复上述发布步骤

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
