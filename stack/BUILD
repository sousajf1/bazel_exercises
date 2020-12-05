load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")
load("//demo_rules:rules.bzl", "exe_size")

cc_library(
    name = "libcstack",
    srcs = glob(["lib_cstack/src/*"]),
    hdrs = glob(["lib_cstack/hdr/*"]),
    includes = ["lib_cstack/hdr/"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "stack",
    srcs = glob(["src/*"]),
    deps = [ #List of dependencies of main target
        ":libcstack",
        "//lib_rstack:librstack",
    ],
    visibility = ["//visibility:public"],
    #linkstatic = False,
)

cc_test(
    name = "libcstack_test",
    srcs = [
        "lib_cstack/test/test.cpp"
    ],
    deps = [
        ":libcstack",
        "@gtest//:gtest_main",
    ],
)

exe_size(
    name = "stack_exe_size",
    target = ":stack",
)