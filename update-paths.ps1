# 批量替换 skills/ 为 advanced/
$rootPath = "D:\AIWork\claude_code\work\knowknowcc\KnowKnowCC"

Get-ChildItem -Path $rootPath -Recurse -File -Filter "*.md" | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $original = $content

    # 替换各种路径引用格式
    $content = $content -replace '\]\(\./skills/', '](./advanced/'
    $content = $content -replace '\]\(\.\./skills/', '](../advanced/'
    $content = $content -replace '链接\[skills/\]', '链接[advanced/]'
    $content = $content -replace '：\[skills/\]', '：[advanced/]'
    $content = $content -replace '`\[skills/\]`', '`[advanced/]`'

    # 替换目录路径引用（在代码块中）
    $content = $content -replace '│   ├── skills/', '│   ├── advanced/'
    $content = $content -replace '└── skills/', '└── advanced/'
    $content = $content -replace '├── skills/', '├── advanced/'
    $content = $content -replace 'skills/a-', 'advanced/a-'
    $content = $content -replace 'skills/b-', 'advanced/b-'
    $content = $content -replace 'skills/c-', 'advanced/c-'
    $content = $content -replace 'skills/d-', 'advanced/d-'

    if ($content -ne $original) {
        Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
        Write-Host "✓ Updated: $filePath" -ForegroundColor Green
    }
}

Write-Host "`n批量替换完成！" -ForegroundColor Cyan
