# Use official MySQL image as base
FROM mysql:8.0

# Install python3 using the distro's package manager (microdnf / yum / dnf)
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

# Copy the start script into the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Use the start script as CMD. The base image's ENTRYPOINT will run initialization first.
CMD ["/start.sh"]
