# ---- Base Stage ----
# Projemizle uyumlu Node.js sürümünü (18) kullanıyoruz
FROM node:18-alpine AS base
WORKDIR /app

# ---- Dependencies Stage ----
# Bağımlılıkları ayrı kuruyoruz
FROM base AS deps
COPY package.json package-lock.json* ./
# Sadece production bağımlılıklarını kuruyoruz
RUN npm ci --omit=dev

# ---- Build Stage ----
# Kodu kopyalayıp build ediyoruz
FROM base AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ---- Production Stage ----
# Final imajını oluşturuyoruz
FROM base AS production
ENV NODE_ENV=production
# Build sonucu oluşan dosyaları ve production bağımlılıklarını kopyalıyoruz
COPY --from=build /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules
COPY package.json .

# Astro Node adaptörü varsayılan olarak 4321 portunu kullanır
EXPOSE 4321

# Konteyner çalıştığında Node.js sunucusunu başlatıyoruz
CMD ["node", "dist/server/entry.mjs"]