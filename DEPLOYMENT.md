# Deployment pipeline — theenchantedchronicles.com

Complete guide for GitHub → Vercel → custom domain.  
**No content changes** — deployment configuration only.

---

## 1. Build configuration (verified)

| File | Setting | Status |
|------|---------|--------|
| `next.config.ts` | `output: "export"` | Static HTML export to `out/` |
| `next.config.ts` | `images.unoptimized: true` | Required for static export |
| `vercel.json` | `framework: "nextjs"` | Auto-detected by Vercel |
| `vercel.json` | `outputDirectory: "out"` | Matches static export |
| `vercel.json` | `buildCommand: "npm run build"` | Standard Next build |

**Why static export?** The site uses client-side Wouter routing inside a Next.js shell (`ssr: false`). Static export matches the original SPA behaviour and works on Vercel with rewrites for `/demo/*`.

---

## 2. Environment variables

Copy `.env.example` → `.env.local` for local dev.

### Vercel → Settings → Environment Variables

| Variable | Required | Scope | Description |
|----------|----------|-------|-------------|
| `NEXT_PUBLIC_EMAILJS_SERVICE_ID` | Yes* | Production, Preview | EmailJS service ID for contact form |
| `NEXT_PUBLIC_EMAILJS_TEMPLATE_ID` | Yes* | Production, Preview | EmailJS template ID |
| `NEXT_PUBLIC_EMAILJS_PUBLIC_KEY` | Yes* | Production, Preview | EmailJS public key |
| `NEXT_PUBLIC_GA_MEASUREMENT_ID` | No | Production | Google Analytics ID (`G-…`), loads after cookie consent |

\*Contact form works only when all three EmailJS vars are set.

### Optional server-side (Vercel only, not in .env.example as NEXT_PUBLIC)

For `api/contact.ts` SMTP fallback — add in Vercel if not using EmailJS:

- `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `CONTACT_TO_EMAIL`

---

## 3. Create GitHub repository

### Option A — Automated (PowerShell + GitHub token)

1. Create a [Personal Access Token](https://github.com/settings/tokens) with **repo** scope.
2. Run from project root:

```powershell
cd "C:\Users\User\Desktop\CURSOR Ai\theenchantedchronicles"
$env:GITHUB_TOKEN = "ghp_YOUR_TOKEN_HERE"
.\scripts\create-github-repo.ps1
# For organization repo:
# .\scripts\create-github-repo.ps1 -Org "ilmbudsapp"
```

This creates `theenchantedchronicles`, initializes git (if needed), and pushes `main`.

### Option B — Manual (GitHub website)

1. Go to [github.com/new](https://github.com/new)
2. Repository name: **`theenchantedchronicles`**
3. Visibility: Public (or Private)
4. **Do not** add README / .gitignore (already in project)
5. Create repository

Then push:

```powershell
cd "C:\Users\User\Desktop\CURSOR Ai\theenchantedchronicles"
git init -b main
git add -A
git commit -m "Initial commit: standalone Next.js site from agrmultimedia.eu extraction"
git remote add origin https://github.com/YOUR_USERNAME/theenchantedchronicles.git
git push -u origin main
```

Or use existing commit:

```powershell
.\scripts\push-to-github.ps1 -RemoteUrl "https://github.com/ilmbudsapp/theenchantedchronicles.git"
```

---

## 4. Vercel deployment

### Import project

1. [vercel.com/new](https://vercel.com/new) → Import Git Repository
2. Select **`theenchantedchronicles`**
3. **Root Directory:** `.` (repo root)
4. **Framework Preset:** Next.js (auto)
5. **Build Command:** `npm run build` (default)
6. **Output Directory:** `out` (from `vercel.json`)

### Environment variables

Add all vars from section 2 before first production deploy.

### Deploy

Click **Deploy**. First build ~2–5 min (large `public/` + `attached_assets/`).

### Production URL

Vercel assigns: `https://theenchantedchronicles.vercel.app` (or similar).

---

## 5. Custom domain — theenchantedchronicles.com

### In Vercel

1. Project → **Settings** → **Domains**
2. Add: `theenchantedchronicles.com`
3. Add: `www.theenchantedchronicles.com`
4. Set primary domain (recommend apex `theenchantedchronicles.com`, redirect www → apex)

Vercel shows required DNS records after adding domains.

### DNS records (standard Vercel)

#### Apex domain (`theenchantedchronicles.com`)

| Type | Host | Value | TTL |
|------|------|-------|-----|
| **A** | `@` | `76.76.21.21` | Automatic / 300 |

#### WWW subdomain

| Type | Host | Value | TTL |
|------|------|-------|-----|
| **CNAME** | `www` | `cname.vercel-dns.com` | Automatic / 300 |

> Vercel may show a unique `cname.vercel-dns.com` target — use the value shown in your Vercel dashboard if it differs.

---

### Namecheap instructions

1. Login → **Domain List** → **Manage** for `theenchantedchronicles.com`
2. **Advanced DNS** tab
3. Remove conflicting A/CNAME records for `@` and `www`
4. Add:

   - **A Record** — Host: `@` — Value: `76.76.21.21`
   - **CNAME** — Host: `www` — Value: `cname.vercel-dns.com`

5. Save. Propagation: 5 min – 48 h (usually < 1 h)

---

### Cloudflare instructions

1. Add site to Cloudflare (if not already)
2. **DNS** → **Records**
3. Add:

   - **A** — Name: `@` — IPv4: `76.76.21.21` — Proxy: **DNS only** (grey cloud) initially*
   - **CNAME** — Name: `www` — Target: `cname.vercel-dns.com` — Proxy: **DNS only**

4. **SSL/TLS** → Full (strict) after certificate is active on Vercel

\*Orange cloud (proxied) can work but may delay SSL verification; use grey cloud until Vercel shows “Valid Configuration”.

---

### Domain propagation verification

```powershell
# Check A record
nslookup theenchantedchronicles.com

# Check www CNAME
nslookup www.theenchantedchronicles.com

# Online: https://dnschecker.org
```

**Vercel dashboard:** Domains tab shows ✅ Valid Configuration when DNS is correct.

**HTTPS:** Vercel auto-provisions Let's Encrypt (5–10 min after DNS propagates).

---

## 6. Post-deploy tests

Run after domain is live:

| # | Test | Expected |
|---|------|----------|
| 1 | `https://theenchantedchronicles.com/` | Home loads, hero + navigation |
| 2 | `/kontakt` | Contact page, form visible |
| 3 | `/portfolio` | Portfolio grid |
| 4 | `/demo/enchanted-chronicles/` | Static demo loads |
| 5 | `/demo/enchanted-chronicles/stories/midnight-fisherman.html` | Story page |
| 6 | Language switch EN/DE | UI switches (where i18n enabled) |
| 7 | Contact form submit | EmailJS success (with env vars set) |
| 8 | Cookie consent → GA | Analytics only after accept (if GA id set) |
| 9 | Mobile menu | Hamburger opens/closes |
| 10 | `https://theenchantedchronicles.com/sitemap.xml` | Sitemap serves |

---

## 7. Final checklist

| Step | Status | Action |
|------|--------|--------|
| ☐ Repo created | Pending | Run `create-github-repo.ps1` or create on GitHub |
| ☐ Project pushed | Pending | `git push -u origin main` |
| ☐ Vercel project imported | Pending | vercel.com/new |
| ☐ Env vars set | Pending | EmailJS (+ optional GA) |
| ☐ First deploy green | Pending | Check Vercel build logs |
| ☐ Domain added in Vercel | Pending | Settings → Domains |
| ☐ DNS configured | Pending | Namecheap or Cloudflare |
| ☐ DNS propagated | Pending | nslookup / Vercel ✅ |
| ☐ HTTPS active | Pending | Automatic on Vercel |
| ☐ Post-deploy tests | Pending | Section 6 |

---

## 8. Troubleshooting

**Build fails on Vercel (memory/timeout)**  
- Large assets in `public/` and `attached_assets/` — upgrade Vercel plan or enable `NODE_OPTIONS=--max-old-space-size=4096` in build env.

**404 on client routes (`/kontakt`, etc.)**  
- Next static export generates HTML per route via `generateStaticParams`. If 404, confirm build log shows 39 routes. Vercel should serve `out/kontakt.html` or equivalent.

**Demo routes 404**  
- Confirm `vercel.json` rewrites for `/demo/:slug` → `/demo/:slug/index.html`.

**Contact form silent fail**  
- Check all three `NEXT_PUBLIC_EMAILJS_*` vars in Vercel Production environment.

---

## 9. Repository location

Local deploy-ready folder:

```
C:\Users\User\Desktop\CURSOR Ai\theenchantedchronicles\
```

Source copy also remains in monorepo:

```
AGRMULTIMEDIA/agrmultimedia-standalone/
```

Use **`theenchantedchronicles/`** as the root of the new GitHub repository.
