# Economist 新闻获取

## 技能说明

从《经济学人》杂志网站抓取新闻内容，翻译成中文并推送到飞书，同时将内容存储到飞书文档中便于查阅和去重。

## 触发条件

用户发送以下内容时激活：
- "经济学人"
- "economist"
- "获取新闻"
- "新闻推送"

---

## 📄 飞书文档创建方法

### 首次创建文档

**重要**：必须传入 `owner_open_id`（用户的飞书 ID），确保用户有完整访问权限。

```json
{
  "action": "create",
  "title": "📰 The Economist - 经济学人新闻汇总",
  "owner_open_id": "YOUR_FEISHU_OPEN_ID"  // 替换为你的飞书 ID
}
```

**参数说明**：
- `action`: "create" - 创建文档
- `title`: 文档标题（建议包含 emoji 📰 便于识别）
- `owner_open_id`: **必填** - 用户的飞书 open_id（从 inbound 元数据 `sender_id` 获取）

**如果不传 owner_open_id**：
- ❌ 只有 bot app 有访问权限
- ✅ 传入后用户自动获得 `full_access` 权限

### 文档 Token 管理

创建成功后保存 `doc_token`：
```json
{
  "document_id": "YOUR_DOC_TOKEN",
  "doc_token": "YOUR_DOC_TOKEN"  // 替换为实际文档 token
}
```

后续操作使用 `doc_token` 而非 `document_id`。

---

## 📋 飞书文档输出范式

### 文档结构（Markdown 格式）

```markdown
# 📰 The Economist - 经济学人新闻汇总

## 更新日期：YYYY-MM-DD

---

## 📅 YYYY-MM-DD 更新

### 🌍 世界简报

**快速了解全球重要新闻**

1. **[新闻标题 1]**
   - [详细内容，简洁概括核心要点]

2. **[新闻标题 2]**
   - [详细内容，简洁概括核心要点]

---

### 📰 周刊版

**YYYY 年 M 月 D 日**

#### 社论

1. **[文章标题]**
   - [简短摘要，1-2句话概括核心观点]

#### 美国

1. **[文章标题]**
   - [简短摘要]

#### 中国

1. **[文章标题]**
   - [简短摘要]

#### 💼 商业

1. **[文章标题]**
   - [简短摘要]

#### 💰 金融与经济

1. **[文章标题]**
   - [简短摘要]

#### 中东与非洲

1. **[文章标题]**
   - [简短摘要]

#### 欧洲

1. **[文章标题]**
   - [简短摘要]

#### 英国

1. **[文章标题]**
   - [简短摘要]

---

### 🇨🇳 中国 - 详细文章

#### 1. **[文章标题]**
- **日期**: YYYY-MM-DD
- **栏目**: [栏目名称]
- **阅读时间**: X 分钟

**摘要**: [200-300 字详细摘要，完整概括文章核心内容、观点和背景]

---

#### 2. **[文章标题]**
- **日期**: YYYY-MM-DD
- **栏目**: [栏目名称]
- **阅读时间**: X 分钟

**摘要**: [200-300 字详细摘要，完整概括文章核心内容、观点和背景]

---

**📄 文档链接**: https://xxx.feishu.cn/docx/[doc_token]

---

*下次更新将在明天早上 7:30 自动执行*
```

### 模块顺序（固定）

1. 🌍 **世界简报** (World in Brief) - 10条主要新闻，简洁概括
2. 📰 **周刊版** (Weekly Edition) - 各板块简短列表
   - 社论 (Leaders)
   - 美国 (United States)
   - 中国 (China)
   - 💼 商业 (Business)
   - 💰 金融与经济 (Finance & Economics)
   - 中东与非洲 (Middle East & Africa)
   - 欧洲 (Europe)
   - 英国 (Britain)
3. 🇨🇳 **中国 - 详细文章** (China 板块深度文章) - 200-300字详细摘要

### 标题规范

- ✅ **只保留中文标题**，去掉英文原文
- ✅ 添加 emoji 标识便于浏览
- ✅ 使用 Markdown 标题层级（# ## ### ####）

### 内容规范

| 字段 | 格式 | 示例 | 说明 |
|------|------|------|------|
| 日期 | YYYY-MM-DD | 2026-03-17 | 文章发布日期 |
| 阅读时间 | X 分钟 | 5 分钟 | 预计阅读时长 |
| 摘要（周刊版）| 1-2句话 | 简洁概括 | 简短列表用 |
| 摘要（详细版）| 200-300 字 | 完整概括 | 中国详细文章用 |

### 输出格式要点

1. **世界简报**：简洁概括，每条新闻一段，突出核心要点
2. **周刊版各板块**：简短列表形式，每篇文章1-2句话概括
3. **中国详细文章**：200-300字完整摘要，包含背景、核心观点和影响
4. **不输出URL**：文档中不包含文章链接（但抓取时用于去重）

---

## 🔄 文档更新流程

### 1. 读取现有文档（去重用）

```json
{
  "action": "read",
  "doc_token": "YOUR_DOC_TOKEN"
}
```

**解析内容**：
- 提取已有文章标题列表
- 提取已有文章 URL 列表（用于去重，不输出到文档）
- 用于后续去重比对

### 2. 去重逻辑

```python
# 伪代码示例
existing_titles = [...]  # 从文档解析的标题
existing_urls = [...]    # 从文档解析的 URL（仅用于去重）

for article in new_articles:
    if article.title in existing_titles:
        continue  # 跳过
    if article.url in existing_urls:
        continue  # 跳过
    # 标题相似度>90% 也跳过
    if similarity(article.title, existing_titles) > 0.9:
        continue
    
    # 新文章，添加到更新列表
    new_articles_to_add.append(article)
```

**去重策略**：
- 标题完全匹配 → 跳过
- URL 完全匹配 → 跳过（URL仅用于去重，不输出）
- 标题相似度>90% → 跳过（避免同一文章不同表述）

### 3. 写入文档（全量重写）

```json
{
  "action": "write",
  "doc_token": "YOUR_DOC_TOKEN",
  "content": "# 📰 The Economist - 经济学人新闻汇总\n\n## 更新日期：2026-03-17\n\n---\n\n## 📅 2026-03-17 更新\n\n[完整 Markdown 内容...]"
}
```

**为什么用 write 而不是 append**：
- ✅ 可以控制整体结构
- ✅ 确保最新内容在顶部
- ✅ 便于维护文档格式一致性

### 4. 更新文档顶部日期

每次更新时修改顶部的"更新日期"为当前日期。

---

## 🌐 数据源

| 模块 | URL | 说明 |
|------|-----|------|
| 主页 | https://www.economist.com/ | 入口页面 |
| 世界简报 | https://www.economist.com/the-world-in-brief | 每日新闻摘要 |
| 周刊版 | https://www.economist.com/weeklyedition/ | 完整周刊内容 |
| 美国 | https://www.economist.com/topics/united-states | 美国新闻 |
| 中国 | https://www.economist.com/topics/china | 中国新闻（详细摘要） |
| 商业 | https://www.economist.com/topics/business | 商业新闻 |
| 金融与经济 | https://www.economist.com/topics/finance-and-economics | 财经新闻 |

---

## 🌐 浏览器操作规范

### 打开页面

```json
{
  "action": "open",
  "profile": "openclaw",
  "targetUrl": "https://www.economist.com/topics/china"
}
```

### 获取内容

```json
{
  "action": "snapshot",
  "profile": "openclaw",
  "targetId": "TARGET_ID",
  "compact": true
}
```

### 关闭页面（重要！）

**每次获取完文章内容后，必须关闭该标签页**，避免浏览器资源占用：

```json
{
  "action": "close",
  "profile": "openclaw",
  "targetId": "TARGET_ID"
}
```

**保留主页不关闭**：经济学人主页作为入口始终保留。

---

## 📤 飞书消息推送范式

### 推送格式

```markdown
📰 **The Economist - [模块名称]**

*发布日期*

---

[文章标题]

[文章内容摘要翻译，100-300 字]

---

[下一篇文章...]
```

### 推送要求

1. **每篇文章必须包含**：
   - 文章标题
   - 发布日期
   - **全文翻译**（完整内容，不只是摘要）

2. **长文章处理**：
   - 如果文章较长，可**分条发送**（每条不超过 2000 字）
   - 在每条末尾标注 "（1/X）"、"（2/X）" 等

3. **发送到飞书**：
   - 使用 `message` 工具
   - `channel: feishu`
   - `target: 用户 ID`

4. **文档更新通知**：
   - 推送消息中说明本次新增 X 篇文章
   - 附上飞书文档链接供查阅

### 推送示例

```markdown
📰 **The Economist - 世界简报**

*2026 年 3 月 20 日*

---

**以色列-伊朗战争最新进展**

以色列总理内塔尼亚胡声称伊朗不再具备浓缩铀或制造弹道导弹的能力...

---

✅ 本次新增 21 篇文章，已更新至飞书文档
📄 文档链接：https://xxx.feishu.cn/docx/ABC123def
```

---

## ⏰ 定时任务配置

### Cron 任务

```yaml
# 每天 7:30 自动执行
economist-daily:
  schedule: "30 7 * * *"
  task: "获取经济学人最新内容并更新文档"
```

### 执行流程

```
07:30 → 触发 economist-news 技能
      → 打开经济学人网站
      → 获取各模块文章列表
      → 去重检查
      → 写入飞书文档（新内容在顶部）
      → 推送飞书消息通知
      → 关闭浏览器页面
```

---

## ⚠️ 注意事项

### 飞书文档

- ✅ 首次创建必须传入 `owner_open_id`
- ✅ 使用 `write` 动作全量重写（而非 append）
- ✅ 最新内容放在文档最上端
- ✅ 标题只保留中文，去掉英文
- ✅ 使用 emoji 标识模块（🌍📰💼💰🇨🇳）
- ✅ **不输出URL**：URL仅用于去重，文档中不显示
- ✅ **200-300字摘要**：中国详细文章部分必须达到此字数

### 浏览器管理

- ✅ 任务完成后**只保留经济学人主页面**（https://www.economist.com）
- ✅ 关闭所有临时打开的板块页面和文章页面
- ✅ 保持登录状态（不关闭主页面）
- ✅ 使用 `profile: openclaw`

**关闭页面的原因**：
- 避免浏览器积累过多标签页
- 保持登录状态（主页面的 cookies 有效）
- 下次执行时从主页面重新导航，确保内容最新

### 去重逻辑

- ✅ 基于标题和 URL 双重去重
- ✅ URL仅用于去重，不输出到文档
- ✅ 标题相似度>90% 也跳过
- ✅ 避免同一文章不同表述导致的重复

### 翻译与内容

- ✅ 翻译时保持原意，可适当简化
- ✅ 世界简报：简洁概括核心要点
- ✅ 周刊版：简短列表，1-2句话概括
- ✅ 中国详细文章：200-300字完整摘要
- ✅ 如果是付费内容，尽量获取免费摘要

---

## 🛠️ 技术备注

### 工具使用

| 操作 | 工具 | 参数 |
|------|------|------|
| 创建文档 | `feishu_doc` | `action: create` |
| 读取文档 | `feishu_doc` | `action: read` |
| 写入文档 | `feishu_doc` | `action: write` |
| 打开页面 | `browser` | `action: open` |
| 获取内容 | `browser` | `action: snapshot` |
| 关闭页面 | `browser` | `action: close` |
| 推送消息 | `message` | `action: send` |

### 关键配置

- browser profile: `openclaw`
- 获取页面快照后解析内容
- 翻译使用模型自带能力
- 飞书文档操作使用 `feishu_doc` 工具

---

## 📁 文件结构

```
skills/economist-news/
└── SKILL.md          # 本文件
```

### 相关配置

- **Cron 任务**: `economist-daily`（每天 7:30）
- **文档标题**: `📰 The Economist - 经济学人新闻汇总`
- **推送目标**: 用户飞书 ID（从 inbound 元数据获取）
