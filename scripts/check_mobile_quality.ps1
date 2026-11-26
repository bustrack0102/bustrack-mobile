$ErrorActionPreference = "Stop"

Write-Host "1. Formato y Linting Dart/Flutter..."
dart format --output=none --set-exit-if-changed .
flutter analyze

Write-Host "2. Pruebas Unitarias, Widget, Integracion, Contrato, Snapshot y Concurrencia + Cobertura..."
flutter test --coverage

Write-Host "3. Dependencias desactualizadas o sin usar..."
flutter pub outdated

Write-Host "4. Validacion SDD..."
powershell -File scripts/check_sdd.ps1

Write-Host "MOBILE-QUALITY-GATE-OK"
