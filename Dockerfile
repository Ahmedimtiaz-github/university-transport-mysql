# Use MySQL base image
FROM mysql:8.0

# Install Python (for HTTP health check server)
RUN set -eux; \
    if command -v microdnf >/dev/null 2>&1; then \
        microdnf install -y python3; \
        microdnf clean all || true; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y python3; \
        yum clean all || true; \
    elif command -v dnf >/dev/null 2>&1; then \
        dnf install -y python3; \
        dnf clean all || true; \
    else \
        echo "No supported package manager found (microdnf/yum/dnf)"; exit 1; \
    fi; \
    rm -rf /var/cache/* /var/lib/apt/lists/* || true

# Create a custom writable data directory and set ownership
RUN mkdir -p /data/mysql && chown -R mysql:mysql /data/mysql

# Copy the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose MySQL port
EXPOSE 3306

# Expose HTTP port for health check (8080)
EXPOSE 8080

# Run the custom start script
CMD ["/start.sh"]
