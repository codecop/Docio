CLI := Object clone do(
    run := method(
        checkNumberOfArguments()
        parseOptions()
        Docio generateDocs()
    )

    checkNumberOfArguments := method(
        if(System args size < 2,
            showUsage()
            System exit(1)
        )
    )

    showUsage := method(
        "Docio - documentation generator for Eerie packages.\nUsage:\n\tdocio package=package_dir [template=path_to_template]" println
    )

    parseOptions := method(
        options := System getOptions(System args)
        parseHelpOption(options)
        parsePackageOption(options)
        parseTemplateOption(options)
    )

    parseHelpOption := method(options,
        if(options hasKey("help"), showUsage(); System exit(0))
    )

    parsePackageOption := method(options,
        Docio setPackagePath(options at("package") ?stringByExpandingTilde)
        if(Docio packagePath == nil,
            showUsage()
            System exit(1)
        )
    )

    parseTemplateOption := method(options,
        Docio setTemplatePath(options at("template") ?stringByExpandingTilde)
        if(Docio templatePath == nil,
            Docio setTemplatePath(Docio getDocioPackage path .. "/template")
        )
    )
)
