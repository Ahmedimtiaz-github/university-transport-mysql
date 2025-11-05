# Use standard MySQL image
FROM mysql:8.0

# Install Python for HTTP health server (choose package manager available in base image)
RUN set -eux; \
    if command -v microdnf >/dev/null 2>&1; then \
        microdnf install -y python3; microdnf clean all || true; \
    elif command -v yum >/dev/null 2>&1; then \
        yum install -y python3; yum clean all || true; \
    elif command -v dnf >/dev/null 2>&1; then \
        dnf install -y python3; dnf clean all || true; \
    else \
        echo "No supported package manager found"; exit 1; \
    fi; \
    rm -rf /var/cache/* /var/lib/apt/lists/* || true

# Ensure a writable data dir that survives image build-time differences
RUN mkdir -p /data/mysql && chown -R mysql:mysql /data/mysql

# Copy startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose MySQL and a health HTTP port
EXPOSE 3306 8080

# Use the custom start script
CMD ["/start.sh"]