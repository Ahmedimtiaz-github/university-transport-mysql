# 🚌 University Transport MySQL

A **Dockerized MySQL 8.0 database** for the University Transport Management chatbot project. This container automatically initializes a `transport_management` database by downloading and importing a SQL dump from a GitHub Gist, and includes a lightweight HTTP health-check server for cloud deployment platforms like [Render](https://render.com).

---

## 📁 Project Structure

```
university-transport-mysql/
├── .dockerignore          # Files excluded from Docker build context
├── Dockerfile             # Docker image definition (MySQL 8.0 + Python 3)
├── docker-compose.yml     # Docker Compose service configuration
├── start.sh               # Entrypoint script: DB init, SQL import & health server
└── README.md              # Project documentation
```

---

## ✨ Features

- **MySQL 8.0** — Industry-standard relational database.
- **Auto-initialization** — If no existing data is found, the database is initialized automatically.
- **SQL dump import** — On first run, downloads and imports the `transport_management` schema and data from a GitHub Gist.
- **Idempotent imports** — A marker file prevents re-importing on subsequent container restarts.
- **HTTP health check** — A Python 3 HTTP server runs on port `8080` (configurable via the `PORT` environment variable), ideal for platforms that require an HTTP health endpoint.
- **Docker Compose ready** — Spin up the entire service with a single command.

---

## 🚀 Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (v20+ recommended)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2+ recommended)

### 1. Clone the Repository

```bash
git clone https://github.com/Ahmedimtiaz-github/university-transport-mysql.git
cd university-transport-mysql
```

### 2. Start the Container

```bash
docker compose up -d --build
```

This will:
1. Build the Docker image from the `Dockerfile`.
2. Start a MySQL 8.0 server on port **3306**.
3. Initialize the database (if starting fresh).
4. Download and import the `transport_management` SQL dump.
5. Start an HTTP health-check server on port **8080**.

### 3. Verify the Database

```bash
docker exec -it transport_mysql mysql -u chatbot -pchatbotpass transport_db
```

Or connect using any MySQL client with:

| Parameter | Value          |
|-----------|----------------|
| Host      | `localhost`    |
| Port      | `3306`         |
| User      | `chatbot`      |
| Password  | `chatbotpass`  |
| Database  | `transport_db` |

### 4. Stop the Container

```bash
docker compose down
```

To also remove the persisted data volume:

```bash
docker compose down -v
```

---

## ⚙️ Configuration

### Environment Variables

The following environment variables are set in `docker-compose.yml` and can be customized:

| Variable               | Default        | Description                        |
|------------------------|----------------|------------------------------------|
| `MYSQL_ROOT_PASSWORD`  | `rootpassword` | Root user password                 |
| `MYSQL_DATABASE`       | `transport_db` | Default database created on init   |
| `MYSQL_USER`           | `chatbot`      | Application-level database user    |
| `MYSQL_PASSWORD`       | `chatbotpass`  | Password for the application user  |
| `PORT`                 | `8080`         | HTTP health-check server port      |

### Exposed Ports

| Port   | Purpose                      |
|--------|------------------------------|
| `3306` | MySQL database connections   |
| `8080` | HTTP health-check endpoint   |

### Data Persistence

Database files are persisted via a Docker volume (`mysql_data`) mapped to `/var/lib/mysql`. This ensures data survives container restarts.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│              Docker Container               │
│                                             │
│  ┌───────────────┐   ┌──────────────────┐   │
│  │  MySQL 8.0    │   │  Python HTTP     │   │
│  │  (port 3306)  │   │  Health Server   │   │
│  │               │   │  (port 8080)     │   │
│  └───────────────┘   └──────────────────┘   │
│           │                                 │
│     /data/mysql/                            │
│  (auto-initialized + SQL dump imported)     │
└─────────────────────────────────────────────┘
```

The `start.sh` entrypoint script orchestrates the following on container startup:

1. Creates and sets ownership of `/data/mysql`.
2. Runs `mysqld --initialize-insecure` if no data directory exists.
3. Starts `mysqld` in the background.
4. Waits up to 60 seconds for MySQL to accept connections.
5. Downloads the SQL dump from a GitHub Gist and imports it into `transport_management` (only on the first run).
6. Launches a Python HTTP server for health checks.
7. Waits on the `mysqld` process to keep the container alive.

---

## ☁️ Deploying to Render

This project is designed to work out of the box on [Render](https://render.com):

1. Create a new **Web Service** on Render.
2. Connect this GitHub repository.
3. Render will detect the `Dockerfile` and build automatically.
4. Set the **Health Check Path** to `/` on port `8080`.
5. The service will be ready once MySQL initializes and the SQL dump is imported.

---

## 🛠️ Tech Stack

| Technology     | Version / Details            |
|----------------|------------------------------|
| MySQL          | 8.0                          |
| Docker         | Multi-stage build            |
| Python 3       | HTTP health-check server     |
| Shell (Bash)   | Entrypoint / init scripting  |

---

## 📄 License

This project is open source and available for educational and personal use.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.