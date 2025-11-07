# Collaboration Service Dockerfile - multi-stage
FROM node:18.20.1-alpine AS builder
WORKDIR /app

# Copy package manifests (will copy package-lock.json if present)
COPY package*.json ./

# Install dependencies: use npm ci when lockfile exists, else npm install
RUN if [ -f package-lock.json ]; then npm ci --prefer-offline --no-audit --no-fund; else npm install --no-audit --no-fund; fi

# Copy source and build
COPY . .
RUN npm run build

### Runtime image
FROM node:18.20.1-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy package manifests and install only production deps
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev --prefer-offline --no-audit --no-fund; else npm install --omit=dev --no-audit --no-fund; fi

# Copy built artifacts
COPY --from=builder /app/dist ./dist

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 4010
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4010/health', (res) => process.exit(res.statusCode === 200 ? 0 : 1))"
CMD ["node", "dist/server.js"]
