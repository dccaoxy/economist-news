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

## 🌐 数据源与分批策略

### 分批抓取安排

由于经济学人网站内容较多，采用**分批抓取+间隔等待**策略：

| 批次 | 模块 | URL | 说明 |
|------|------|-----|------|
| 1 | 世界简报 | https://www.economist.com/the-world-in-brief | 每日新闻摘要（10条）|
| 2 | 周刊版 | https://www.economist.com/weeklyedition/ | 完整周刊内容目录 |
| 3 | 美国 | https://www.economist.com/topics/united-states | 美国新闻 |
| 4 | 中国 | https://www.economist.com/topics/china | 中国新闻（详细摘要）|
| 5 | 商业 | https://www.economist.com/topics/business | 商业新闻 |
| 6 | 金融与经济 | https://www.economist.com/topics/finance-and-economics | 财经新闻 |
| 7 | 欧洲 | https://www.economist.com/topics/europe | 欧洲新闻 |
| 8 | 英国 | https://www.economist.com/topics/britain | 英国新闻 |

**总计**: 8 个批次

### 间隔设置

| 间隔类型 | 时长 | 说明 |
|---------|------|------|
| **批次间隔** | 10-15秒 | 每批抓取完成后等待 |
| **页面加载** | 5秒 | 每个页面加载等待时间 |
| **页面停留** | 3-5秒 | 页面停留时间（模拟真实浏览）|
| **总时长估算** | 3-5分钟 | 抓取全部内容 |

---

## 🌐 浏览器操作规范（⚠️ 必须严格遵循）

### 操作流程

```bash
# 1. 打开页面
browser action=open profile=openclaw url=https://www.economist.com/topics/china
# 返回 targetId，必须保存用于后续关闭

# 2. 等待加载（5秒）
exec sleep 5

# 3. 获取快照
browser action=snapshot profile=openclaw targetId={targetId}

# 4. 停留3-5秒（模拟阅读）
exec sleep 3

# 5. 【强制】关闭页面（释放资源）
# ⚠️ 必须执行，否则会导致浏览器标签页堆积
browser action=close profile=openclaw targetId={targetId}
```

### 🚨 资源释放规范

**必须关闭页面的情况**：
- ✅ 每个板块抓取完成后立即关闭
- ✅ 批次内所有页面抓取完成后检查并关闭残留
- ✅ 任务中断/异常时清理所有已打开页面
- ✅ 子代理执行时必须传递 targetId 并确保关闭

**检查命令**：
```bash
# 检查当前所有标签页
browser action=tabs profile=openclaw

# 批量关闭所有经济学人相关页面（清理用）
# 遍历 tabs 结果，关闭所有 url 包含 economist.com 的页面
```

**子代理执行要求**：
- 子代理必须在 `finally` 块或确保执行的代码段中关闭页面
- 父代理应在子代理完成后检查并清理残留标签页
- 记录每个打开的 targetId，确保可追溯关闭

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

- ✅ 任务完成后**关闭所有临时打开的板块页面**
- ✅ 使用 `profile: openclaw`
- ✅ **强制关闭**：每个页面抓取完成后必须立即关闭

**关闭页面的原因**：
- 避免浏览器积累过多标签页
- 防止内存泄漏和性能下降
- 保持浏览器稳定性

**完整执行流程代码示例**：
```python
def execute_skill():
    opened_tabs = []  # 记录所有打开的页面 targetId
    
    # 1. 读取配置
    config = read_economist_config()
    job = read_job_list()
    
    # 2. 检查或创建文档
    if not config.doc_token:
        doc = create_feishu_doc(
            title="📰 The Economist - 经济学人新闻汇总",
            owner_open_id=user_open_id
        )
        config.doc_token = doc.token
        config.doc_url = doc.url
        config.first_execution = now()
    
    config.execution_count += 1
    job.status = "running"
    job.last_update = now()
    save_job_list(job)
    
    try:
        # 3. 循环抓取批次
        for batch_num in range(1, 9):
            if batch_num in job.completed_batches:
                continue  # 跳过已完成批次
            
            batch = job.batches[str(batch_num)]
            job.current_batch = batch_num
            save_job_list(job)
            
            # 打开页面
            target_id = browser_open(batch.url)
            opened_tabs.append(target_id)
            
            sleep(5)
            content = browser_snapshot(target_id)
            
            # 解析文章
            articles = parse_articles(content)
            batch.articles = len(articles)
            batch.status = "completed"
            job.completed_batches.append(batch_num)
            job.total_articles += len(articles)
            
            # 立即关闭页面
            browser_close(target_id)
            opened_tabs.remove(target_id)
            
            # 更新文档
            append_to_document(config.doc_token, articles)
            
            # 发送通知
            send_notification(batch_num, len(articles), config.doc_url)
            
            # 批次间隔
            if batch_num < 8:
                sleep(10)
        
        # 4. 任务完成
        job.status = "completed"
        
        # 5. 记录执行历史
        config.history.append({
            "execution": config.execution_count,
            "time": now(),
            "batches": job.completed_batches.copy(),
            "articles": job.total_articles
        })
        
    finally:
        # 6. 清理资源
        cleanup_all_tabs(opened_tabs)
        save_config(config)
        save_job_list(job)

def cleanup_all_tabs(opened_tabs):
    """清理所有已打开的标签页"""
    for target_id in opened_tabs:
        try:
            browser_close(target_id)
        except:
            pass
    
    # 额外检查：关闭所有经济学人相关页面
    all_tabs = browser_list_tabs()
    for tab in all_tabs:
        if "economist.com" in tab.url and tab.type == "page":
            try:
                browser_close(tab.targetId)
            except:
                pass
```

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

## 📁 文件结构与执行记录

```
skills/economist-news/
└── SKILL.md                    # 本文件

economist_job_list.json         # 任务状态文件（自动创建）
economist_config.json           # 执行记录文件（自动创建）
```

### 执行记录机制（防止重复创建文档）

**位置**: `/Users/caoxy/.openclaw/agents/news-officer/economist_config.json`

**作用**: 记录首次创建的飞书文档信息，后续执行都更新同一文档

**内容示例**:
```json
{
  "first_execution": "2026-03-20T07:30:00+08:00",
  "execution_count": 5,
  "doc_token": "YOUR_DOC_TOKEN",
  "doc_url": "https://feishu.cn/docx/ABC123",
  "doc_title": "📰 The Economist - 经济学人新闻汇总",
  "history": [
    {
      "execution": 1,
      "time": "2026-03-20T07:30:00+08:00",
      "batches": [1, 2, 3, 4, 5, 6, 7, 8],
      "articles": 25
    }
  ],
  "settings": {
    "cron_schedule": "30 7 * * *",
    "batch_interval": 10,
    "page_load_wait": 5,
    "page_stay_time": 3
  }
}
```

### 任务状态文件

**位置**: `/Users/caoxy/.openclaw/agents/news-officer/economist_job_list.json`

**作用**: 记录批次进度，支持断点续传

**内容示例**:
```json
{
  "task": "economist-news",
  "total_batches": 8,
  "completed_batches": [1, 2],
  "current_batch": 3,
  "status": "running",
  "batches": {
    "1": {"status": "completed", "module": "世界简报", "articles": 10},
    "2": {"status": "completed", "module": "周刊版", "articles": 8},
    "3": {"status": "pending", "module": "美国", "articles": 0}
  }
}
```

### 💓 Heartbeat 自动续传机制

**执行流程**:
```
1. 开始执行 Skill
   ↓
2. 创建 economist_job_list.json 记录进度
   ↓
3. 设置 Heartbeat 检查（每5分钟）
   ↓
4. 执行批次抓取
   ↓
5. 如果中断：
   - Heartbeat 检测到未完成任务
   - 自动继续执行
   ↓
6. 全部完成后：
   - 更新 economist_job_list.json 为完成状态
   - 更新 economist_config.json 执行历史
   - 终止 Heartbeat 检查
```

### 相关配置

- **Cron 任务**: `economist-daily`（每天 7:30）
- **文档标题**: `📰 The Economist - 经济学人新闻汇总`
- **推送目标**: 用户飞书 ID（从 inbound 元数据获取）
