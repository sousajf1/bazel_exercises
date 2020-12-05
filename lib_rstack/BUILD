load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")

cc_library(
    name = "librstack",
    srcs = glob(["src/*"]),
    hdrs = glob(["hdr/*"]),
    includes = ["hdr/"],
    deps = [
        "//stack:libcstack",
    ],
    visibility = ["//visibility:public"],
    #visibility = ["//stack:__pkg__"], #Specify the visibility so //stack:main can include this target as a dependency
)

cc_test(
    name = "librstack_test",
    srcs = [
        "test/test.cpp"
    ],
    deps = [
        ":librstack",
        "@gtest//:gtest_main",
    ],
)