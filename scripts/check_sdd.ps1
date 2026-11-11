#Requires -Version 5.1
<#
.SYNOPSIS
  Puerta SDD para BusTrack Mobile (Flutter + Dart): valida specs/, specs-endpoints/, Aprobación, plan/task/chart y checklists.
#>
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$failed = $false

function Fail([string]$message) {
  Write-Output "SDD-FAIL: $message"
  $script:failed = $true
}

foreach ($doc in @("constitution.md", "AGENTS.md", "Memoria.md", "CHECKLIST_PR.md")) {
  if (-not (Test-Path -LiteralPath (Join-Path $root $doc))) { Fail "Falta $doc" }
}

$specs = Get-ChildItem -LiteralPath (Join-Path $root "specs") -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -notmatch '^(_template|templates)' }
if (-not $specs) { Fail "sin carpetas en specs/" }

foreach ($spec in $specs) {
  $specFile = Join-Path $spec.FullName "spec.md"
  if (-not (Test-Path -LiteralPath $specFile)) { Fail "$($spec.Name) sin spec.md"; continue }
  $text = Get-Content -LiteralPath $specFile -Raw
  if ($text -notmatch "Estado:") { Fail "$($spec.Name)/spec.md sin Estado:" }
  if ($text -notmatch "## Aprobaci") { Fail "$($spec.Name)/spec.md sin bloque de Aprobación" }
  foreach ($req in @("plan.md", "task.md", "chart.md")) {
    if (-not (Test-Path -LiteralPath (Join-Path $spec.FullName $req))) { Fail "$($spec.Name) sin $req" }
  }
  if (-not (Test-Path -LiteralPath (Join-Path $spec.FullName "checklists"))) { Fail "$($spec.Name) sin checklists/" }
}

$endpointSpecs = Get-ChildItem -LiteralPath (Join-Path $root "specs-endpoints") -Directory -ErrorAction SilentlyContinue
foreach ($es in $endpointSpecs) {
  $esFile = Join-Path $es.FullName "spec.md"
  if (-not (Test-Path -LiteralPath $esFile)) { Fail "specs-endpoints/$($es.Name) sin spec.md"; continue }
  $esText = Get-Content -LiteralPath $esFile -Raw
  if ($esText -notmatch "## Aprobaci") { Fail "specs-endpoints/$($es.Name)/spec.md sin bloque de Aprobación" }
}

if ($failed) { Write-Output "SDD-FAIL"; exit 1 }
Write-Output "SDD-OK"
