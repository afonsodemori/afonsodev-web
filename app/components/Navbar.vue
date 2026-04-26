<script setup lang="ts">
  import type { NavigationMenuItem } from '@nuxt/ui';

  const { locale, t, setLocale } = useI18n();
  const localePath = useLocalePath();

  const menuItems = computed<NavigationMenuItem[][]>(() => [
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
        to: 'https://github.com/afonsodemori',
        target: '_blank',
      },
      {
        label: 'LinkedIn',
        icon: 'i-simple-icons-linkedin',
        to: 'https://www.linkedin.com/in/afonsodemori/',
        target: '_blank',
      },
    ],
  ]);

  const languageItems = computed(() => [
    { value: 'en', label: 'English' },
    { value: 'es', label: 'Español' },
    { value: 'pt', label: 'Português' },
  ]);
</script>

<template>
  <UHeader mode="slideover">
    <template #title>
      <Logo class="h-6 w-auto" />
    </template>

    <UNavigationMenu :items="menuItems[0]" />

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
        icon="i-lucide-globe-2"
        :model-value="locale"
        :items="languageItems"
        @update:model-value="setLocale($event)"
        class="opacity-75 hover:opacity-100 hidden lg:inline"
      ></USelect>
    </template>

    <template #body>
      <UNavigationMenu :items="menuItems" orientation="vertical" class="gap-5" />

      <div class="text-center">
        <USeparator class="my-4" />
        <USelect
          icon="i-lucide-globe-2"
          :model-value="locale"
          :items="languageItems"
          @update:model-value="setLocale($event)"
          class="opacity-75 hover:opacity-100"
        ></USelect>
      </div>
    </template>
  </UHeader>
</template>
