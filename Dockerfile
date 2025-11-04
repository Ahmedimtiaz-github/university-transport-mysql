# Use official MySQL image as base
FROM mysql:8.0

# Install python3 so we can run a tiny HTTP health server
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

# Copy the start script into the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Keep the original entrypoint from the base image.
# When Docker runs, the base ENTRYPOINT (/usr/local/bin/docker-entrypoint.sh) will be executed
# with our CMD as the argument. The entrypoint will do initialization and then run our /start.sh.
CMD ["/start.sh"]
