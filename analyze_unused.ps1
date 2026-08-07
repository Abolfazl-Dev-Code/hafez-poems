$libPath = ".\lib"

$folderCount = (Get-ChildItem -Path $libPath -Directory -Recurse -Force | Measure-Object).Count
$dartFileCount = (Get-ChildItem -Path $libPath -Filter *.dart -File -Recurse -Force | Measure-Object).Count

Write-Host "تعداد کل فولدرها (تو در تو): $folderCount"
Write-Host "تعداد کل فایل‌های .dart: $dartFileCount"