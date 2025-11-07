# Containerisation (one service = one container)

This repository now includes a recommended containerisation layout where each microservice is packaged into its own Docker image and runs in its own container. The services covered:

- `frontend` (Next.js)
- `collaboration_service`
- `user_service`
- `matching_service`
- `question_service`

Supporting infrastructure defined in `docker-compose.yml`:
- `redis` (Redis)
- `rabbitmq` (RabbitMQ with management UI)

Quick start (development)

1. Copy `.env.example` to `.env` and fill in required values (do NOT commit `.env`).

2. Start containers with hot-reload (development override present):

```bash
docker-compose up --build
```

The `docker-compose.override.yml` mounts local source into the containers and runs the `dev` scripts in each service so changes are reflected immediately.

Quick start (production-style)

1. Build images and run containers (production build inside images):

```bash
docker-compose up --build -d
```

2. Access services:
- Frontend: http://localhost:3000
- Collaboration: http://localhost:4010
- Matching: http://localhost:3002
- User API: http://localhost:4001
- Question API: http://localhost:4003
- RabbitMQ management: http://localhost:15672 (guest/guest)

Notes
- Dockerfiles are lockfile-aware: they run `npm ci` when a `package-lock.json` is present, otherwise they fall back to `npm install`.
- For production readiness: pin Node versions, run as non-root, add HEALTHCHECKs, and use a registry + CI pipeline.
- For developer convenience: the override file mounts source and uses named volumes for `node_modules` to avoid clobbering installed modules.
- All services now include HEALTHCHECK instructions for better container monitoring

Troubleshooting Docker Issues

If you encounter "docker: command not found" errors:

1. **Install Docker Desktop**:
   - macOS: https://docs.docker.com/desktop/install/mac-install/
   - Windows: https://docs.docker.com/desktop/install/windows-install/
   - Linux: https://docs.docker.com/engine/install/

2. **Verify Docker is in your PATH**:
   ```bash
   # Check if Docker is installed
   docker --version
   
   # Check if Docker daemon is running
   docker info
   ```

3. **Docker Desktop must be running**:
   - Open Docker Desktop application
   - Wait for it to fully start (whale icon should be steady)
   - Try your docker commands again

4. **Using docker compose (v2) instead of docker-compose (v1)**:
   ```bash
   # Modern syntax (Docker Compose v2)
   docker compose up
   
   # Legacy syntax (Docker Compose v1)
   docker-compose up
   ```

5. **Validate Docker setup**:
   ```bash
   # Run the validation script
   ./validate-docker.sh
   ```

CI/CD Integration

This repository includes GitHub Actions workflows that:
- Build all Docker images on push to main/develop branches
- Test that images can be built successfully
- Validate docker-compose.yml configuration
- Cache Docker layers for faster builds

The workflow file is located at `.github/workflows/docker-build.yml`

If you want, I can:
- Add GitHub Actions workflow that builds images and optionally pushes them to a registry. ✅ DONE
- Add HEALTHCHECK entries and pin Node versions in Dockerfiles. ✅ DONE
- Run and verify a smoke test locally (requires Docker on your machine and a filled `.env`).
