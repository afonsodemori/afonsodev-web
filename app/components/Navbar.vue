<script setup lang="ts">
  import type { NavigationMenuItem } from '@nuxt/ui';

  const { locale, t, setLocale } = useI18n();
  const localePath = useLocalePath();

  const items = computed<NavigationMenuItem[][]>(() => [
    [
      {
        label: t('nav.index'),
        to: localePath('index'),
        icon: 'i-lucide-home',
      },
      {
        label: t('nav.resume'),
        to: localePath('resume'),
        icon: 'i-lucide-briefcase-business',
      },
      {
        label: t('nav.contact'),
        to: localePath('contact'),
        icon: 'i-lucide-mail',
      },
    ],
    [
      {
        label: 'GitHub',
        icon: 'i-simple-icons-github',
        to: '/github',
        target: '_blank',
      },
      {
        label: 'LinkedIn',
        icon: 'i-simple-icons-linkedin',
        to: '/linkedin',
        target: '_blank',
      },
      {
        label: locale.value.toUpperCase(),
        icon: 'i-lucide-earth',
        children: [
          { code: 'en', label: 'English' },
          { code: 'es', label: 'Español' },
          { code: 'pt', label: 'Português' },
        ].map((lang) => ({
          label: lang.label,
          active: locale.value === lang.code,
          onSelect: () => setLocale(lang.code as 'en' | 'es' | 'pt'),
        })),
      },
    ],
  ]);
</script>

<template>
  <UHeader mode="slideover">
    <template #title>
      <Logo class="h-6 w-auto" />
    </template>

    <UNavigationMenu :items="items[0]" />

    <template #right>
      <UButton
        color="neutral"
        variant="ghost"
        to="https://www.linkedin.com/in/afonsodemori/"
        target="_blank"
        icon="i-simple-icons-linkedin"
        aria-label="LinkedIn"
      />

      <UButton
        color="neutral"
        variant="ghost"
        to="https://github.com/afonsodemori"
        target="_blank"
        icon="i-simple-icons-github"
        aria-label="GitHub"
      />
    </template>

    <template #body>
      <UNavigationMenu :items="items" orientation="vertical" class="gap-5" />
    </template>
  </UHeader>
</template>
