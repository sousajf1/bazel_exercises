"""
"""

AspectInfo = provider("Provider used by the upper aspect",
    fields = {
        "files": "transitive files from the dependencies",
    }
)

def _upper_aspect_impl(target, ctx):
    ex_file = ctx.actions.declare_file("{}_upper.out".format(ctx.label.name))
    msg_deps = ""
    transitive_files = [
        dep[AspectInfo].files for dep in ctx.rule.attr.deps
    ]
    transitive_files += [
        dep[DefaultInfo].files for dep in ctx.rule.attr.deps
    ]
    for dep in ctx.rule.attr.deps:
        msg_deps += dep.label.name + " "
    msg = "{} deps = {}\n".format(ctx.label.name, msg_deps)
    ctx.actions.write(
        output = ex_file,
        content = msg.upper(),
    )
    return AspectInfo(
        files = depset([ex_file] + target.files.to_list(),
        transitive = transitive_files
        )
    )

upper_aspect = aspect(
    implementation = _upper_aspect_impl,
    attr_aspects = ["deps"],
)

def _upper_rule_impl(ctx):
    return DefaultInfo(files = ctx.attr.target[AspectInfo].files)

upper_rule = rule(
    implementation = _upper_rule_impl,
    attrs = {
        "target": attr.label(aspects = [upper_aspect]),
    }
)

def _objs_size_aspect_impl(target, ctx):
    out_file = ctx.actions.declare_file("{}_objs_sizes.out".format(ctx.label.name))
    transitive = [dep[AspectInfo].files for dep in ctx.rule.attr.deps]
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "out_file=$1\n\
                   shift\n\
                   ls -sh $* > $out_file\n",
        inputs = target.files,
        arguments = [out_file.path] + [f.path for f in target.files.to_list()],
    )
    return AspectInfo(files = depset([out_file], transitive = transitive))

objs_size_aspect = aspect(
    implementation = _objs_size_aspect_impl,
    attr_aspects = ["deps"],
)