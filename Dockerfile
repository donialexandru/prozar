ARG NODE_VERSION=26
ARG ALPINE_VERSION=3.23

# ---------- Base ----------
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION} AS base
WORKDIR /app

# ---------- Production dependencies ----------
FROM base AS deps
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
  npm ci --omit=dev

# ---------- Runtime ----------
FROM base AS runtime

ENV NODE_ENV=production \
  PORT=3000

# tini: proper PID 1, forwards signals & reaps zombie processes
RUN apk add --no-cache tini

# App files owned by root = read-only for the runtime user (more secure)
COPY --from=deps /app/node_modules ./node_modules
COPY . .

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/health || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "app.js"]
