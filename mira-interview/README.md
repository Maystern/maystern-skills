<div align="center">

# 🎙️ Mira Interview

**从面试录音到可执行复盘，一次完成。**

基于简历、岗位 JD 和面试录音的单场面试诊断 Codex Skill

`macOS` · `本地转录` · `证据驱动`

</div>

---

## ✨ 能做什么

<table align="center">
  <thead>
    <tr>
      <th align="center">📚 输入</th>
      <th align="center"></th>
      <th align="center">📊 输出</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">简历 · 岗位 JD · 面试录音</td>
      <td align="center">→</td>
      <td align="center">带时间戳的完整逐字稿<br>有证据、可执行的面试诊断报告</td>
    </tr>
  </tbody>
</table>

## 🚀 Quickstart

安装并启用本 Skill 后，在 Codex 中上传与同一场面试对应的三项材料，然后发送：

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

> [!NOTE]
> 首次使用时，Skill 会引导完成本地转录环境和模型配置。目前仅支持 macOS，依赖默认通过 Homebrew 安装。

## 🗺️ Roadmap

### 模型评测

- [ ] `Paraformer-large`：中文长音频
- [ ] `SenseVoiceSmall`：中文识别效率和精度
- [ ] `Whisper large-v3` 未量化版：拆分 `turbo` 与量化分别造成的质量损失
- [ ] 当前使用的 `Whisper large-v3-turbo Q5_0` 量化版

### 跨平台支持

- [ ] Windows
- [ ] Linux
- [ ] ChromeOS

### 说话人识别

- [ ] 解决 `[00:00:00,000 --> 00:00:13,360] 说话人未标注` 问题，支持转录模型原生识别说话人角色，而不是依赖大模型理解、推理并补充角色标签。

---

<div align="center">

欢迎体验和反馈，也欢迎提交 PR，一起完善 Mira Interview！

</div>
