# Deployment checklist — theenchantedchronicles.com

| # | Task | Status |
|---|------|--------|
| 1 | Standalone folder prepared | ✅ `C:\Users\User\Desktop\CURSOR Ai\theenchantedchronicles\` |
| 2 | `next.config.ts` verified (`output: "export"`) | ✅ |
| 3 | `vercel.json` verified (`outputDirectory: "out"`) | ✅ |
| 4 | `.env.example` documented | ✅ |
| 5 | Git initialized + initial commit | ✅ local `main` |
| 6 | GitHub repo `theenchantedchronicles` created | ⏳ **You** — see below |
| 7 | Push to GitHub | ⏳ **You** — needs remote |
| 8 | Vercel import + env vars | ⏳ **You** |
| 9 | Domain DNS (Namecheap/Cloudflare) | ⏳ **You** |
| 10 | Post-deploy tests | ⏳ after go-live |

## Next command (GitHub push)

```powershell
cd "C:\Users\User\Desktop\CURSOR Ai\theenchantedchronicles"
$env:GITHUB_TOKEN = "ghp_YOUR_TOKEN"
.\scripts\create-github-repo.ps1 -Org "ilmbudsapp"
```

Or manual push after creating repo on github.com/new:

```powershell
.\scripts\push-to-github.ps1 -RemoteUrl "https://github.com/ilmbudsapp/theenchantedchronicles.git"
```

Full details: [DEPLOYMENT.md](./DEPLOYMENT.md)
