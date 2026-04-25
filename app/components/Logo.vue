<script setup>
  const localePath = useLocalePath();
</script>

<template>
  <NuxtLink :to="localePath('/')" class="flex items-center gap-2" v-bind="$attrs">
    <img src="/static/icons/favicon-192.png" alt="Afonso de Mori" class="h-full w-auto" />
    <span class="font-semibold">Afonso de Mori</span>
  </NuxtLink>
</template>
