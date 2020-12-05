"""
"""
load("//demo_aspects:aspects.bzl", "objs_size_aspect", "AspectInfo")

def _hello_world_rule(ctx):
    hw_file = ctx.actions.declare_file("hello_world.txt")
    ctx.actions.write(
        output = hw_file,
        content = "Hello World!\n",
    )
    return DefaultInfo(files = depset([hw_file]))



hello_world = rule(
    implementation = _hello_world_rule,
)

print("Loading phase-0")
def _evaluation_model_demo_impl(ctx):
    print("Analysis phase-0")
    out_file = ctx.actions.declare_file("ev_demo.out")
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "echo EXECUTION PHASE-0 \n \
                   echo _evaluation_model_demo_impl > $1\n \
                   echo EXECUTION PHASE-1 \n",
        arguments = [out_file.path]
    )
    print("Analysis phase-1")
    return DefaultInfo(files = depset([out_file]))

evaluation_model_demo = rule(
    implementation = _evaluation_model_demo_impl,
)
print("Loading phase-1")



def _exe_size_impl(ctx):
    out_file = ctx.actions.declare_file("exe_size.out")
    exe_file = ctx.attr.target[DefaultInfo].files.to_list()[0]
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "ls -sh $1 > $2\n",
        inputs = ctx.attr.target[DefaultInfo].files,
        arguments = [exe_file.path, out_file.path]
    )
    return DefaultInfo(files = depset([out_file]))

exe_size = rule(
    implementation = _exe_size_impl,
    attrs = {
        "target": attr.label(),
    },
)

def _exe_size_list_impl(ctx):
    out_file = ctx.actions.declare_file("exe_size_list.out")
    exe_files = [
            t[DefaultInfo].files.to_list()[0] for t in ctx.attr.targets
        ]
    transitive = [
            t[AspectInfo].files for t in ctx.attr.targets
        ]
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "\
            out_file=$1\n\
            shift\n\
            ls -sh $* > $out_file\n",
        inputs = exe_files,
        arguments = [out_file.path] + [f.path for f in exe_files]
    )
    return DefaultInfo(
        files = depset(
            [out_file],
            transitive = transitive,
        ),
    )

exe_size_list = rule(
    implementation = _exe_size_list_impl,
    attrs = {
        "targets": attr.label_list(aspects = [objs_size_aspect]),
    },
)