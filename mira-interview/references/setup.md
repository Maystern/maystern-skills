# 初始化配置

仅当项目根目录下不存在有效的 `.mira-interview/config.env` 时执行初始化。目前仅保证支持通过 Homebrew 管理依赖的 macOS。

## macOS 初始化

模型名称、文件名和下载地址配置在 `config/model-config.env` 中。

从项目根目录运行：

```bash
bash .agents/skills/mira-interview/scripts/macos/configure.sh \
  --project-root "$PWD" \
  --install-tools \
  --download-models
```

脚本使用 Homebrew 安装缺少的 `ffmpeg` 和 `whisper-cpp`，将模型下载到 `interview-artifacts/models/`，并写入 `.mira-interview/config.env`。安装软件或下载模型前，先告知用户具体操作及模型配置中声明的预计体积。

用户已有模型时可直接传入路径。脚本默认在项目的 `interview-artifacts/models/` 中创建软链接，配置文件只引用该项目内路径：

```bash
bash .agents/skills/mira-interview/scripts/macos/configure.sh \
  --project-root "$PWD" \
  --whisper-model "/absolute/path/to/whisper-model.bin" \
  --vad-model "/absolute/path/to/vad-model.bin"
```

软链接依赖原模型持续存在；原模型被移动或删除后，需要重新配置链接。

配置完成后直接读取 `.mira-interview/config.env`，不得强制重复初始化。
