# CLAUDE.md

这个文件包含了为 Claude Code 提供的代码库文档和配置说明。

## Agent skills

### Issue tracker

问题在 GitHub Issues 中跟踪。外部 PR 也作为请求来源纳入分类队列。详见 `docs/agents/issue-tracker.md`。

### Triage labels

使用标准标签词汇：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。详见 `docs/agents/triage-labels.md`。

### Domain docs

单一上下文布局：仓库根目录有 `CONTEXT.md` 和 `docs/adr/`（四篇：001 双引擎算法、002 四层架构、003 FastAPI 选型、004 LLM 智能解释）。详见 `docs/agents/domain.md`。
