//metadoc PageGenerator category API
//metadoc PageGenerator description Generates documentation pages.
PageGenerator := Object clone do(
    mainTemplate         := nil
    prototypeTemplate    := nil
    templatePath         := method(Docio templatePath)
    outputPath           := method(Docio outputPath)
    currentPrototype     := nil
    currentPrototypeName := nil

    //doc PageGenerator init
    init := method(
        initMainPageTemplate()
        initPrototypePageTemplate()
    )

    initMainPageTemplate := method(
        mainTemplate = File with(templatePath .. "/main_template.html")
        mainTemplate exists ifFalse(
            Exception raise("main_template.html didn't found")
        )
        mainTemplate open
    )

    initPrototypePageTemplate := method(
        prototypeTemplate = File with(templatePath .. "/prototype_template.html")
        prototypeTemplate exists ifFalse(
            Exception raise("prototype_template.html didn't found")
        )
        prototypeTemplate open
    )

    generateSite := method(
        generateMainPage()
        generatePrototypesPages()
    )

    //doc PageGenerator generateMainPage Generates the index.html from the main_template.html.
    generateMainPage := method(
        mainPage := File with(outputPath .. "/index.html") remove open
        mainPage setContents(mainTemplate contents interpolate)
    )

    /*doc PageGenerator generatePrototypesPages 
    Generates a page for each of the prototype of the given map.
    This method creates a page for each object from the prototype_template.html.
    */
    generatePrototypesPages := method(
        Directory with(outputPath .. "/docs") createIfAbsent
        Docio prototypes foreach(key, value,
            currentPrototypeName = key
            currentPrototype = value

            prototypePage := File with(outputPath .. "/docs/#{currentPrototypeName asLowercase}.html" interpolate) remove open
            prototypePage setContents(prototypeTemplate contents interpolate) close
        )
    )
)

PageGenerator clone := PageGenerator
