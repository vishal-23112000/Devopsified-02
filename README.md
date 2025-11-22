# Simple DevOps CI/CD Project (Node.js -> Docker -> Kubernetes)

This is a minimal example project to demonstrate a CI/CD pipeline that builds a Docker image,
pushes it to a container registry, and deploys to a Kubernetes cluster.

**What's included**
- Node.js Express app (index.js)
- Dockerfile
- Kubernetes manifests (k8s/)
- GitHub Actions workflow (.github/workflows/ci-cd.yaml)
- README with usage notes

**How to use**
1. Set up container registry credentials in GitHub Secrets:
   - `DOCKER_USERNAME`
   - `DOCKER_PASSWORD`
   - `IMAGE_NAME` (e.g. yourusername/simple-devops-cicd)
   - `KUBE_CONFIG` (base64-encoded kubeconfig for `kubectl` access)
2. Push to GitHub. The workflow will build, push, and deploy.
3. Alternatively build locally:
   ```bash
   docker build -t yourname/simple-devops-cicd:latest .
   docker run -p 3000:3000 yourname/simple-devops-cicd:latest
   ```
4. Apply k8s manifests:
   ```bash
   kubectl apply -f k8s/
   ```
