# 音频转录

转录前必须满足：三项原始输入已复制到本 case 的 `inputs/`；`.mira-interview/config.env` 有效可信。

转录场景固定为只有两位参与者的求职面试对话：一位面试官，一位候选人（面试者）。转录脚本通过 whisper.cpp 的初始提示持续向模型提供这一上下文，帮助模型按面试语境识别和转录内容。

```bash
bash .agents/skills/mira-interview/scripts/macos/transcribe.sh \
  --project-root "$PWD" \
  --audio "$PWD/interview-artifacts/<case-name>/inputs/<archived-audio>" \
  --case-name "<case-name>"
```

以下产物写入同一 `transcription/` 目录：

- `interview-16k-mono.wav`
- `interview.txt`
- `interview.srt`
- `interview.json`
- `interview-transcript.md`

`interview-transcript.md` 是强制产物，必须完整保留 SRT 中所有有文本的片段、原有顺序和时间范围，不得省略、概括或截断长回答。

## 质量检查

1. 抽查开头、中段、结尾及专有名词密集段落。
2. 对疑点回听；无法确认时标记 `[听不清]` 或 `[疑似转录：…]`，不得自行补词。
3. 两人面试场景提示用于改善语境识别，不等于可靠的说话人识别。只有上下文证据充分时才映射角色，否则保留“说话人 A/B”。
4. 检查 Markdown 逐字稿包含 SRT 的所有文本片段；任何格式化不得合并后丢失内容。
