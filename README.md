# __Bazel Workshop__

## __What is Bazel__

Bazel is a tool to build and run software. Like Ant, Gradle, Maven, CMake...etc

## __Why Bazel__

For our concern, because bmw uses it. Right now there are more than 500,000 lines of [bazel](https://bazel.build/) code in the [ddad](https://cc-github.bmwgroup.net/swh/ddad) repository.

## __Setup environment__

Some tools are needed for building bazel projects, as well as defining that we are using Python 3
as our default Python version.

### __Install OS tools needed for project (Ubuntu LTS 20.04)__

```bash
$: sudo apt install zip python-is-python3 build-essential
```

### __Installing [bazelisk](https://github.com/bazelbuild/bazelisk/releases)__

Bazelisk is a launcher for bazel. It chooses the appropriate version for you.

```bash
$: mkdir $HOME/.bin
$: wget https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 -O $HOME/.bin/bazel
$: chmod +x $HOME/.bin/bazel
$: echo 'export PATH=$PATH:$HOME/.bin' >> $HOME/.bashrc
$: source $HOME/.bashrc
$: bazel --version # Outside any workspace, will download the latest version
```

### __Installing [VisualCode](https://code.visualstudio.com/download)__

Visual code has lots of pluguins(including one for bazel).
It's very handy if you have a big project with several languages

```bash
$: wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb
$: sudo apt install ./code.deb
```

### __Getting [buildifier](https://github.com/bazelbuild/buildtools/releases)__

```bash
$: wget https://github.com/bazelbuild/buildtools/releases/download/3.5.0/buildifier -O $HOME/.bin/buildifier
$: chmod +x $HOME/.bin/buildifier
```

### __Getting [tab-completion](https://docs.bazel.build/versions/master/completion.html#bash)__

```bash
$: git clone https://github.com/bazelbuild/bazel.git && cd bazel
$: bazel build //scripts:bazel-complete.bash  #In case of error do: ln -sf /usr/bin/python3 $HOME/.bin/python
$: sudo cp bazel-bin/scripts/bazel-complete.bash /etc/bash_completion.d/
$: source bazel-bin/scripts/bazel-complete.bash
```

## __Building software with bazel__

### __Configuring the bazel_workshop project__

We need to define some variables for bazel on `.bazelrc`, `.bazelversion` and `WORKSPACE` files.

```bash
$$: mkdir bazelisk_test && cd bazelisk_test
$: touch WORKSPACE # Bazel need this file to indicate this is the root of a workspace
$: echo 2.2.0 > .bazelversion
$: bazel --version
$: ls $HOME/.cache/bazelisk/downloads/bazelbuild/ #Where bazelisk keeps the versions: git clone git@cc-github.bmwgroup.net:rafaelsouza/bazel_workshop.git && cd bazel_workshop
$: echo 'startup --output_base="BAZEL_OUTPUT_BASE"' > .bazelrc # Configure bazel output folder to be the folder output_base inside the project root
$: echo 'startup --output_user_root="BAZEL_USER_ROOT"' >> .bazelrc
$: echo 'common --repository_cache="BAZEL_REPOSITORY_CACHE"' >> .bazelrc
$: echo 'workspace(name = "bazel_workshop")' > WORKSPACE # Set the name of the project
$: echo 2.2.0 > .bazelversion # Enforce bazelisk to use version 2.2.0
```

### __Projects configuration__

In order to try and of the following projects you need to copy their already existing folders
from the `bazel_exercises` folder to your working `bazelisk_test` folder.

i.e. while inside `bazel_exercises`:
```bash
$: cp -R ../bazel_exercises/hello_py .
```

### __Building the java 'Hello World'__

Installing jdk needed as a dependency:

```bash
$: sudo apt install default-jdk
```

Creating the target on hello_java/BUILD to build the java 'Hello World':

```python
load("@rules_java//java:defs.bzl", "java_binary")

java_binary( # java_binary is the rule
    name = "hello", # hello is the target
    srcs = [
        "src/hello.java",
    ],
)
```

Building the target by calling bazel build [label](https://docs.bazel.build/versions/master/skylark/lib/Label.html):

```bash
$: bazel build //hello_java:hello #//hello_java:hello is the label used to call the target. It can be used in the command line, inside .bzl or BUILD files to reference the target. It can also be used in it's relative form :hello
$: ./bazel-bin/hello_java/hello
```

### __Building the python 'Hello World'__

Setting up python:

```bash
$: sudo apt install python3-pip python-is-python3
```

Creating hello_py/BUILD

```python
py_binary(
    name = "hello",
    srcs = [
        "src/hello.py",
    ],
)
```

Building the target:

```bash
$: bazel build //hello_py:hello
$: ./bazel-bin/hello_py/hello
```

--

### __EXERCISE: Build the cpp 'Hello World'__

--

### __Building the golang 'Hello World'__

Installing golang needed as a dependency:

```bash
$: sudo apt install golang
```

Installing golang rules by editing the WORKSPACE file. The instructions on how to install the rules_go are in the [official repository](https://github.com/bazelbuild/rules_go). Ther's also the bazel documentation about [http_archive](https://docs.bazel.build/versions/master/repo/http.html)

```python
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
```

Creating hello_go/BUILD

```python
load("@io_bazel_rules_go//go:def.bzl", "go_binary")

go_binary(
    name = "hello",
    srcs = [
        "src/hello.go",
    ],
)
```

Building the target:

```bash
$: bazel build //hello_go:hello
$: ./bazel-bin/hello_go/hello_/hello
```

--

### __EXERCISE: Build the rust 'Hello World'__

--

## __Visualizing the [dependency graph](https://blog.bazel.build/2015/06/17/visualize-your-build.html)__

Installing graphviz needed by the bazel query:

```bash
$: sudo apt install graphviz
```

Generating the dependency graph:

```bash
$: bazel query 'deps(//hello_cpp:hello)' --output graph > cpp_graph.in #Too complex
$: bazel query 'deps(//hello_cpp:hello)' --noimplicit_deps --output graph > simplified_cpp_graph.in
```

--

### __EXERCISE: Visualize the hello_rust dependency graph__

--

## __Building a more complex c++ project__

Create the file stack/BUILD:

```python
load("@rules_cc//cc:defs.bzl", "cc_binary")
cc_binary(
    name = "stack",
    srcs = glob(["src/*"]),
    deps = [ #List of dependencies of main target
        "//lib_rstack:librstack",
    ],
    #linkstatic = False,
)
```

Create the file lib_rstack/BUILD:

```python
load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "librstack",
    srcs = glob(["src/*"]),
    hdrs = glob(["hdr/*"]),
    includes = ["hdr/"],
    #visibility = ["//visibility:public"],
    visibility = ["//stack:__pkg__"], #Specify the visibility so //stack:main can include this target as a dependency
)
```

See [cc_rules](https://docs.bazel.build/versions/master/be/c-cpp.html) documentation for more details

Building and visualising the dependencies:

```bash
$: bazel build //lib_rstack:librstack
$: bazel clean
$: bazel build //stack:stack --subcommands #use --subcommands how bazel execute the actions
$: bazel query 'deps(//stack:stack)' --noimplicit_deps --output graph > stack.in
```

--

### __EXERCISE: Transform cstack class into a lib and re-generate de dependency graph for //stack:main__

--

## __Testing lib_rstack with gtest__

Installing getest locally:

```bash
$: sudo apt install libgtest-dev #Good to have because of visual code intellisense
```

Installing [gtest](https://github.com/google/googletest) targets by adding the it to the WORKSPACE file:

```bash
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "gtest",
    remote = "https://github.com/google/googletest.git",
    commit = "703bd9caab50b139428cea1aaff9974ebee5742e",
    shallow_since = "1570114335 -0400",
)
```

See [git_repository](https://docs.bazel.build/versions/master/repo/git.html) documentation for more information

Adding librstack_test target to lib_rstack/BUILD

```python
load("@rules_cc//cc:defs.bzl", "cc_library", "cc_test")
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
```

Running the test target:

```bash
$: bazel test //lib_rstack:librstack_test
$: cat ./bazel-testlogs/lib_rstack/librstack_test/test.log
```

--

### __EXERCISE: Test the cstack class__

--

## __Covering lib_rstack with gcov__

```bash
$: bazel coverage //lib_rstack:librstack_test --combined_report=lcov
$: echo 3.5.0 > .bazelversion # The minimum version that implements coverage is the 3.5.0
$: bazel coverage //lib_rstack:librstack_test --combined_report=lcov
$: sudo apt install lcov # Locally needed because of genhtml
$: genhtml bazel-testlogs/lib_rstack/librstack_test/coverage.dat -o coverage
$: firefox coverage/index.html
```

--

### __EXERCISE: Generate the reports for the cstack lib__

--

## __Using [select and configured](https://docs.bazel.build/versions/master/configurable-attributes.html) settings to configure the build__

There are two ways of configuring the build with custom flags, the legacy one
that uses the --define built-in flag and the new one that uses the concept
of Starlark [build settings](https://docs.bazel.build/versions/master/skylark/config.html#user-defined-build-settings)
The bazel documentation recommends using the new method but bmw still uses the legacy one.

Adding the config settings targets to the stack_multilang/BUILD file:

```python
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
```

Adding the target to build main_multilang to stack_multilang/BUILD file:

```python
load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "stack_multilang",
    srcs = [
        "src/main.cpp",
        "src/dict.h",
        "src/case.h",
        "src/case_lower.cpp",
    ] +
    select({
        ":en":["src/dict_en.cpp"],
        ":pt":["src/dict_pt.cpp"],
        ":de":["src/dict_de.cpp"],
        "//conditions:default":["src/dict_en.cpp"],
    }),
    deps = [
        "//stack:libcstack",
        "//lib_rstack:librstack",
    ],
    linkstatic = False,
)
```

Building the target with different configurations:

```bash
$: bazel build //stack_multilang:stack_multilang
$: bazel build //stack_multilang:stack_multilang --define lang=de
```

Adding configs to .bazelrc:

```none
build:lang_en --define lang=en
build:lang_pt --define lang=pt
build:lang_de --define lang=de
```

Building using the new configurations created:

```bash
$: bazel build //stack_multilang:stack_multilang --config lang_pt
```

--

### __EXERCISE: Create a custom flag to output the message "r.pop() =" in upper case or in lower case__

--

## __Writing a 'Hello World' rule__

Creating the [bzl](https://docs.bazel.build/versions/master/skylark/rules-tutorial.html) file demo_rules/rules.bzl:

```python
def _hello_world_impl(ctx):
    hw_file = ctx.actions.declare_file("hello_world.txt")
    ctx.actions.write( #There are many actions available for use (e.g declare_file, run, run_shell). See https://docs.bazel.build/versions/master/skylark/lib/actions.html for more details.
        output = hw_file,
        content = "Hello World!\n",
    )
    return DefaultInfo(files = depset([hw_file])) # DefaultInfo is a provider. Providers are used to transmit informations between dependencies during the build proccess. Here, if the file is not returned through the DefaultInfo provider bazel will understand that no file will be generated, so it will not create the respective action. See https://docs.bazel.build/versions/master/skylark/rules.html#providers for more details.

hello_world = rule(
    implementation = _hello_world_impl,
)
```

Creating a target that uses your new rule in the file rule_caller_place/BUILD:

```python
load("//demo_rules:rules.bzl", "hello_world")

hello_world(
    name = "hello_world",
)
```

Building the target:

```bash
$: touch demo_rules/BUILD # Remember that in bazel every package needs to have a BUILD file, even if the file is empty
$: bazel build //rule_caller_place:hello_world
$: cat bazel-bin/rule_caller_place/hello_world.txt
```

## __[Evaluation model](https://docs.bazel.build/versions/master/skylark/concepts.html#evaluation-model) demo__

Creating the rule to demonstrate how bazel evaluates the files and builds the action graph

```python
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
```

Creating a target that uses your new rule in the file rule_caller_place/BUILD:

```python
print("Loading phase-2")
load("//demo_rules:rules.bzl", "hello_world", "evaluation_model_demo")

evaluation_model_demo(
    name = "ev_demo",
)
print("Loading phase-3")
```

Running the rule:

```bash
$: bazel build //rule_caller_place:ev_demo
DEBUG: /home/rafael/bazel_workshop/demo_rules/rules.bzl:5:6: Loading phase-0
DEBUG: /home/rafael/bazel_workshop/demo_rules/rules.bzl:78:6: Loading phase-1
DEBUG: /home/rafael/bazel_workshop/rule_caller_place/BUILD:8:6: Loading phase-2
DEBUG: /home/rafael/bazel_workshop/rule_caller_place/BUILD:124:6: Loading phase-3
DEBUG: /home/rafael/bazel_workshop/demo_rules/rules.bzl:20:10: Analysis phase-0
DEBUG: /home/rafael/bazel_workshop/demo_rules/rules.bzl:29:10: Analysis phase-1
INFO: Analyzed target //rule_caller_place:ev_demo (4 packages loaded, 6 targets configured).
INFO: Found 1 target...
INFO: From Action rule_caller_place/ev_demo.out:
EXECUTION PHASE-0
EXECUTION PHASE-1
```

Repair that the build doesn't follow an order that we are used in a normal programming language. First bazel evaluates what files in the loading phase and assembles the targets graph(the one we saw with the command bazel query), then in the analysis phase bazel traverses the target graph and assembles the action graph, finally in the execution phase bazel traverses the action graph executing the actions and generating the outputs.

The actions can be queried in the same manner as the targets:

```bash
$: bazel aquery 'deps(//stack:stack)' --noimplicit_deps --output text > actions_stack.txt
```

## __Creating a rule to output the size in bytes of a generated artifact__

Creating the rule in the file demo_rules/rules.bzl:

```python
def _exe_size_impl(ctx):
    out_file = ctx.actions.declare_file("exe_size.out")
    exe_file = ctx.attr.target[DefaultInfo].files.to_list()[0] #The DefaultInfo provider contains the files field, that is a depset, which contains all the generated files(the files that will be generated later when the actions were executed). The depset has a function to_list() which gives you access to the list of files. The depset can be understand as the edge which connects the actions in the action graph. See https://docs.bazel.build/versions/master/skylark/lib/depset.html for more details.
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "ls -sh $1 > $2\n",
        inputs = ctx.attr.target[DefaultInfo].files,
        arguments = [exe_file.path, out_file.path]
    )
    return DefaultInfo(files = depset([out_file]))

exe_size = rule(
    implementation = _exe_size_impl,
    attrs = { #Here we can define the rule attributes
        "target": attr.label(), #The target attribute is of type label (e.g //stack:stack) and the this rule will measure the the size of the artifact generated by this target.
    },
)
```

Adding the target to file stack/BUILD:

```bash
load("//demo_rules:rules.bzl", "exe_size")
exe_size(
    name = "stack_exe_size",
    target = ":stack",
)
```

Calling the target:

```bash
$: bazel build //stack:stack_exe_size
cat ./bazel-bin/stack/exe_size.out
```

--

### __EXERCISE: Create a new rule that accepts more than one target__

--

## __Demonstrating how to use [aspects](https://docs.bazel.build/versions/master/skylark/aspects.html)__

There's already a rule called external_rule in external_rule/external.bzl. This rule simply prints what are its dependencies to an output file:

```bash
$: bazel build //rule_caller_place:rule_e
$: cat bazel-bin/rule_caller_place_rule_e.out
rule_e deps = rule_d
```

Imagine you don't have access to the external_rule code or you can't modify it. The goal of this aspect is also to slightly modify the external_rule behavior and to write the text of the output files in upper case.

Creating the bzl file demo_aspects/aspects.bzl:

```python
AspectInfo = provider("Provider used by the upper aspect", #This is a provider, just like DefaultInfo
    fields = {
        "files": "transitive files from the dependencies",
    }
)

def _upper_aspect_impl(target, ctx):
    ex_file = ctx.actions.declare_file("{}_upper.out".format(ctx.label.name))
    msg_deps = ""
    transitive_files = [dep[AspectInfo].files for dep in ctx.rule.attr.deps] #This collects all the files generated by the dependencies. Every target has to retroactively collect these files so they are included in the actions graph.
    for dep in ctx.rule.attr.deps:
        msg_deps += dep.label.name + " "
    msg = "{} deps = {}\n".format(ctx.label.name, msg_deps)
    ctx.actions.write(
        output = ex_file,
        content = msg.upper(),
    )
    return AspectInfo(files = depset([ex_file], transitive = transitive_files))

upper_aspect = aspect(
    implementation = _upper_aspect_impl,
    attr_aspects = ["deps"], #This aspect will run on every target that has the attribute 'deps'
)

def _upper_rule_impl(ctx):
    return DefaultInfo(files = ctx.attr.target[AspectInfo].files) #Simply returns all generated aspect files so bazel can include the actions in the actions graph

upper_rule = rule( #It's not possible to call an aspect directly so we need to create a rule to warp it.
    implementation = _upper_rule_impl,
    attrs = {
        "target": attr.label(aspects = [upper_aspect]), #Links the target to our aspect
    }
)
```

Adding the target to rule_caller_place/BUILD:

```python
load("//demo_aspects:aspects.bzl", "upper_rule")

upper_rule(
    name = "upper",
    target = ":rule_e",
)
```

Calling the target:

```bash
$: touch demo_aspects/BUILD
$: bazel build //rule_caller_place:upper
$: cat bazel-bin/rule_caller_place/rule_e_upper.out
RULE_E DEPS = RULE_D
```

--

### __EXERCISE: Make upper rule return also the files rule_x.out in addition to the rule_x_upper.out already being returned__

--

## __Implementing an aspect get the size of dependency libs__

Adding the aspect to demo_aspects/aspects.bzl:

```python
#This time we'll not create a warper rule because we'll use an existing one
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
```

Modifying the rule exe_size_list to link the targets attributes to our aspect:

```python
load("//demo_aspects:aspects.bzl", "objs_size_aspect", "AspectInfo")
def _exe_size_list_impl(ctx):
    out_file = ctx.actions.declare_file("exe_size_list.out")
    exe_files = []
    aspect_outs = []
    for target in ctx.attr.targets:
        exe_files.append(target[DefaultInfo].files.to_list()[0])
        aspect_outs.append(target[AspectInfo].files)
    ctx.actions.run_shell(
        outputs = [out_file],
        command = "out_file=$1\n\
                   shift\n\
                   ls -sh $* > $out_file\n",
        inputs = exe_files,
        arguments = [out_file.path] + [e.path for e in exe_files],
    )
    return DefaultInfo(files = depset([out_file], transitive = aspect_outs))

exe_size_list = rule(
    implementation = _exe_size_list_impl,
    attrs = {
        "targets": attr.label_list(aspects = [objs_size_aspect]),
    },
)
```

Calling the target:

```bash
$: bazel build //rule_caller_place:exe_size_list
$: cat bazel-bin/lib_rstack/librstack_objs_sizes.out
4.0K bazel-out/k8-fastbuild/bin/lib_rstack/liblibrstack.a
4.0K bazel-out/k8-fastbuild/bin/lib_rstack/liblibrstack.so
```

## __[Macros](https://docs.bazel.build/versions/master/skylark/macros.html)__

Macro is a function called from BUILD files to instantiate rules. It is used when the code creating the rule is too extense or repetitive.

For exemple, the external_rules instantiations in rule_caller_place/BUILD:

```python
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
```

Can be replaced by this:

```python
load("//external_rule:external.bzl", 
    "external_rule", 
    "external_rule_builder"
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
```

If we create the macro external_rule_builder in external_rule/external.bzl:

```python
def external_rule_builder(name, rules):
    for rule in rules:
        external_rule(
            name = name + "_" + rule[0],
            deps = [":" + name + "_" + dep for dep in rule[1]],
            visibility = ["//visibility:public"],
        )
```

Calling the equivalent rules:

```bash
$: bazel build //rule_caller_place:builder_e
```

Then we can expand the macros to see what's gonig on in the BUILD file:

```bash
$: bazel query --output=build //rule_caller_place:all
```

## __Action Listener(NOT READY)__

stack/BUILD:

```python
py_binary(
    name = "tool_py",
    srcs = [
        "tool_py.py",
    ],
)

action_listener(
    name = "ac_teste",
    extra_actions = [":ae_teste"],
    mnemonics = [
        "CppCompile",
    ],
    visibility = ["//visibility:public"],
)

extra_action(
    name = "ae_teste",
    cmd = "$(location :tool_py) $(EXTRA_ACTION_FILE)" +
          " $(output $(ACTION_ID)_compile_command)",
    out_templates = [
        "$(ACTION_ID)_compile_command",
    ],
    tools = [
        ":tool_py",
    ],
)

```

stack/tool_py.py:

```python

import sys


def main(argv):
    print(f"INPUT FILE = {argv[1]} # I DON'T KNOW WHAT'S IN THIS FILE")
    print(f"OUTPUT FILE = {argv[2]}")
    print("# SEE https://docs.bazel.build/versions/master/be/extra-actions.html FOR INFORMATION ON EXTRA ACTION RULES")
    print("# SEE https://developers.google.com/protocol-buffers FOR INFORMATION ON PROTOL BUFFER")
    print("# SEE https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/extra_actions_base.proto FOR INFORMATION ON THE INPUT FILE")
    with open(argv[2], 'w') as f:
        f.write(f"INPUT FILE = {argv[1]} # I DON'T KNOW WHAT'S IN THIS FILE")
        f.write(f"OUTPUT FILE = {argv[2]}")


if __name__ == '__main__':
    sys.exit(main(sys.argv))

```

```bash
$: bazel build //stack:main  --experimental_action_listener=//stack:ac_teste
```

SEE https://docs.bazel.build/versions/master/be/extra-actions.html FOR INFORMATION ON EXTRA ACTION RULES
SEE https://developers.google.com/protocol-buffers FOR INFORMATION ON PROTOL BUFFER
SEE https://github.com/bazelbuild/bazel/blob/master/src/main/protobuf/extra_actions_base.proto FOR INFORMATION ON THE INPUT FILE
