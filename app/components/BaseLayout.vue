<script setup lang="ts">
  useHead({
    link: [
      { rel: 'manifest', href: '/manifest.json' },
      { rel: 'apple-touch-icon', href: '/apple-touch-icon.png' },
      { rel: 'icon', href: '/favicon.ico' },
    ],
  });
</script>

<template>
  <slot />
</template>
