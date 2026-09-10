# Mira Interview

一个用于复盘单场求职面试的 Codex skill。它结合与同一场面试对应的**简历、岗位 JD 和面试录音**，生成带时间戳的完整逐字稿，以及有证据、可执行的面试诊断报告。

## Quickstart

安装并启用本 skill 后，在 Codex 中上传简历、JD 和面试录音，然后发送：

```text
请使用 $mira-interview 分析这场面试。
公司：<公司名称>
面试日期：<YYYY-MM-DD>
轮次：<第 X 轮 / HR / 终面>
附件：
- 简历：<附件或文件路径>
- JD：<附件、正文或文件路径>
- 面试录音：<附件或文件路径>
```

首次使用时，skill 会引导完成本地转录环境和模型配置。目前仅支持 macOS，依赖默认通过 Homebrew 安装。

## TODO

- [ ] 对比以下转录模型：
  - `Paraformer-large`：中文长音频
  - `SenseVoiceSmall`：中文识别效率和精度
  - `Whisper large-v3` 未量化版：拆分 `turbo` 与量化分别造成的质量损失
  - 当前使用的 `Whisper large-v3-turbo Q5_0` 量化版
- [ ] 扩展操作系统支持（按常见性）：
  - [ ] Windows
  - [ ] Linux
  - [ ] ChromeOS
- [ ] 解决转录结果中 `[00:00:00,000 --> 00:00:13,360] 说话人未标注` 的问题，支持转录模型原生识别说话人角色，而不是依赖大模型理解、推理并补充角色标签。

欢迎体验、反馈问题，也欢迎提交 PR 一起完善这个 skill！
