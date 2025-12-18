package main

import rego.v1

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.requests.cpu
  msg := sprintf("K8s: missing resources.requests.cpu (container=%s)", [c.name])
}

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.requests.memory
  msg := sprintf("K8s: missing resources.requests.memory (container=%s)", [c.name])
}

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.cpu
  msg := sprintf("K8s: missing resources.limits.cpu (container=%s)", [c.name])
}

deny contains msg if {
  input.kind == "Deployment"
  c := input.spec.template.spec.containers[_]
  not c.resources.limits.memory
  msg := sprintf("K8s: missing resources.limits.memory (container=%s)", [c.name])
}
