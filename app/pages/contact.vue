<script setup lang="ts">
  import * as z from 'zod';
  import type { FormSubmitEvent } from '@nuxt/ui';

  const { t, locale, locales } = useI18n();
  const config = useRuntimeConfig();
  const route = useRoute();

  const isDevelopment = config.public.nodeEnv === 'development';
  const host = config.public.websiteHost;
  const apiBaseUrl = config.public.apiBaseUrl;
  const turnstileKey = config.public.turnstileKey;

  const alternates = locales.value.map((lang) => ({
    rel: 'alternate',
    hreflang: lang.code,
    href: `${host}/${lang.code}${route.path.replace(`/${locale.value}`, '')}`,
  }));

  useHead({
    link: [{ rel: 'canonical', href: `${host}${route.path}` }, ...alternates],
  });

  useSeoMeta({
    title: t(`head.contact.title`),
    description: t(`head.contact.description`),
    ogTitle: t(`head.contact.title`),
    ogDescription: t(`head.contact.description`),
    ogImage: `${host}/static/icons/og.png`,
    ogImageWidth: 1200,
    ogImageHeight: 630,
    ogUrl: `${host}${route.path}`,
    twitterTitle: t(`head.contact.title`),
    twitterDescription: t(`head.contact.description`),
    twitterImage: `${host}/static/icons/og.png`,
    twitterCard: 'summary',
  });

  let widgetId: string | null = null;

  onMounted(() => {
    widgetId = turnstile.render('#turnstile-container', {
      sitekey: turnstileKey,
      theme: 'dark',
      language: locale.value,
    });
  });

  onBeforeUnmount(() => {
    if (widgetId) turnstile.remove(widgetId);
  });

  const schema = z.object({
    name: z.string().nonempty(t('contact.form.required')),
    email: z.email(t('contact.form.invalid_email')),
    subject: z.string().nonempty(t('contact.form.required')),
    message: z.string().nonempty(t('contact.form.required')),
  });

  type Schema = z.output<typeof schema>;
  const state = reactive<Partial<Schema>>({
    name: isDevelopment ? t('contact.form.sample.name') : '',
    email: isDevelopment ? t('contact.form.sample.email') : '',
    subject: t('contact.form.sample.subject'),
    message: isDevelopment ? t('contact.form.sample.message') : '',
  });
  const loading = ref(false);

  const toast = useToast();
  async function onSubmit(_event: FormSubmitEvent<Schema>) {
    loading.value = true;
    try {
      const token = turnstile.getResponse(widgetId);
      const res = await fetch(`${apiBaseUrl}/contact`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: state.name,
          email: state.email,
          subject: state.subject,
          message: state.message,
          token,
          challenger: 'turnstile',
        }),
      });

      const data = await res.json();
      if (data.success) {
        state.name = undefined;
        state.email = undefined;
        state.subject = undefined;
        state.message = undefined;
      }

      toast.add({
        title: t(data.message || data.error),
        color: data.success ? 'success' : 'error',
      });
    } catch (error: unknown) {
      if (error instanceof Error) {
        toast.add({ title: t(error.message), color: 'error' });
      }
    } finally {
      loading.value = false;
    }
  }
</script>

<template>
  <UContainer class="pb-10" style="min-height: 60vh">
    <UForm :schema="schema" :state="state" class="space-y-4 max-w-180 m-auto" @submit="onSubmit">
      <UFormField :label="$t('contact.form.name')" name="name">
        <UInput v-model="state.name" :disabled="loading" size="xl" class="w-full" />
      </UFormField>

      <UFormField :label="$t('contact.form.email')" name="email">
        <UInput v-model="state.email" :disabled="loading" size="xl" class="w-full" />
      </UFormField>

      <UFormField :label="$t('contact.form.subject')" name="subject">
        <UInput v-model="state.subject" :disabled="loading" size="xl" class="w-full" />
      </UFormField>

      <UFormField :label="$t('contact.form.message')" name="message">
        <UTextarea
          v-model="state.message"
          :disabled="loading"
          size="xl"
          :rows="10"
          :maxrows="15"
          autoresize
          class="w-full"
        />
      </UFormField>

      <div id="turnstile-container" />

      <UButton :disabled="loading" type="submit" class="py-2">
        {{ loading ? $t('contact.form.submitting') : $t('contact.form.submit') }}
      </UButton>
    </UForm>
  </UContainer>
</template>
