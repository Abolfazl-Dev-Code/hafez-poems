$libRoot = "D:\Hafez App\hafez_poems\lib"

$map = @{
    "const Color(0xFF1FA855)" = "AppColors.success"
    "Color(0xFF1FA855)"       = "AppColors.success"
}

$files = Get-ChildItem -Path $libRoot -Recurse -Filter *.dart

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $touched = $false

    foreach ($key in $map.Keys) {
        if ($content -match [regex]::Escape($key)) {
            $content = $content -replace [regex]::Escape($key), $map[$key]
            $touched = $true
        }
    }

    if ($touched) {
        if ($content -notmatch "theme/color_style.dart") {
            if ($content -match "import 'package:flutter/material.dart';") {
                $content = $content -replace "import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';`nimport 'package:hafez_poems/theme/color_style.dart';"
            } else {
                $content = "import 'package:hafez_poems/theme/color_style.dart';`n" + $content
            }
        }
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "UPDATED: $($file.FullName)" -ForegroundColor Green
    }
}