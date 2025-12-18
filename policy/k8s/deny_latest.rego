package main

import rego.v1

# Block :latest
deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  endswith(c.image, ":latest")
  msg := sprintf("K8s: image must not use :latest (container=%s image=%s)", [c.name, c.image])
}

# Require an explicit tag (demo-app:1.0.0)
deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not re_match("^(.+/)?[^/]+:[^/]+$", c.image)
  msg := sprintf("K8s: image must include an explicit tag (example demo-app:1.0.0). Got: %s", [c.image])
}
