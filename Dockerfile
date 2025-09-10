# Dockerfile optimizado para evitar crashes por memoria
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar solo package files para aprovechar cache de Docker
COPY package*.json ./

# Instalar todas las dependencias (necesarias para build)
RUN npm ci && npm cache clean --force

# Copiar código fuente
COPY . .

# Build del proyecto
RUN npm run build

# Etapa de producción - reutilizar node_modules optimizados
FROM node:20-alpine AS production

WORKDIR /app

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Copiar node_modules ya instalados y hacer prune para producción
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Optimizar node_modules para producción (elimina devDependencies)
RUN npm prune --production && npm cache clean --force

# Copiar build compilado
COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist

# Cambiar al usuario no-root
USER nestjs

# Exponer puerto
EXPOSE 3000

# Comando optimizado
CMD ["node", "dist/main.js"]