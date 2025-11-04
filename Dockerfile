# Use MySQL base image
FROM mysql:8.0

# Install Python (used for lightweight web server)
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

# Ensure MySQL data directory exists and has correct ownership
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Copy our startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Switch to mysql user (safer)
USER mysql

# Define environment variables (you can change passwords here if you want)
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=university_transport
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin123

# Expose MySQL port
EXPOSE 3306

# Switch back to root so exec works
USER root

# Run custom start script
CMD ["/start.sh"]
