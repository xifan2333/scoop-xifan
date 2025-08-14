# Scoop Xifan Bucket

![Scoop Bucket](https://img.shields.io/badge/Scoop-Bucket-orange?style=flat-square&logo=powershell)
![GitHub repo size](https://img.shields.io/github/repo-size/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub issues](https://img.shields.io/github/issues/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub stars](https://img.shields.io/github/stars/xifan2333/scoop-xifan?style=flat-square&logo=github)
![GitHub forks](https://img.shields.io/github/forks/xifan2333/scoop-xifan?style=flat-square&logo=github)
![Software Count](https://img.shields.io/badge/软件数量-2-blue?style=flat-square&logo=windows)
![Categories](https://img.shields.io/badge/分类数量-2-green?style=flat-square&logo=folder)
![License](https://img.shields.io/github/license/xifan2333/scoop-xifan?style=flat-square&logo=opensourceinitiative)

![banner](assets/banner.png)  
  
个人维护的 Scoop bucket，收集一些 Windows 上常用的软件

## 安装方式

```powershell
# 添加 bucket
scoop bucket add xifan https://github.com/xifan2333/scoop-xifan

# 安装软件
scoop install xifan/<软件名>
```

## 软件列表

> 📦 当前收录软件：**2** 个  
> 🗃️ 分类数量：**2** 个  
> 🕐 最后更新：2025-08-14 19:39:28


### 🛠️ 维护工具

| 软件名称 | 版本 | 下载地址 |
|----------|------|----------|
| [Geek 卸载工具专业版](https://pan.xifan.fun/scoop/) | 3.7.3.5719 | [uninstall-tool](https://pan.xifan.fun/d/scoop/uninstall-tool.zip) |


### 🛠️ 抓包工具

| 软件名称 | 版本 | 下载地址 |
|----------|------|----------|
| [Burp Suite 吾爱破解版](https://www.52pojie.cn/thread-2005151-1-1.html) | 2025.7 | [burp](https://pan.xifan.fun/d/scoop/burp.zip) |

---

## 贡献指南

欢迎提交 Issue 和 Pull Request！

### 添加新软件

1. 在 `bucket/` 目录下创建新的 JSON manifest 文件
2. 确保 `description` 字段使用 `分类 | 软件名称` 的格式
3. 运行 `.\bin\generate-readme.ps1` 更新 README
4. 提交 Pull Request

### 本地测试

```powershell
# 检查 URLs
.\bin\checkurls.ps1

# 检查 hashes
.\bin\checkhashes.ps1

# 检查版本更新
.\bin\checkver.ps1

# 生成 README
.\bin\genreadme.ps1
```

