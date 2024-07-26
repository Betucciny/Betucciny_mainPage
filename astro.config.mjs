import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import tailwind from "@astrojs/tailwind";
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import playformCompress from "@playform/compress";
import icon from "astro-icon";

import node from "@astrojs/node";


export default defineConfig({
  site: 'https://www.betucciny.com',
  style: {
    scss: {
      includePaths: ['./src/styles']
    }
  },
  integrations: [mdx(), icon(), sitemap(), tailwind(), playformCompress()],
  markdown: {
    shikiConfig: {
      themes: {
        light: 'github-light',
        dark: 'github-dark'
      }
    },
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex]
  },
  output: "server",
  adapter: node({
    mode: "standalone"
  })
});