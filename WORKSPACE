workspace(name = "bazel_workshop")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "207fad3e6689135c5d8713e5a17ba9d1290238f47b9ba545b63d9303406209c6",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.7/rules_go-v0.24.7.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.24.7/rules_go-v0.24.7.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

http_archive(
    name = "io_bazel_rules_rust",
    sha256 = "5cb2fbcc3debebc7b68f5f66c1b7ef741bdcca87c70594de688d4518538c36c8",
    strip_prefix = "rules_rust-aa7c6938cf1cc2973bc065c7532f89874bf09818",
    urls = [
        "https://github.com/bazelbuild/rules_rust/archive/aa7c6938cf1cc2973bc065c7532f89874bf09818.tar.gz",
    ],
)

load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")

rust_repositories()

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "gtest",
    remote = "https://github.com/google/googletest.git",
    commit = "703bd9caab50b139428cea1aaff9974ebee5742e",
    shallow_since = "1570114335 -0400",
)