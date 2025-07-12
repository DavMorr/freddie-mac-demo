# ⚛️ React Frontend Container for Freddie Mac OpenRisk Navigator
# Vite development server with hot module reloading
# Architecture: Volume-mounted source code + containerized Node.js

FROM node:18-alpine

# Set working directory
WORKDIR /app

# Use existing node user (already has UID/GID 1000)
# No need to create new user - node:18-alpine comes with node user

# Install curl for health checks
RUN apk add --no-cache curl

# Copy package files for dependency installation  
# Note: We'll copy from the context during build, volume mount overrides at runtime
COPY --chown=node:node package*.json ./

# Install dependencies (including dev dependencies for development)
RUN npm ci && \
    npm cache clean --force

# Set up volume mount point for node_modules
# This allows for better performance on volume-mounted code
RUN mkdir -p /app/node_modules && \
    chown -R node:node /app

# Set environment variables for Vite
ENV NODE_ENV=production
ENV VITE_HOST=0.0.0.0
ENV VITE_PORT=3000

# Expose Vite dev server port
EXPOSE 3000

# Switch to non-root user
USER node

# Health check for Vite dev server
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000 || exit 1

# Start Vite development server
# Note: This will use volume-mounted source code
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3000"]