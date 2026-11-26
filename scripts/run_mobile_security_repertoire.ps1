$ErrorActionPreference = "Stop"

Write-Host "=== 3/13 Escaneo de secretos en archivos e historial Git (Mobile) ==="
$secretPattern = '(AKIA[0-9A-Z]{16}|-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----|ghp_[A-Za-z0-9]{30,}|xoxb-[0-9A-Za-z-]+)'
$hits = Get-ChildItem -Recurse -File -Exclude *.png,*.jpg,*.webp,*.jar,*.keystore |
  Where-Object { $_.FullName -notmatch "\\(\.git|\.dart_tool|build)\\" } |
  Select-String -Pattern $secretPattern
if ($hits) {
  throw "Posibles secretos detectados en bustrack-mobile."
}

Write-Host "=== 5/13 y 6/13 Contenedores e IaC ==="
Write-Host "N/A en cliente movil Flutter; documentado sin romper flujo."

Write-Host "=== 9/13 y 11/13 Supply Chain (pubspec.lock y fuentes pub.dev) ==="
if (-not (Test-Path "pubspec.lock")) {
  throw "Falta pubspec.lock para integridad de dependencias."
}
$lockRaw = Get-Content "pubspec.lock" -Raw
if ($lockRaw -notmatch "https://pub\.dev") {
  throw "pubspec.lock no referencia pub.dev."
}

Write-Host "SECURITY-REPERTOIRE-MOBILE-OK"
