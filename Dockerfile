# ---- Base Stage ----
# Tam sürümü belirtelim
FROM node:18.20.8-alpine AS base
WORKDIR /app

# ---- Dependencies Stage ----
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

# ---- Build Stage ----
FROM base AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ---- Production Stage ----
FROM base AS production
ENV NODE_ENV=production
COPY --from=build /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules
COPY package.json .

EXPOSE 4321
CMD ["node", "dist/server/entry.mjs"]