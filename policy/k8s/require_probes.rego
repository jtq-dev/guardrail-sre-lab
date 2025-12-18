package guardrail.k8s

import rego.v1

deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.livenessProbe
  msg := sprintf("K8s: missing livenessProbe (container=%s)", [c.name])
}

deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.readinessProbe
  msg := sprintf("K8s: missing readinessProbe (container=%s)", [c.name])
}
