<script setup lang="ts">
  import type { DropdownMenuItem } from '@nuxt/ui';

  const { t, locale, locales } = useI18n();
  const config = useRuntimeConfig();
  const route = useRoute();
  const host = config.public.websiteHost;
  const staticHost = config.public.staticHost;

  const alternates = locales.value.map((lang) => ({
    rel: 'alternate',
    hreflang: lang.code,
    href: `${host}/${lang.code}${route.path.replace(`/${locale.value}`, '')}`,
  }));

  useHead({
    htmlAttrs: {
      lang: locale.value,
    },
    link: [{ rel: 'canonical', href: `${host}${route.path}` }, ...alternates],
  });

  useSeoMeta({
    title: t(`head.resume.title`),
    description: t(`head.resume.description`),
    ogTitle: t(`head.resume.title`),
    ogDescription: t(`head.resume.description`),
    ogImage: `${host}/static/icons/og-resume-${locale.value}.png`,
    ogImageWidth: 1000,
    ogImageHeight: 667,
    ogUrl: `${host}${route.path}`,
    twitterTitle: t(`head.resume.title`),
    twitterDescription: t(`head.resume.description`),
    twitterImage: `${host}/static/icons/og-resume-${locale.value}.png`,
    twitterCard: 'summary_large_image',
  });

  onMounted(() => {
    fetch(`${staticHost}/afonso-de-mori-cv-${locale.value}.html`)
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text();
      })
      .then((html) => {
        document.querySelector<HTMLDivElement>('#page')!.innerHTML = html;
      })
      .catch(() => {})
      .finally(() => {
        const pageElement = document.querySelector<HTMLDivElement>('#page');
        document.querySelectorAll<HTMLAnchorElement>('#page a').forEach((a, index) => {
          if (index === 0) {
            const contact = `/${locale.value}/contact`;
            a.href = contact;
            a.addEventListener('click', (e) => {
              e.preventDefault();
              navigateTo(contact);
            });
          } else if (index !== 0 && index !== 3) a.setAttribute('target', '_blank');
        });

        const lastParagraph = pageElement?.querySelector('p:last-of-type') as HTMLParagraphElement | null;

        if (lastParagraph) {
          const emphasisElement = lastParagraph.querySelector<HTMLElement>('em');
          if (emphasisElement?.textContent) {
            emphasisElement.textContent = emphasisElement.textContent.split(' — ')[0]?.trim() || '';
          }
        }
      });
  });

  const createButtonItems = (localeKey: string) =>
    computed<DropdownMenuItem[][]>(() => [
      [
        {
          label: 'PDF',
          icon: 'mdi-file-pdf-outline',
          to: `${staticHost}/afonso-de-mori-cv-${t(`${localeKey}.locale`)}.pdf`,
          target: '_blank',
          kbds: ['.pdf'],
        },
        {
          label: 'Microsoft Word',
          icon: 'mdi-file-word-outline',
          to: `${staticHost}/afonso-de-mori-cv-${t(`${localeKey}.locale`)}.docx`,
          target: '_blank',
          kbds: ['.docx'],
        },
        {
          label: 'Markdown',
          icon: 'mdi-file-text-outline',
          to: `${staticHost}/afonso-de-mori-cv-${t(`${localeKey}.locale`)}.md`,
          target: '_blank',
          kbds: ['.md'],
        },
        {
          label: t(`${localeKey}.formats.txt`),
          icon: 'mdi-file-text-outline',
          to: `${staticHost}/afonso-de-mori-cv-${t(`${localeKey}.locale`)}.txt`,
          target: '_blank',
          kbds: ['.txt'],
        },
        {
          type: 'separator',
        },
        {
          label: t(`${localeKey}.formats.google.label`),
          icon: 'mdi-google-drive',
          to: `/${t(`${localeKey}.locale`)}/resume.gdocs`,
          target: '_blank',
        },
        {
          label: t(`${localeKey}.formats.linkedin`),
          icon: 'mdi-linkedin',
          to: `https://www.linkedin.com/in/afonsodemori/${t(`${localeKey}.locale`)}`,
          target: '_blank',
        },
      ],
    ]);

  const itemsFirstButton = createButtonItems('resume.first');
  const itemsSecondButton = createButtonItems('resume.second');
  const itemsThirdButton = createButtonItems('resume.third');
</script>

<template>
  <div class="containers">
    <div class="text-center pb-5 print:hidden">
      <UDropdownMenu arrow :items="itemsFirstButton" external-icon="false">
        <UButton
          class="p-3 m-1"
          :label="t('resume.first.label')"
          variant="subtle"
          trailing-icon="i-lucide-chevron-down"
        />
      </UDropdownMenu>
      <UDropdownMenu arrow :items="itemsSecondButton" external-icon="false">
        <UButton
          class="p-3 m-1"
          :label="t('resume.second.label')"
          color="neutral"
          variant="outline"
          trailing-icon="i-lucide-chevron-down"
        />
      </UDropdownMenu>
      <UDropdownMenu arrow :items="itemsThirdButton" external-icon="false">
        <UButton
          class="p-3 m-1"
          :label="t('resume.third.label')"
          color="neutral"
          variant="outline"
          trailing-icon="i-lucide-chevron-down"
        />
      </UDropdownMenu>
    </div>
    <!-- eslint-disable-next-line vue/no-v-html -->
    <div id="page" v-html="$t('resume.html')" />
  </div>
</template>

<style scoped>
  /* Page */
  #page {
    transition-duration: 200ms;
    border-radius: 1rem;
    max-width: 980px;
    margin: auto;
    padding: 3rem;
    font:
      inherit 1rem/1.6 Inter,
      sans-serif;
    color: #000;
    text-align: justify;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    background-color: rgba(255, 255, 255, 0.5);
  }

  .containers {
    transition-duration: 200ms;
    padding-left: 1rem;
    padding-right: 1rem;
  }

  /* Content formatting */
  :deep(a) {
    color: #155dfc;
    text-decoration: underline;
  }

  :deep(a:hover) {
    text-decoration: none;
  }

  :deep(h1) {
    font-size: 2rem;
    line-height: 1.2;
    font-weight: 700;
  }

  :deep(p:first-of-type) {
    margin-bottom: 1.5rem;
  }

  :deep(h2) {
    margin: 2rem 0 0.75rem 0;
    font-size: 1.3rem;
  }

  :deep(strong),
  :deep(h2 strong),
  :deep(h3 strong) {
    font-weight: 600;
  }

  :deep(ul) {
    margin: 1rem 0 2rem 2.5rem;
    list-style-type: disc;
  }

  :deep(em:last-of-type) {
    display: block;
    opacity: 0.5;
    margin-top: 5rem;
    text-align: right;
  }

  .dark #page {
    color: rgba(255, 255, 255, 0.8);
    background-color: rgba(0, 0, 0, 0.25);
    box-shadow: 0 0 1px 0 rgba(255, 255, 255, 0.75);
  }

  .dark #page :deep(a) {
    color: #51a2ff;
  }

  @media screen and (max-width: 800px) {
    #page {
      padding: 2rem 1rem;
    }

    .containers {
      padding: 0.25rem;
    }
  }

  @media screen and (max-width: 750px) {
    #page {
      margin: inherit 0;
      text-align: left;
    }

    .containers {
      padding: 0;
    }

    :deep(ul) {
      margin-left: 1.5rem;
      text-align: left;
    }
  }

  @media print {
    #page,
    .dark #page,
    .containers {
      max-width: 100%;
      width: 100%;
      box-shadow: none;
      margin: 0;
      padding: 0;
      background-color: white;
      color: #000;
    }

    :deep(h1) {
      font-size: 20pt;
    }

    :deep(h2) {
      margin-top: 1.5rem;
      margin-bottom: 0.25rem;
      font-size: 13pt;
    }

    :deep(h3) {
      font-size: 1.1rem;
    }

    :deep(ul) {
      margin-top: 0.5rem;
      margin-bottom: 1.5rem;
    }
  }
</style>
