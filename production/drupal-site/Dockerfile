# Clean Drupal 11 Container - PHP-FPM
FROM drupal:11-php8.3-fpm-alpine

# Install essential tools
RUN apk add --no-cache \
        git \
        curl \
        unzip \
        mysql-client \
        netcat-openbsd \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Drush globally
RUN composer global require drush/drush:^13 \
    && ln -s ~/.composer/vendor/bin/drush /usr/local/bin/drush

# Copy PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/zzz-custom.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Set working directory to align with base image
WORKDIR /opt/drupal

# Copy our Drupal application files (NOT vendor - we'll install fresh)
COPY --chown=www-data:www-data web/ /opt/drupal/web/
COPY --chown=www-data:www-data composer.json composer.lock /opt/drupal/

# Run composer install to ensure proper autoloader FOR THIS ENVIRONMENT
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Create necessary directories with proper permissions
RUN mkdir -p /opt/drupal/web/sites/default/files \
    && mkdir -p /opt/drupal/private \
    && cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php \
    && chmod 755 /opt/drupal/web/sites/default \
    && chmod 777 /opt/drupal/web/sites/default/files \
    && chmod 666 /opt/drupal/web/sites/default/settings.php \
    && chown -R www-data:www-data /opt/drupal

# Health check for PHP-FPM - DISABLED FOR DEBUGGING
# HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
#     CMD nc -z localhost 9000 || exit 1

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm", "-F"]
