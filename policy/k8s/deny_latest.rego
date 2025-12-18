package guardrail.k8s

import rego.v1

deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  endswith(c.image, ":latest")
  msg := sprintf("K8s: image must not use :latest (container=%s image=%s)", [c.name, c.image])
}

deny[msg] {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not contains(c.image, ":")
  msg := sprintf("K8s: image must be pinned to a tag (no implicit latest) (container=%s image=%s)", [c.name, c.image])
}
