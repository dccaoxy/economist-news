# Economist News - OpenClaw Skill

📰 自动获取《经济学人》杂志新闻内容，翻译成中文并推送到飞书。

---

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/dccaoxy/economist-news.git

# 复制 SKILL.md 到你的 OpenClaw skills 目录
cp economist-news/SKILL.md \
   ~/.openclaw/data-analysis-workspace/skills/economist-news/

# Windows PowerShell
Copy-Item economist-news/SKILL.md \
  ~/.openclaw/data-analysis-workspace/skills/economist-news/
```

### 重启 OpenClaw

```bash
openclaw gateway restart
```

---

## 📖 功能说明

### 触发词

发送以下消息时激活：
- "经济学人"
- "economist"
- "获取新闻"
- "新闻推送"

### 功能

1. ✅ 自动访问经济学人网站获取最新内容
2. ✅ 翻译成中文
3. ✅ 推送到飞书消息
4. ✅ 存储到飞书文档（自动去重）
5. ✅ 每天 7:30 自动更新（Cron 任务）

### 必推模块

- 🌍 World in Brief（世界简报）
- 📰 Weekly Edition（周刊版）
- 🇺🇸 United States（美国）
- 🇨🇳 China（中国）
- 💼 Business（商业）
- 💰 Finance & Economics（金融与经济）

---

## 📋 配置说明

### 飞书文档

首次运行时会自动创建飞书文档：
- **标题**: 📰 The Economist - 经济学人新闻汇总
- **权限**: 自动授予用户完整访问权限
- **更新**: 新内容始终放在文档最上端
- **去重**: 基于标题和 URL 自动去重

### Cron 任务

配置每日自动更新（可选）：

```yaml
# 在 OpenClaw 配置中添加
cron:
  economist-daily:
    schedule: "30 7 * * *"  # 每天 7:30
    task: "获取经济学人最新内容并更新文档"
```

---

## 🛠️ 使用示例

### 手动触发

在飞书中发送：
```
经济学人
```

### 自动更新

配置 Cron 后，每天早上 7:30 自动获取并更新文档。

---

## 📁 文件结构

```
economist-news/
├── README.md      # 本文件
├── SKILL.md       # 技能规范文档（核心）
├── LICENSE        # MIT 协议
└── .gitignore    # Git 忽略文件
```

---

## ⚙️ 技术细节

### 使用的工具

| 工具 | 用途 |
|------|------|
| `browser` | 访问经济学人网站 |
| `feishu_doc` | 创建和更新飞书文档 |
| `message` | 推送飞书消息 |

### 数据源

| 模块 | URL |
|------|-----|
| 主页 | https://www.economist.com/ |
| 世界简报 | https://www.economist.com/the-world-in-brief |
| 周刊版 | https://www.economist.com/weeklyedition/ |
| 中国 | https://www.economist.com/topics/china |
| 商业 | https://www.economist.com/topics/business |
| 金融与经济 | https://www.economist.com/topics/finance-and-economics |

---

## ❓ 常见问题

### Q1: Skill 不生效怎么办？

**检查**：
- [ ] SKILL.md 是否在正确的目录？
- [ ] 是否重启了 OpenClaw Gateway？
- [ ] 触发词是否完全匹配？

### Q2: 飞书文档创建失败？

**检查**：
- [ ] 飞书渠道是否已配置？
- [ ] 是否有 `docx:document` 权限？

### Q3: 如何查看日志？

```bash
openclaw logs
# 或
openclaw gateway logs
```

---

## 📄 许可证

MIT License

本技能采用 MIT 开源协议，你可以自由使用、修改和分发。

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

仓库地址：https://github.com/dccaoxy/economist-news

---

## 📞 联系方式

- **GitHub**: [@dccaoxy](https://github.com/dccaoxy)
- **OpenClaw 社区**: [Discord](https://discord.com/invite/clawd)

---

**Made with ❤️ for OpenClaw**
