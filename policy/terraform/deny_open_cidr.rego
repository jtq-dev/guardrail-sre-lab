package guardrail.terraform

import rego.v1

deny[msg] {
  cidr := walk_cidrs(input)[_]
  cidr == "0.0.0.0/0"
  msg := "Terraform: 0.0.0.0/0 is not allowed (public-to-world rule). Use a restricted CIDR."
}

walk_cidrs(x) := out {
  out := [v |
    some p, v
    walk(x, [p, v])
    is_string(v)
    contains(lower(p), "cidr")
  ]
}
