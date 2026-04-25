<script setup>
  const localePath = useLocalePath();
</script>

<template>
  <NuxtLink :to="localePath('/')" class="flex items-center gap-2" v-bind="$attrs">
    <img src="/static/icons/favicon-192.png" alt="Afonso de Mori" class="h-full w-auto" />
    <span class="font-semibold">
      Afonso
      <span class="hidden [@media(min-width:350px)]:inline">de Mori</span>
      <span class="[@media(min-width:350px)]:hidden text-muted dev">.dev</span>
    </span>
  </NuxtLink>
</template>

<style>
  .dev {
    margin-left: -0.25ch;
  }
</style>
