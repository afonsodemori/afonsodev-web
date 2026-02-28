# afonsodev-web

This is the personal website and resume project, built using **Nuxt 4** and deployed on **Cloudflare Pages/Workers**. The project features a multi-lingual interface (English, Spanish, Portuguese) and dynamically integrates resume content from external sources.

## Core Technologies

- **Framework:** Nuxt 4 (Beta/Next) with Vue 3
- **UI Components:** @nuxt/ui (v4)
- **Internationalization:** @nuxtjs/i18n
- **Styling:** Vanilla CSS (scoped in components) and Tailwind CSS (via Nuxt UI)
- **Deployment:** Cloudflare Wrangler (Pages/Workers)
- **Tooling:** ESLint, Prettier, TypeScript, Zod
- **Testing:** Vitest, Supertest

## Project Structure

- `app/`: Main Nuxt application source.
  - `pages/`: Application routes (`index.vue`, `resume.vue`, `contact.vue`).
  - `components/`: Reusable Vue components (`Navbar.vue`, `Header.vue`, etc.).
  - `layouts/`: Page layouts (`base.vue`, `default.vue`).
- `i18n/`: Internationalization configuration and locale files.
  - `locales/generated/`: Contains resume HTML converted to YAML for SSR support.
- `bin/`: Shell scripts for prebuild and resume fetching.
- `tests/`: Integration and unit tests (mostly focused on redirections and i18n).
- `docker/`: Dockerfile and Nginx configuration for containerized deployment.
- `wrangler.jsonc`: Cloudflare configuration for assets and routing.

## Key Commands

### Development

- `npm run dev`: Starts the Nuxt development server.
- `npm run dev:public`: Starts the development server with public access.

### Build & Deploy

- `npm run build`: Executes prebuild scripts and builds the Nuxt application.
- `npm run build:resume`: Fetches the latest resume HTML and generates locale YAML files.
- `npm run preview`: Builds the project and starts a local Wrangler preview.
- `npm run deploy:production`: Builds and deploys the application to the production environment on Cloudflare.

### Quality & Maintenance

- `npm run lint`: Runs ESLint for code quality checks.
- `npm run format`: Formats the codebase using Prettier.
- `npm test`: Runs the test suite using Vitest.
- `make clean`: Resets the environment, removes build artifacts, and re-installs dependencies.

## Development Conventions

- **i18n First:** All user-facing text should be localized via `$t()` using the keys in `i18n/locales/`.
- **Surgical Prebuild:** The `bin/resume-html.sh` script is critical for ensuring the resume content is up-to-date and available for both SSR and client-side hydration.
- **Strict Linting:** The project enforces strict ESLint rules and Prettier formatting. Always run `npm run lint:fix` before committing changes.
- **Deployment Safety:** Use `npm run preview` to verify Cloudflare-specific configurations (like `_redirects` and `wrangler` settings) before deploying.
