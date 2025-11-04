# Use MySQL base image
FROM mysql:8.0

# Install Python (optional helper)
RUN apt-get update && apt-get install -y python3 && apt-get clean

# Create a custom writable data directory
RUN mkdir -p /data/mysql && chown -R mysql:mysql /data/mysql

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variables
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=university_transport
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin123

# Expose MySQL port
EXPOSE 3306

# Run startup script
CMD ["/start.sh"]
