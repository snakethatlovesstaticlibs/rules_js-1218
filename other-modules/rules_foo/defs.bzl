def _thing_impl(ctx):
    # openapi_ts_cli = ctx.executable._npm_cli
    python_generator = ctx.executable._python_generator
    types_dir = ctx.actions.declare_directory(ctx.attr.name + "_types")

    # Run Python script to generate all outputs
    ctx.actions.run(
        outputs = [types_dir],
        inputs = [],
        executable = python_generator,
        # tools = [openapi_ts_cli],
        env = {
            # Required for js_binary from aspect_rules_js
            # See: https://github.com/aspect-build/rules_js/tree/21ca6e2198a4c222389c58093bedb11dd950f4ec?tab=readme-ov-file#running-nodejs-programs
            # See: https://github.com/bazelbuild/bazel/issues/15470
            # Use ctx.bin_dir.path and pass spec as relative path to avoid duplication
            "BAZEL_BINDIR": ctx.bin_dir.path,
            # Python script configuration
            # "OPENAPI_TS_BIN": openapi_ts_cli.path,
            "TYPES_OUT_DIR": types_dir.path,
        },
    )

    return [
        DefaultInfo(files = depset([types_dir])),
    ]


thing_codegen = rule(
    implementation = _thing_impl,
    attrs = {
        # "_npm_cli": attr.label(
        #     default = "//:openapi_typescript_cli",
        #     executable = True,
        #     cfg = "exec",
        #     doc = "openapi-typescript CLI tool from npm",
        # ),
        "_python_generator": attr.label(
            default = "//:build_file_script",
            executable = True,
            cfg = "exec",
            doc = "Python script for generating TypeScript client code",
        ),
    },
    doc = "Generate TypeScript API client code from OpenAPI spec using openapi-typescript",
)
