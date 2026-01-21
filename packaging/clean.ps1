# Ensure we're running from the packaging directory
Push-Location $PSScriptRoot

Read-Host 'are you sure you want to clean the packaging directory? This will delete the "dist" and "build" folders. (y/n)' | ForEach-Object {
    if ($_ -eq 'y') {
        Write-Host "Cleaning packaging directory..." -ForegroundColor Yellow
        if (Test-Path "./dist") { Remove-Item -Recurse -Force "./dist" }
        if (Test-Path "./build") { Remove-Item -Recurse -Force "./build" }
        if (Test-Path "./*.spec") { Remove-Item -Force "./*.spec" }
        Write-Host "Packaging directory cleaned." -ForegroundColor Green
    } else {
        Write-Host "Clean operation cancelled." -ForegroundColor Cyan
    }
}

Pop-Location
