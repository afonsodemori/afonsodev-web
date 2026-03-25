export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  runtimeConfig: {
    public: {
      nodeEnv: process.env.NODE_ENV,
      websiteHost: process.env.WEBSITE_HOST,
      apiBaseUrl: process.env.API_BASE_URL,
      turnstileKey: process.env.TURNSTILE_KEY,
    },
  },

  // nitro: {
  //   preset: 'static',
  //   prerender: {
  //     autoSubfolderIndex: false,
  //   },
  // },

  modules: ['@nuxtjs/i18n', '@nuxt/ui', '@nuxt/fonts'],

  css: ['~/assets/base.css'],

  colorMode: {
    storageKey: 'theme',
    preference: 'dark',
  },

  i18n: {
    locales: [
      { code: 'en', language: 'en-US', files: ['en-US.yaml', 'generated/en-resume.yaml'] },
      { code: 'es', language: 'es-ES', files: ['es-ES.yaml', 'generated/es-resume.yaml'] },
      { code: 'pt', language: 'pt-BR', files: ['pt-BR.yaml', 'generated/pt-resume.yaml'] },
    ],
    defaultLocale: 'en',
    strategy: 'prefix_and_default',
    compilation: { strictMessage: false, escapeHtml: false },
    //bundle: { optimizeTranslationDirective: false },
  },

  fonts: {
    defaults: {
      // TODO: Should be variable, but failing for some reason
      weights: [200],
    },
  },

  routeRules: {
    '/linkedin': { redirect: { to: 'https://www.linkedin.com/in/afonsodemori/', statusCode: 308 } },
    '/github': { redirect: { to: 'https://github.com/afonsodemori', statusCode: 308 } },
  },
});
