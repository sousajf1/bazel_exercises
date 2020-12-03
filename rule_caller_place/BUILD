load("//external_rule:external.bzl", "external_rule")

external_rule(
    name = "rule_a",
    deps = [],
    visibility = ["//visibility:public"],
)

external_rule(
    name = "rule_b",
    deps = [
        ":rule_a",
    ],
    visibility = ["//visibility:public"],
)

external_rule(
    name = "rule_c",
    deps = [
        ":rule_b",
    ],
    visibility = ["//visibility:public"],
)

external_rule(
    name = "rule_d",
    deps = [
        ":rule_c",
    ],
    visibility = ["//visibility:public"],
)

external_rule(
    name = "rule_e",
    deps = [
        ":rule_d",
    ],
    visibility = ["//visibility:public"],
)