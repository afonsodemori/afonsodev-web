# afonsodev-web

Source code for [afonso.dev](https://afonso.dev) — my personal portfolio and resume site.

## Stack

- **[Nuxt 4](https://nuxt.com/)** — Vue-based framework, statically generated
- **[Nuxt UI](https://ui.nuxt.com/)** — Component library built on Tailwind CSS
- **[Cloudflare Workers](https://workers.cloudflare.com/)** — Hosting and edge delivery
- **i18n** — Available in English, Spanish, and Portuguese

## Features

- Resume page with downloads in multiple formats (PDF, DOCX, Markdown, plain text)
- Contact form protected by [Cloudflare Turnstile](https://www.cloudflare.com/products/turnstile/)
- Dark mode by default
- Containerized with Docker for alternative self-hosted deployment

## Running locally

Copy `.env.example` to `.env` and adjust the values, then:

```bash
make dev
```

## License

[MIT](LICENSE)
