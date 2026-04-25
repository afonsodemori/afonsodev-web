<script setup lang="ts">
  import BaseLayout from '~/components/BaseLayout.vue';
</script>

<template>
  <BaseLayout>
    <div class="min-h-screen flex flex-col">
      <Navbar class="print:hidden" />
      <Header class="print:hidden" />

      <main class="flex-grow my-10 print:m-0">
        <slot />
      </main>

      <DefaultFooter class="print:hidden" />
    </div>
  </BaseLayout>
</template>
