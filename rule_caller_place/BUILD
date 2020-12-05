load("//external_rule:external.bzl", 
    "external_rule", 
    "external_rule_builder"
)
load("//demo_rules:rules.bzl",
    "hello_world", 
    "evaluation_model_demo",
    "exe_size_list"
)
load("//demo_aspects:aspects.bzl", "upper_rule")

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

external_rule_builder(
    name = "builder",
    rules = [
        ("a", []),
        ("b", ["a"]),
        ("c", ["a", "b"]),
        ("d", ["a", "b", "c"]),
        ("e", ["a", "b", "c", "d"]),
    ],
)

hello_world(
    name = "hello_world",
)

print("Loading phase-2")

evaluation_model_demo(
    name = "ev_demo",
)
print("Loading phase-3")

exe_size_list(
    name = "exe_list_size",
    targets = [
        "//stack:stack",
        "//stack_multilang:stack_multilang",
    ]
)

upper_rule(
    name = "upper",
    target = ":rule_e",
)