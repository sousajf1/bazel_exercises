"""
"""
def _external_rule_impl(ctx):
    ex_file = ctx.actions.declare_file("{}.out".format(ctx.label.name))
    msg_deps = ""
    transitive_files = [dep[DefaultInfo].files for dep in ctx.attr.deps]
    for dep in ctx.attr.deps:
        msg_deps += dep.label.name + " "
    msg = "{} deps = {}\n".format(ctx.label.name, msg_deps)
    ctx.actions.write(
        output = ex_file,
        content = msg,
    )
    return DefaultInfo(files = depset([ex_file], transitive = transitive_files))

external_rule = rule(
    implementation = _external_rule_impl,
    attrs = {
        "deps": attr.label_list(),
    },
)

def external_rule_builder(name, rules):
    for rule in rules:
        external_rule(
            name = name + "_" + rule[0],
            deps = [":" + name + "_" + dep for dep in rule[1]],
            visibility = ["//visibility:public"],
        )