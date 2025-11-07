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

If you want, I can:
- Add GitHub Actions workflow that builds images and optionally pushes them to a registry.
- Add HEALTHCHECK entries and pin Node versions in Dockerfiles.
- Run and verify a smoke test locally (requires Docker on your machine and a filled `.env`).
