package main

import rego.v1

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.livenessProbe
  msg := sprintf("K8s: missing livenessProbe (container=%s)", [c.name])
}

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.readinessProbe
  msg := sprintf("K8s: missing readinessProbe (container=%s)", [c.name])
}
