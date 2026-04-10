# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

All common tasks are orchestrated via `make`:

| Command                    | Description                                                    |
| -------------------------- | -------------------------------------------------------------- |
| `make dev`                 | Start dev server (defaults to port 3000)                       |
| `make build`               | Build for production                                           |
| `make generate-preview`    | Static site generation using `.env.preview`                    |
| `make generate-production` | Static site generation using `.env.production`                 |
| `make deploy-preview`      | Full clean + generate + Cloudflare Workers deploy (preview)    |
| `make deploy-production`   | Full clean + generate + Cloudflare Workers deploy (production) |
| `make clean`               | Remove build artifacts, reinstall deps, run prebuild           |
| `make docker-build`        | Build multi-platform Docker image                              |
| `make docker-run`          | Run Docker container on port 8080                              |
| `make tunnel-run`          | Run Cloudflare tunnel for local development                    |
| `make import-resume`       | Import resume HTML via `bin/resume-html.sh`                    |

There is no test suite. There are no `scripts` in `package.json` — use `make` or invoke `npx nuxt` directly.

**Code formatting**: Prettier with single quotes, semicolons, 120-char line width, trailing commas. Run `npx prettier --write .` to format.

## Architecture

This is a personal portfolio **static site** (Nuxt 4 with `preset: 'static'`) for Afonso de Mori, deployed to **Cloudflare Workers**.

### Nuxt app directory layout

The project uses Nuxt's `app/` directory convention. The three routes are:

- `/` → `app/pages/index.vue` — Landing page with bio and social links
- `/resume` → `app/pages/resume.vue` — Fetches resume HTML from external CDN (`static.afonso.dev`), manipulates DOM (rewrites links, strips timestamps), provides download dropdowns
- `/contact` → `app/pages/contact.vue` — Contact form with Zod validation and Cloudflare Turnstile CAPTCHA; POSTs to `config.public.apiBaseUrl/contact`

### Layouts

- `app/layouts/default.vue` — Navbar + Header + slot + DefaultFooter (used by resume and contact)
- `app/layouts/base.vue` — Minimal wrapper (used by index)
- `app/error.vue` — Custom 404/error page

### Internationalization

Three locales: `en` (default), `es`, `pt`. Strategy is `prefix_and_default`, so routes are `/en/...`, `/es/...`, `/pt/...` with `/` redirecting to `/en`. Translation files are YAML under `i18n/locales/`. Resume HTML is fetched per-locale from the CDN and injected directly into the page.

### Runtime config

Environment variables (see `.env.example`) map to Nuxt runtime config in `nuxt.config.ts`:

- `NUXT_PUBLIC_API_BASE_URL` → `config.public.apiBaseUrl` (backend API)
- `NUXT_PUBLIC_TURNSTILE_KEY` → `config.public.turnstileKey` (Cloudflare Turnstile site key)
- `NUXT_PUBLIC_WEBSITE_HOST` → `config.public.websiteHost` (canonical domain for SEO)
- `NODE_ENV` → `config.nodeEnv`

### Cloudflare deployment

`wrangler.jsonc` configures Workers deployment. Static assets go to `_worker.js/` output. Redirects for `/linkedin` and `/github` are defined as route rules in `nuxt.config.ts`.

### Docker / nginx path

`docker/` contains a production nginx config and `Dockerfile.production` builds a multi-platform Alpine image pushed to `ghcr.io/afonsodemori/afonsodev-web`. This is an alternative deployment path to Cloudflare Workers.

### Prebuild

`bin/prebuild.sh` creates empty locale resume YAML stubs (`i18n/locales/en-resume.yaml` etc.) if they don't exist. This runs automatically during `make clean` and before generates.
