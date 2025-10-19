# Define variables
$REPO_URL = "asia-south1-docker.pkg.dev/project-5cd4ac48-f231-4722-ae1/docker-repo"
$BACKEND_IMAGE = "backend"
$FRONTEND_IMAGE = "frontend"
$TAG = "latest"

# Build and push backend
Write-Host "Building backend image..."
docker build -t "$REPO_URL/${BACKEND_IMAGE}:$TAG" ./services/backend
Write-Host "Pushing backend image..."
docker push "$REPO_URL/${BACKEND_IMAGE}:$TAG"

# Build and push frontend
Write-Host "Building frontend image..."
docker build -t "$REPO_URL/${FRONTEND_IMAGE}:$TAG" ./services/frontend
Write-Host "Pushing frontend image..."
docker push "$REPO_URL/${FRONTEND_IMAGE}:$TAG"

Write-Host "Script finished."
