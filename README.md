## What this project does (simple)
GuardRail is a “safety gate” for infrastructure config.

It prevents common production mistakes **before deployment**:
- ❌ Blocks Docker images using `:latest` (must pin a version)
- ✅ Requires health checks (liveness + readiness probes)
- ✅ Requires CPU/memory requests + limits (avoid outages)

### Quick demo
**Pass (production manifests):**
```bash
conftest test infra/k8s/manifests --policy policy/k8s
