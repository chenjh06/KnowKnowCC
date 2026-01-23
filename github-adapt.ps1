# GitHub 阅读体验适配脚本
# 功能：将所有 skills/ 路径引用更新为 advanced/，确保 GitHub 链接正常

$ErrorActionPreference = "Stop"
$rootPath = "D:\AIWork\claude_code\work\knowknowcc\KnowKnowCC"

Write-Host "`n=== GitHub 阅读体验适配工具 ===" -ForegroundColor Cyan
Write-Host "开始更新路径引用...`n" -ForegroundColor Yellow

$stats = @{
    TotalFiles = 0
    UpdatedFiles = 0
    SkippedFiles = 0
    Errors = 0
}

Get-ChildItem -Path $rootPath -Recurse -File -Filter "*.md" | ForEach-Object {
    $stats.TotalFiles++
    $filePath = $_.FullName
    $relativePath = $_.FullName.Replace($rootPath, "").TrimStart("\")

    try {
        $content = Get-Content -Path $filePath -Raw -Encoding UTF8
        $original = $content

        # 1. Markdown 链接路径替换
        $replacements = @{
            # 相对路径链接
            '\]\(\./skills/' = '](./advanced/'
            '\]\(\.\./skills/' = '](../advanced/'
            '\[skills/\]\(' = '[advanced/]('

            # 文本中的路径引用
            '路径：\[skills/\]' = '路径：[advanced/]'
            '：\[skills/\]' = '：[advanced/]'

            # 代码块和图表中的路径
            '├── skills/' = '├── advanced/'
            '└── skills/' = '└── advanced/'
            '│   ├── skills/' = '│   ├── advanced/'

            # 特定子目录
            'skills/a-productivity' = 'advanced/a-productivity'
            'skills/b-code-quality' = 'advanced/b-code-quality'
            'skills/c-integration' = 'advanced/c-integration'
            'skills/d-skills-development' = 'advanced/d-skills-development'
        }

        foreach ($key in $replacements.Keys) {
            $content = $content -replace $key, $replacements[$key]
        }

        if ($content -ne $original) {
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            $stats.UpdatedFiles++
            Write-Host "✓ 已更新: $relativePath" -ForegroundColor Green
        } else {
            $stats.SkippedFiles++
        }

    } catch {
        $stats.Errors++
        Write-Host "✗ 错误: $relativePath - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 输出统计报告
Write-Host "`n=== 更新统计 ===" -ForegroundColor Cyan
Write-Host "总文件数: $($stats.TotalFiles)" -ForegroundColor White
Write-Host "已更新: $($stats.UpdatedFiles)" -ForegroundColor Green
Write-Host "跳过: $($stats.SkippedFiles)" -ForegroundColor Gray
Write-Host "错误: $($stats.Errors)" -ForegroundColor Red

if ($stats.UpdatedFiles -gt 0) {
    Write-Host "`n✓ GitHub 阅读体验适配完成！" -ForegroundColor Green
    Write-Host "  所有 skills/ 路径已更新为 advanced/" -ForegroundColor White
} else {
    Write-Host "`n⚠ 未发现需要更新的文件" -ForegroundColor Yellow
}

Write-Host "`n下一步建议：" -ForegroundColor Cyan
Write-Host "  1. 在本地测试所有链接是否正常" -ForegroundColor White
Write-Host "  2. 提交到 GitHub 并验证渲染效果" -ForegroundColor White
Write-Host "  3. 检查表格格式和代码高亮" -ForegroundColor White
