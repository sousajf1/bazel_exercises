load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "stack_multilang",
    srcs = [
        "src/main.cpp",
        "src/dict.h",
        "src/case.h",
    ] +
    select({
        ":en":["src/dict_en.cpp"],
        ":pt":["src/dict_pt.cpp"],
        ":de":["src/dict_de.cpp"],
        "//conditions:default":["src/dict_en.cpp"],
    }) +
    select({
        ":lower":["src/case_lower.cpp"],
        ":upper":["src/case_upper.cpp"],
        "//conditions:default":["src/case_lower.cpp"],
    }),
    deps = [
        "//stack:libcstack",
        "//lib_rstack:librstack",
    ],
    linkstatic = False,
    visibility = ["//visibility:public"],
)

config_setting(
    name = "en",
    define_values = {
        "lang": "en",
    },
)

config_setting(
    name = "pt",
    define_values = {
        "lang": "pt",
    },
)

config_setting(
    name = "de",
    define_values = {
        "lang": "de",
    },
)

config_setting(
    name = "lower",
    define_values = {
        "case": "lower",
    },
)

config_setting(
    name = "upper",
    define_values = {
        "case": "upper",
    },
)