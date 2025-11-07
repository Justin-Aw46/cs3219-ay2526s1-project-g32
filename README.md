[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/QUdQy4ix)
# CS3219 Project (PeerPrep) - AY2526S1
## Group: Gxx

### Note: 
- You are required to develop individual microservices within separate folders within this repository.
- The teaching team should be given access to the repositories as we may require viewing the history of the repository in case of any disputes or disagreements.

## Getting Started with Docker

This project uses Docker for containerization. Each microservice runs in its own container following the "one service = one container" principle.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (macOS/Windows) or Docker Engine (Linux)
- Docker Compose (included with Docker Desktop)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cs3219-ay2526s1-project-g32
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env and fill in your Supabase credentials and other required values
   ```

3. **Start all services**
   ```bash
   # Development mode with hot-reload
   docker compose up --build
   
   # Or run in background (detached mode)
   docker compose up --build -d
   ```

4. **Access the application**
   - Frontend: http://localhost:3000
   - User Service: http://localhost:4001
   - Question Service: http://localhost:4003
   - Matching Service: http://localhost:3002
   - Collaboration Service: http://localhost:4010
   - RabbitMQ Management: http://localhost:15672 (guest/guest)

### Useful Commands

```bash
# Stop all services
docker compose down

# Stop and remove volumes (cleans up data)
docker compose down -v

# View logs
docker compose logs -f

# View logs for a specific service
docker compose logs -f frontend

# Rebuild a specific service
docker compose build user

# Validate Docker setup
./validate-docker.sh
```

### Troubleshooting

See [CONTAINERISATION.md](./CONTAINERISATION.md) for detailed Docker documentation and troubleshooting guide.

If you encounter "docker: command not found", ensure Docker Desktop is installed and running. See the containerisation documentation for platform-specific installation instructions.

### CI/CD

This repository includes GitHub Actions workflows that automatically:
- Build all Docker images on push to main/develop branches
- Test that images build successfully
- Validate docker-compose.yml configuration 
