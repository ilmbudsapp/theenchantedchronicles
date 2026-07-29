# theenchantedchronicles

Standalone **Next.js 15** deployment of the site extracted from [agrmultimedia.eu](https://www.agrmultimedia.eu/).

- **GitHub repo:** `theenchantedchronicles`
- **Production domain:** `theenchantedchronicles.com`
- **Stack:** Next.js (static export) + React 18 + Tailwind + Wouter routing

> Content, translations, images, and story data are **unchanged** from the original demo extraction.

## Quick start (local)

```bash
npm install
cp .env.example .env.local   # Windows: copy .env.example .env.local
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Build

```bash
npm run build
```

Output: `out/` (static export).

## Deploy

See **[DEPLOYMENT.md](./DEPLOYMENT.md)** for the full pipeline:

- GitHub repo creation & push
- Vercel import & env vars
- DNS for `theenchantedchronicles.com`
- Post-deploy checklist

## Project structure

```
app/              Next.js App Router shell
src/components/   UI components
src/views/        Page views (Wouter routes)
public/           Static assets + /demo/* client demos
attached_assets/  Bundled images/videos
api/              Vercel serverless (contact fallback)
```
