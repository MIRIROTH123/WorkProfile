# WorkProfile Advanced CI/CD Project

This repository contains the advanced WorkProfile project with a complete CI/CD pipeline, Docker Compose 3-tier stack, and testing via Killercoda.

---

## Repository Structure

- `.github/workflows/ci-cd-pipeline.yml` — GitHub Actions workflow.
- `docker-compose/docker-compose.yml` — Docker Compose 3-tier stack configuration.
- `docker-compose/nginx.conf` — Nginx configuration.
- `src/` — Application source code.
- `Dockerfile` — Docker image build instructions.
- `requirements.txt` — Python dependencies.
- `README.md` — Project documentation (this file).

---

## CI/CD Pipeline (GitHub Actions)

The workflow includes six stages:

1. **Validation**
   - Checks required files exist (Dockerfile, requirements.txt, app.py).
   - Validates Python dependencies (Flask, MySQL connector).

2. **Build & Single Container Test**
   - Builds Docker image.
   - Runs WorkProfile container.
   - Tests root and health endpoints using `curl`.
   - Pushes image to GitHub Container Registry.

3. **3-Tier Docker Compose Test**
   - Starts 3-tier stack: Nginx → WorkProfile → MySQL.
   - Waits for MySQL to be ready.
   - Tests endpoints through Nginx.
   - Tests database connectivity.
   - Shuts down stack after tests.

4. **Publish**
   - Pushes Docker image to registry with proper tags.

5. **Kubernetes Deployment Testing**
   - Manual testing in Killercoda (StatefulSet, NodePort, CRUD operations).

6. **Manual Deployment Instructions**
   - Detailed Killercoda deployment steps.
   - Verification procedures for StatefulSet and persistent storage.

---

## Docker Compose Setup

- **3-tier stack:**
  - Nginx as reverse proxy/load balancer (port 8081).
  - WorkProfile application (port 5000).
  - MySQL database with persistent volume.
- **Environment variables:**
  - `DB_HOST=mysql`
  - `DB_USER=flaskapp`
  - `DB_PASS=flaskapp`
  - `DB_NAME=exampleDb`
- MySQL data persists in volume `mysql-data`.
- Healthcheck ensures MySQL is ready before WorkProfile starts.

---

## Running Locally with Docker Compose

```bash
cd docker-compose
docker-compose up -d
sleep 60
curl http://localhost:8081/
curl http://localhost:8081/health
Shutdown:

bash
Copy
Edit
docker-compose down -v
Killercoda (Manual Kubernetes Testing)
MySQL StatefulSet runs with persistent storage.

WorkProfile application deployed and accessible via NodePort.

CRUD operations work correctly.

Data persists after pod restarts.

Screenshots & Documentation
Include screenshots and diagrams in your final submission:

GitHub Actions pipeline run success.

Application running in browser via Nginx.

Database CRUD operations working.

StatefulSet and PVC status in Killercoda.

Workflow diagram of all 6 stages.

Docker Compose 3-tier architecture diagram.

Reflection on simplified CI/CD testing experience.

Notes
GitHub Actions workflow does not deploy Kubernetes; manifests and deployment are tested manually in Killercoda.

CI/CD tests are simplified using curl.

Docker Compose network ensures proper communication between Nginx, WorkProfile, and MySQL.