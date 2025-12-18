package main

import rego.v1

# Deny any Terraform config that contains 0.0.0.0/0 under any CIDR-ish field.
deny contains msg if {
  cidr := walk_cidrs(input)[_]
  cidr == "0.0.0.0/0"
  msg := "Terraform: 0.0.0.0/0 is not allowed (public-to-world rule). Use a restricted CIDR."
}

# Collect all string values that appear under paths containing "cidr" (e.g., cidr_blocks, cidr_block, ipv4_cidr_block)
walk_cidrs(x) := out if {
  out := [v |
    some path, v
    walk(x, [path, v])
    is_string(v)
    is_cidr_path(path)
  ]
}

is_cidr_path(path) if {
  parts := [lower(sprintf("%v", [p])) | p := path[_]]
  joined := concat(".", parts)
  contains(joined, "cidr")
}
