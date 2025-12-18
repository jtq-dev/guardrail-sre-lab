up:
	cd observability && docker compose up --build -d

down:
	cd observability && docker compose down -v

policy:
	@echo "Running Conftest (K8s)..."
	conftest test infra/k8s --policy policy/k8s
	@echo "Running Conftest (Terraform)..."
	conftest test infra/terraform --policy policy/terraform

urls:
	@echo "Grafana:     http://localhost:3000  (admin/admin)"
	@echo "Prometheus:  http://localhost:9090"
	@echo "Loki:        http://localhost:3100"
	@echo "Demo App:    http://localhost:8000/hello  and /error"
