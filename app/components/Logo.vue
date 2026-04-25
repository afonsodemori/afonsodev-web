<script setup>
  const localePath = useLocalePath();
  const autoActive = ref(false);
  const hovering = ref(false);
  const showDev = computed(() => autoActive.value || hovering.value);

  let autoInterval, resetTimeout;

  onMounted(() => {
    autoInterval = setInterval(() => {
      autoActive.value = true;
      resetTimeout = setTimeout(() => {
        autoActive.value = false;
      }, 5000);
    }, 30000);
  });

  onUnmounted(() => {
    clearInterval(autoInterval);
    clearTimeout(resetTimeout);
  });
</script>

<template>
  <NuxtLink
    :to="localePath('/')"
    class="flex items-center gap-2"
    v-bind="$attrs"
    @mouseenter="hovering = true"
    @mouseleave="hovering = false"
  >
    <img src="/static/icons/favicon-192.png" alt="Afonso de Mori" class="h-full w-auto" />
    <span class="font-semibold">
      Afonso
      <span class="[@media(min-width:350px)]:hidden text-muted dev">.dev</span>
      <span class="hidden [@media(min-width:350px)]:inline-block suffix-clip">
        <span class="suffix-reel" :class="{ 'show-dev': showDev }">
          <span>&nbsp;de Mori</span>
          <span class="text-muted">.dev</span>
        </span>
      </span>
    </span>
  </NuxtLink>
</template>

<style>
  .suffix-clip {
    margin-left: -0.25ch;
    overflow: hidden;
    height: 1.1em;
    vertical-align: text-bottom;
  }

  .suffix-reel {
    display: flex;
    flex-direction: column;
    transition: transform 0.2s ease-in-out;
  }

  .suffix-reel.show-dev {
    transform: translateY(-50%);
  }

  .suffix-reel > span {
    height: 1em;
    line-height: 1;
  }

  .dev {
    margin-left: -0.25ch;
  }
</style>
