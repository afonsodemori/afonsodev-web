<script setup lang="ts">
  import type { FooterColumn } from '@nuxt/ui';
  const { t } = useI18n();
  const localePath = useLocalePath();

  const columns = computed<FooterColumn[]>(() => [
    {
      label: t('footer.site'),
      children: [
        { label: t('nav.index'), to: localePath('index') },
        { label: t('nav.resume'), to: localePath('resume') },
        { label: t('nav.contact'), to: localePath('contact') },
      ],
    },
    {
      label: t('footer.projects'),
      children: [
        {
          label: 'afonsodev-resume-sync',
          to: 'https://github.com/afonsodemori/afonsodev-resume-sync',
          target: '_blank',
        },
        { label: 'ephemeral-web', to: 'https://github.com/afonsodemori/ephemeral-web', target: '_blank' },
        { label: 'fns-cli', to: 'https://github.com/afonsodemori/fns-cli', target: '_blank' },
      ],
    },
    {
      label: t('footer.profiles'),
      children: [
        { label: 'GitHub', to: 'https://afonso.dev/github', target: '_blank', icon: 'i-simple-icons-github' },
        { label: 'LinkedIn', to: 'https://afonso.dev/linkedin', target: '_blank', icon: 'i-simple-icons-linkedin' },
      ],
    },
  ]);
</script>

<template>
  <USeparator
    :avatar="{
      src: '/static/icons/favicon-192.png',
      loading: 'lazy',
    }"
  />
  <UFooter>
    <template #top>
      <UContainer>
        <UFooterColumns :columns="columns">
          <template #left>
            <div class="flex flex-col gap-1 text-sm">
              <span class="font-medium text-highlighted">Afonso de Mori Ayres da Silva</span>
              <span class="text-xs text-dimmed italic">{{ t('footer.subtitle') }}</span>
              <p class="text-muted mt-2 max-w-xs leading-relaxed">
                {{ t('footer.tagline') }}
              </p>
            </div>
          </template>
        </UFooterColumns>
      </UContainer>
    </template>
  </UFooter>
</template>
