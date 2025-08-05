#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Generate README.md with software index table from bucket manifests
.DESCRIPTION
    This script scans the bucket directory and generates a README.md file
    with an index table organized by categories based on description field format: "分类 | 名称"
.EXAMPLE
    .\bin\generate-readme.ps1
#>

param(
    [string]$BucketDir = "$PSScriptRoot/../bucket",
    [string]$OutputFile = "$PSScriptRoot/../README.md"
)

# 确保bucket目录存在
if (!(Test-Path $BucketDir)) {
    Write-Error "Bucket directory not found: $BucketDir"
    exit 1
}

Write-Host "Scanning bucket directory: $BucketDir" -ForegroundColor Green

# 获取所有JSON文件
$manifestFiles = Get-ChildItem -Path $BucketDir -Filter "*.json" | Sort-Object Name

if ($manifestFiles.Count -eq 0) {
    Write-Warning "No manifest files found in $BucketDir"
    exit 0
}

# 存储软件信息
$softwareList = @()

foreach ($file in $manifestFiles) {
    try {
        $manifest = Get-Content $file.FullName -Raw | ConvertFrom-Json
        
        # 解析description字段
        $description = $manifest.description ?? ""
        $category = "其他"
        $name = $file.BaseName
        
        # 检查是否符合 "分类 | 名称" 格式
        if ($description -match "^(.+?)\s*\|\s*(.+)$") {
            $category = $matches[1].Trim()
            $name = $matches[2].Trim()  # 软件名称是分割后的后面部分
        } elseif ($description) {
            $name = $description
        }
        
        $softwareList += [PSCustomObject]@{
            FileName = $file.BaseName
            Category = $category
            Name = $name  # 这是分割后的后面部分
            Version = $manifest.version ?? "N/A"
            Homepage = $manifest.homepage ?? ""
            License = $manifest.license ?? "N/A"
            Description = $description
            DownloadUrl = $manifest.url ?? ""
        }
        
        Write-Host "  ✓ $($file.BaseName)" -ForegroundColor Gray
    }
    catch {
        Write-Warning "Failed to parse $($file.Name): $($_.Exception.Message)"
    }
}

# 按分类分组
$groupedSoftware = $softwareList | Group-Object Category | Sort-Object Name

Write-Host "Generating README.md..." -ForegroundColor Green

# 生成README内容
$readmeContent = @"
# Scoop Xifan Bucket

![Scoop Bucket](https://img.shields.io/badge/Scoop-Bucket-orange?style=flat-square&logo=powershell)
![GitHub repo size](https://img.shields.io/github/repo-size/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub issues](https://img.shields.io/github/issues/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub stars](https://img.shields.io/github/stars/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub forks](https://img.shields.io/github/forks/xifan2333/scoop-xifan?style=flat-square&logo=github)
![Software Count](https://img.shields.io/badge/软件数量-$($softwareList.Count)-blue?style=flat-square&logo=windows)
![Categories](https://img.shields.io/badge/分类数量-$($groupedSoftware.Count)-green?style=flat-square&logo=folder)
![License](https://img.shields.io/github/license/xifan2333/scoop-xifan?style=flat-square&logo=opensourceinitiative)

个人维护的 Scoop bucket，包含一些常用软件的安装配置。

## 安装方式

``````powershell
# 添加 bucket
scoop bucket add xifan https://github.com/xifan2333/scoop-xifan

# 安装软件
scoop install xifan/<软件名>
``````

## 软件列表

> 📦 当前收录软件：**$($softwareList.Count)** 个  
> 🗃️ 分类数量：**$($groupedSoftware.Count)** 个  
> 🕐 最后更新：$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

"@

foreach ($group in $groupedSoftware) {
    $readmeContent += "`n`n### $($group.Name)`n`n"
    $readmeContent += "| 软件名称 | 版本 | 下载地址 |`n"
    $readmeContent += "|----------|------|----------|`n"

    foreach ($software in ($group.Group | Sort-Object Name)) {
        $nameWithLink = if ($software.Homepage) {
            "[$($software.Name)]($($software.Homepage))"
        } else {
            $software.Name
        }

        $downloadLink = if ($software.DownloadUrl) {
            "[$($software.FileName)]($($software.DownloadUrl))"
        } else {
            "``$($software.FileName)``"
        }

        $readmeContent += "| $nameWithLink | $($software.Version) | $downloadLink |`n"
    }
}

# 添加页脚
$readmeContent += @"

---

## 贡献指南

欢迎提交 Issue 和 Pull Request！

### 添加新软件

1. 在 ``bucket/`` 目录下创建新的 JSON manifest 文件
2. 确保 ``description`` 字段使用 ``分类 | 软件名称`` 的格式
3. 运行 ``.\bin\generate-readme.ps1`` 更新 README
4. 提交 Pull Request

### 本地测试

``````powershell
# 检查 URLs
.\bin\checkurls.ps1

# 检查 hashes
.\bin\checkhashes.ps1

# 检查版本更新
.\bin\checkver.ps1

# 生成 README
.\bin\genreadme.ps1
``````

"@

# 写入README文件
try {
    $readmeContent | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Host "✅ README.md generated successfully: $OutputFile" -ForegroundColor Green
    Write-Host "📊 Total software: $($softwareList.Count)" -ForegroundColor Cyan
    Write-Host "🗃️  Categories: $($groupedSoftware.Count)" -ForegroundColor Cyan
}
catch {
    Write-Error "Failed to write README.md: $($_.Exception.Message)"
    exit 1
}
