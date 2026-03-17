# Economist News Skill 仓库初始化脚本
# 使用方法：.\init-repo.ps1

Write-Host "🚀 初始化 economist-news GitHub 仓库..." -ForegroundColor Green

$repoPath = "C:\Users\caoxy-test\.openclaw\data-analysis-workspace\economist-news"
Set-Location $repoPath

# 检查 Git 是否安装
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git 未安装，请先安装 Git: https://git-scm.com/" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Git 已安装" -ForegroundColor Green

# 检查 Git 配置
$userName = git config --global user.name
$userEmail = git config --global user.email

if (-not $userName -or -not $userEmail) {
    Write-Host "⚠️  Git 未配置用户名和邮箱" -ForegroundColor Yellow
    Write-Host "请执行以下命令配置：" -ForegroundColor Gray
    Write-Host "  git config --global user.name `"dccaoxy`"" -ForegroundColor Gray
    Write-Host "  git config --global user.email `"你的邮箱@example.com`"" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "是否继续？(y/n)"
    if ($continue -ne 'y') {
        exit 1
    }
}

# 初始化 Git 仓库
Write-Host "📦 初始化 Git 仓库..." -ForegroundColor Yellow
git init

# 添加所有文件
Write-Host "📝 添加文件..." -ForegroundColor Yellow
git add .

# 首次提交
Write-Host "💾 创建首次提交..." -ForegroundColor Yellow
git commit -m "Initial commit: economist-news skill for OpenClaw"

# 重命名分支为 main
Write-Host "🔀 重命名分支为 main..." -ForegroundColor Yellow
git branch -M main

Write-Host "`n✅ 仓库初始化完成！" -ForegroundColor Green

Write-Host "`n📍 接下来需要执行以下步骤：" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣ 在 GitHub 创建新仓库:" -ForegroundColor White
Write-Host "   访问：https://github.com/new" -ForegroundColor Gray
Write-Host "   仓库名：economist-news" -ForegroundColor Gray
Write-Host "   可见性：Public" -ForegroundColor Gray
Write-Host "   ❌ 不要勾选 'Add a README file'" -ForegroundColor Gray
Write-Host ""
Write-Host "2️⃣ 关联远程仓库并推送:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/dccaoxy/economist-news.git" -ForegroundColor Gray
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "📋 或者复制粘贴以下命令一键执行：" -ForegroundColor Cyan
Write-Host "   git remote add origin https://github.com/dccaoxy/economist-news.git && git push -u origin main" -ForegroundColor Gray
Write-Host ""
