# Push existing local repo to GitHub (repo must already exist).
# Usage:
#   .\scripts\push-to-github.ps1 -RemoteUrl "https://github.com/ilmbudsapp/theenchantedchronicles.git"

param(
  [Parameter(Mandatory = $true)]
  [string]$RemoteUrl
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

if (-not (Test-Path ".git")) {
  git init -b main
  git add -A
  git commit -m "Initial commit: standalone Next.js site from agrmultimedia.eu extraction"
}

git remote remove origin 2>$null
git remote add origin $RemoteUrl
git push -u origin main
Write-Host "Pushed to $RemoteUrl"
