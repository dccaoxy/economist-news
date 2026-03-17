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
  "owner_open_id": "ou_bdf988ce0ce0e7d8432055e7d1606f69"
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
  "document_id": "N2jsd2HMpoCrEXx744CcbmeJnIb",
  "doc_token": "N2jsd2HMpoCrEXx744CcbmeJnIb"
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

#### 主要新闻摘要

1. **[新闻标题 1]**
   - [详细内容]

2. **[新闻标题 2]**
   - [详细内容]

---

### 📰 周刊版

**YYYY 年 M 月 D 日**

#### 社论

1. **[文章标题]**
   - [摘要]

#### 美国

1. **[文章标题]**

#### 中国

1. **[文章标题]**

#### 💼 商业

1. **[文章标题]**

#### 💰 金融与经济

1. **[文章标题]**

#### 中东与非洲

1. **[文章标题]**

#### 欧洲

1. **[文章标题]**

#### 英国

1. **[文章标题]**

---

### 🇨🇳 中国 - 详细文章

#### 1. **[文章标题]**
- **日期**: YYYY-MM-DD
- **栏目**: [栏目名称]
- **阅读时间**: X 分钟
- **URL**: https://www.economist.com/...

**摘要**: [200-300 字摘要]

---

#### 2. **[文章标题]**
- **日期**: YYYY-MM-DD
- **栏目**: [栏目名称]
- **阅读时间**: X 分钟
- **URL**: https://www.economist.com/...

**摘要**: [200-300 字摘要]

---

**📄 文档链接**: https://xxx.feishu.cn/docx/[doc_token]

---

*下次更新将在明天早上 7:30 自动执行*
```

### 模块顺序（固定）

1. 🌍 **世界简报** (World in Brief)
2. 📰 **周刊版** (Weekly Edition)
   - 社论 (Leaders)
   - 美国 (United States)
   - 中国 (China)
   - 💼 商业 (Business) ← 在中国下面
   - 💰 金融与经济 (Finance & Economics) ← 在商业下面
   - 中东与非洲 (Middle East & Africa)
   - 欧洲 (Europe)
   - 英国 (Britain)
3. 🇨🇳 **中国 - 详细文章** (China 板块深度文章)

### 标题规范

- ✅ **只保留中文标题**，去掉英文原文
- ✅ 添加 emoji 标识便于浏览
- ✅ 使用 Markdown 标题层级（# ## ### ####）

### 内容规范

| 字段 | 格式 | 示例 |
|------|------|------|
| 日期 | YYYY-MM-DD | 2026-03-17 |
| 阅读时间 | X 分钟 | 5 分钟 |
| URL | 完整链接 | https://www.economist.com/china/... |
| 摘要 | 200-300 字 | 简洁概括核心内容 |

---

## 🔄 文档更新流程

### 1. 读取现有文档（去重用）

```json
{
  "action": "read",
  "doc_token": "N2jsd2HMpoCrEXx744CcbmeJnIb"
}
```

**解析内容**：
- 提取已有文章标题列表
- 提取已有文章 URL 列表
- 用于后续去重比对

### 2. 去重逻辑

```python
# 伪代码示例
existing_titles = [...]  # 从文档解析的标题
existing_urls = [...]    # 从文档解析的 URL

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
- URL 完全匹配 → 跳过
- 标题相似度>90% → 跳过（避免同一文章不同表述）

### 3. 写入文档（全量重写）

```json
{
  "action": "write",
  "doc_token": "N2jsd2HMpoCrEXx744CcbmeJnIb",
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

| 模块 | URL |
|------|-----|
| 主页 | https://www.economist.com/ |
| 世界简报 | https://www.economist.com/the-world-in-brief |
| 周刊版 | https://www.economist.com/weeklyedition/ |
| 美国 | https://www.economist.com/topics/united-states |
| 中国 | https://www.economist.com/topics/china |
| 商业 | https://www.economist.com/topics/business |
| 金融与经济 | https://www.economist.com/topics/finance-and-economics |

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
  "targetId": "94A6062AD66810BB71826563A27ADBC3",
  "compact": true
}
```

### 关闭页面（重要！）

**每次获取完文章内容后，必须关闭该标签页**，避免浏览器资源占用：

```json
{
  "action": "close",
  "profile": "openclaw",
  "targetId": "94A6062AD66810BB71826563A27ADBC3"
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
   - 文章标题（可链接）
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

*2026 年 3 月 17 日*

---

**伊朗战争进展**

特朗普称美国已打击伊朗 7000+ 目标，"彻底摧毁"政权...
（内容摘要）

---

✅ 本次新增 5 篇文章，已更新至飞书文档
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

### 浏览器管理

- ✅ 每次获取完文章后**必须关闭页面**
- ✅ 保留经济学人主页作为入口
- ✅ 使用 `profile: openclaw`

### 去重逻辑

- ✅ 基于标题和 URL 双重去重
- ✅ 标题相似度>90% 也跳过
- ✅ 避免同一文章不同表述导致的重复

### 翻译与内容

- ✅ 翻译时保持原意，可适当简化
- ✅ 文章 URL 必须可点击跳转
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
