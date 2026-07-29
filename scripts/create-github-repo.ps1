# Create GitHub repo "theenchantedchronicles" and push initial commit.
# Requires: GitHub Personal Access Token with "repo" scope.
#
# Usage:
#   $env:GITHUB_TOKEN = "ghp_xxxxxxxx"
#   .\scripts\create-github-repo.ps1
#   # optional: -Org "ilmbudsapp"  (default: your user account)

param(
  [string]$Org = "",
  [string]$RepoName = "theenchantedchronicles",
  [switch]$Private
)

$ErrorActionPreference = "Stop"
$token = $env:GITHUB_TOKEN
if (-not $token) {
  Write-Error "Set GITHUB_TOKEN first: `$env:GITHUB_TOKEN = 'ghp_...'"
}

$headers = @{
  Authorization = "Bearer $token"
  Accept        = "application/vnd.github+json"
  "X-GitHub-Api-Version" = "2022-11-28"
}

$body = @{
  name        = $RepoName
  description = "Standalone Next.js site — extracted from agrmultimedia.eu demo"
  private     = [bool]$Private
  auto_init   = $false
} | ConvertTo-Json

if ($Org) {
  $url = "https://api.github.com/orgs/$Org/repos"
} else {
  $url = "https://api.github.com/user/repos"
}

Write-Host "Creating repo $RepoName..."
try {
  Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ContentType "application/json"
} catch {
  if ($_.Exception.Response.StatusCode -eq 422) {
    Write-Host "Repo may already exist — continuing with push."
  } else {
    throw
  }
}

$root = Split-Path $PSScriptRoot -Parent
if (-not (Test-Path (Join-Path $root ".git"))) {
  Set-Location $root
  git init -b main
  git add -A
  git commit -m "Initial commit: standalone Next.js site from agrmultimedia.eu extraction"
}

$user = (Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers).login
$remoteOwner = if ($Org) { $Org } else { $user }
$remoteUrl = "https://github.com/$remoteOwner/$RepoName.git"

Set-Location $root
git remote remove origin 2>$null
git remote add origin $remoteUrl
git push -u origin main

Write-Host ""
Write-Host "Done: https://github.com/$remoteOwner/$RepoName"
