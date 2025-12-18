package main

import rego.v1

# Block :latest
deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  endswith(c.image, ":latest")
  msg := sprintf("K8s: image must not use :latest (container=%s image=%s)", [c.name, c.image])
}

# Require an explicit pin:
# - either a tag like demo-app:1.0.0
# - or a digest like demo-app@sha256:...
deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]

  not has_pin(c.image)

  msg := sprintf("K8s: image must be pinned to a tag or digest (example demo-app:1.0.0 or demo-app@sha256:...). Got: %s", [c.image])
}

has_pin(img) if {
  regex.match("^(.+/)?[^/]+:[^/]+$", img)  # has explicit tag
}

has_pin(img) if {
  contains(img, "@sha256:")                # has digest pin
}
