# 🌐 Nginx for Drupal Backend Application
# Serves Drupal CMS with proper document root

FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Create nginx user with proper permissions
RUN addgroup -g 1000 nginx_group && \
    adduser -u 1000 -G nginx_group -s /bin/sh -D nginx_user

# Copy Drupal-specific nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Create necessary directories
RUN mkdir -p /var/log/nginx /var/cache/nginx

# Set proper permissions
RUN chown -R nginx_user:nginx_group /var/log/nginx && \
    chown -R nginx_user:nginx_group /var/cache/nginx && \
    chown -R nginx_user:nginx_group /etc/nginx

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Expose HTTP port
EXPOSE 80

# Switch to non-root user
USER nginx_user

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
