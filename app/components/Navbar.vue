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
        class="opacity-70 hover:opacity-100"
      />

      <UButton
        color="neutral"
        variant="ghost"
        to="https://github.com/afonsodemori"
        target="_blank"
        icon="i-simple-icons-github"
        class="opacity-70 hover:opacity-100"
        aria-label="GitHub"
      />

      <USelect
        :model-value="locale"
        :items="[
          { value: 'en', label: 'English' },
          { value: 'es', label: 'Español' },
          { value: 'pt', label: 'Português' },
        ]"
        @update:model-value="setLocale($event)"
        class="opacity-70 hover:opacity-100 hidden [@media(min-width:460px)]:inline"
      ></USelect>
    </template>

    <template #body>
      <UNavigationMenu :items="items" orientation="vertical" class="gap-5" />
    </template>
  </UHeader>
</template>
