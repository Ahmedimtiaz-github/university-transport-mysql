FROM mysql:8.0

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=transport_db
ENV MYSQL_USER=chatbot
ENV MYSQL_PASSWORD=chatbotpass

# Expose port
EXPOSE 3306
