// @ts-check
import { defineConfig } from 'astro/config';

import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
  adapter: node({
    mode: 'standalone',
    host: '0.0.0.0', // Açıkça tüm arayüzleri dinlemesini söyleyelim
    port: 4321 // Portu da burada belirtelim (Dockerfile EXPOSE ile aynı)
  })
});