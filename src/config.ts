import type { Site, Ui, Features } from './types'

export const SITE: Site = {
  website: 'https://astro-antfustyle-theme.vercel.app/',
  base: '/',
  title: '良颂',
  description:
    '良颂的个人网站，记录生活、学习、工作中的点滴。',
  author: '良颂',
  lang: 'en',
  ogLocale: 'en_US',
  imageDomains: ['cdn.bsky.app', 'images.unsplash.com'],
}

export const UI: Ui = {
  internalNavs: [
    {
      path: '/blog',
      title: '技术分享',
      displayMode: 'alwaysText',
      text: '学习笔记',
    },
    // {
    //   path: '/projects',
    //   title: 'Projects',
    //   displayMode: 'alwaysText',
    //   text: 'Projects',
    // },
    // {
    //   path: '/photos',
    //   title: 'Photos',
    //   displayMode: 'iconToTextOnMobile',
    //   text: 'Photos',
    //   icon: 'i-ri-camera-ai-line',
    // },
    // {
    //   path: '/shorts',
    //   title: 'Shorts',
    //   displayMode: 'iconToTextOnMobile',
    //   text: 'Shorts',
    //   icon: 'i-meteor-icons-grid',
    // },
    // {
    //   path: '/changelog',
    //   title: 'Changelog',
    //   displayMode: 'iconToTextOnMobile',
    //   text: 'Changelog',
    //   icon: 'i-ri-draft-line',
    // },
  ],
  socialLinks: [
    {
      link: 'https://github.com/github-xsong',
      title: 'Github 主页',
      displayMode: 'alwaysIcon',
      icon: 'i-uil-github-alt',
    },
  ],
  navBarLayout: {
    left: [],
    right: [
      'internalNavs',
      'hr',
      'socialLinks',
      'hr',
      'searchButton',
      'themeButton',
      'rssLink',
    ],
    mergeOnMobile: true,
  },
  tabbedLayoutTabs: [
    { title: 'Changelog', path: '/changelog' },
    { title: 'AstroBlog', path: '/feeds' },
    { title: 'AstroStreams', path: '/streams' },
  ],
  groupView: {
    maxGroupColumns: 3,
    showGroupItemColorOnHover: true,
  },
  // githubView: {
  //   monorepos: [
  //     'withastro/astro',
  //     'withastro/starlight',
  //     'lin-stephanie/astro-loaders',
  //   ],
  //   mainLogoOverrides: [
  //     [/starlight/, 'https://starlight.astro.build/favicon.svg'],
  //   ],
  //   subLogoMatches: [
  //     [/theme/, 'i-unjs-theme-colors'],
  //     [/github/, 'https://github.githubassets.com/favicons/favicon.svg'],
  //     [/tweet/, 'i-logos-twitter'],
  //     [/bluesky/, 'i-logos-bluesky'],
  //   ],
  // },
  externalLink: {
    newTab: false,
    cursorType: '',
    showNewTabIcon: false,
  },
  postMetaStyle: 'minimal',
}

/**
 * Configures whether to enable special features:
 *  - Set to `false` or `[false, {...}]` to disable the feature.
 *  - Set to `[true, {...}]` to enable and configure the feature.
 */
export const FEATURES: Features = {
  slideEnterAnim: [true, { enterStep: 60 }],
  ogImage: [
    true,
    {
      authorOrBrand: `${SITE.title}`,
      fallbackTitle: `${SITE.description}`,
      fallbackBgType: 'plum',
    },
  ],
  toc: [
    true,
    {
      minHeadingLevel: 2,
      maxHeadingLevel: 4,
      displayPosition: 'left',
      displayMode: 'content',
    },
  ],
  share: [
    false,
    {
      twitter: [true, '@ste7lin'],
      bluesky: [true, '@ste7lin.bsky.social'],
      mastodon: false,
      facebook: false,
      pinterest: false,
      reddit: false,
      telegram: false,
      whatsapp: false,
      email: true,
    },
  ],
  giscus: [
    false,
    {
      'data-repo': 'lin-stephanie/astro-antfustyle-theme',
      'data-repo-id': 'R_kgDOLylKbA',
      'data-category': 'Giscus',
      'data-category-id': 'DIC_kwDOLylKbM4Cpugn',
      'data-mapping': 'title',
      'data-strict': '0',
      'data-reactions-enabled': '1',
      'data-emit-metadata': '0',
      'data-input-position': 'bottom',
      'data-lang': 'en',
    },
  ],
}
