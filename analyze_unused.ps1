$libRoot = "D:\Hafez App\hafez_poems\lib"

$candidates = @(
    "homeScreenUnit\biographyUnit\biography_audio_button.dart",
    "homeScreenUnit\biographyUnit\biography_screen_auto_scroll.dart",
    "homeScreenUnit\podcastUnit\podcast_banner.dart",
    "homeScreenUnit\moshaereHelper\moshaere_helper_banner.dart",
    "homeScreenUnit\faalUnit\fal_service.dart",
    "homeScreenUnit\poemBoxesUnit\box_names_and_subnames.dart",
    "poemsUnit\poemContextMenuUnit\poem_menu_measure_size.dart",
    "poemsUnit\poems\api_services.dart",
    "poemsUnit\verseShareUnit\share_preview_card.dart",
    "navbarHomeScreenUnit\bottomNavBar\selectable_cards_page.dart",
    "models\search_utils.dart",
    "core\data\box_names.dart"
)

$allDartFiles = Get-ChildItem -Path $libRoot -Recurse -Filter *.dart

foreach ($candidate in $candidates) {
    $fullPath = Join-Path $libRoot $candidate
    $baseName = Split-Path $candidate -Leaf

    $refs = $allDartFiles | Where-Object { $_.FullName -ne $fullPath } | ForEach-Object {
        Select-String -Path $_.FullName -Pattern ([regex]::Escape($baseName)) -SimpleMatch
    }

    if ($refs) {
        Write-Host "USED: $candidate" -ForegroundColor Green
        $refs | ForEach-Object { Write-Host "    $($_.Path):$($_.LineNumber)" }
    } else {
        Write-Host "NOT USED: $candidate" -ForegroundColor Red
    }
}