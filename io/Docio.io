# Eerie

//metadoc Docio category API
Docio := Object clone do(

    //doc Docio categories `DocsParser docsMap` sorted by categories.
    categories   := Map clone
    
    //doc Docio packagePath 
    packagePath  ::= nil
    
    /*doc Docio outputPath 
    Path to the `docs` in the destination package's directory.*/
    outputPath   := method(packagePath .. "/docs")
    
    //doc Docio packageInfo Returns package.json as an instance of Map.
    packageInfo  := nil
    
    //doc Docio packageName 
    packageName  := nil
    
    //doc Docio templatePath
    templatePath ::= nil
    
    getDocioPackage := method(
        # Eerie Env named("_base") packageNamed("Docio")
        File thisSourceFile parentDirectory parentDirectory
    )

    /*doc Docio generateDocs 
    Generates documentation for the package at `packagePath`.*/
    generateDocs := method(
        self packagePath isNil ifTrue(Exception raise("Package path is nil"))
        Directory with(self outputPath) createIfAbsent
        parsePackageJSON
        copyTemplate(Directory with(templatePath))
        extractDocs
        DocsParser parse
        generateCategories
        writeDocsToJson
        generateSite
    )

    parsePackageJSON := method(
        packageJson := getDestinationPackageJSON()
        packageInfo = packageJson contents parseJson
        packageName = packageInfo at("name")

        if(packageName == nil,
          Exception raise("The \"name\" field of the package.json is nil.")
        )
    )

    getDestinationPackageJSON := method(
        packageJson := File with(packagePath .. "/package.json")
        if(packageJson exists,
            packageJson open
            return packageJson
            ,
            Exception raise("Error: package.json didn't found")
        )
    )

    //doc Docio copyTemplate(templateDir)
    copyTemplate := method(templateDir,
        // switch to template directory
        currentDirectoryPath := Directory currentWorkingDirectory
        Directory setCurrentWorkingDirectory(templateDir path)
        // copy files
        Directory walk(item, 
            if(item type == "Directory",
                createDirectoryInDestination(item),
                copyFileToDestination(item)
            )
        )
        // switch back to current directory
        Directory setCurrentWorkingDirectory(currentDirectoryPath)
    )

    createDirectoryInDestination := method(directory,
        directoryPath := outputPath .. "/" .. directory path afterSeq("./")
        Directory with(directoryPath) createIfAbsent
    )

    copyFileToDestination := method(file,
            if(file path pathExtension != "DS_Store" 
                and file name != "main_template.html" 
                and file name != "prototype_template.html" 
                and file path pathExtension != "io",
                destinationPath := outputPath .. "/" .. file path afterSeq("./")
                file copyToPath(destinationPath)
              )
            )

    //doc Docio extractDocs Generates `docs.txt` using [DocsExtractor](docsextractor.html).
    extractDocs := method(
        docsExtractor := DocsExtractor clone
        docsExtractor setPath(packagePath)
        docsExtractor extract
    )

    generateCategories := method(
        categoriesNames := Docio DocsParser docsMap values map(at("category")) ?unique
        if(categoriesNames size > 0,
            sortDocsByCategoriesWithNames(categoriesNames)
            ,
            categories = Map with("API", Docio DocsParser docsMap)
        )
    )

    sortDocsByCategoriesWithNames := method(categoriesNames,
        categoriesNames foreach(name,
            category := Docio DocsParser docsMap select(n, value, value at("category") == name)
            if (name,
                categories atPut(name asMutable removePrefix("<p>") removeSuffix("</p>"), category)
            ,
                categories atPut("nil" asMutable removePrefix("<p>") removeSuffix("</p>"), category)
            )
        )
    )

    writeDocsToJson := method(
        if(DocsParser docsMap size < 1, return)
        docsJson := File with(outputPath .. "/data.js") create
        docsJson open
        docsJson setContents("data = JSON.stringify(" .. DocsParser docsMap asJson .. ");")
        docsJson close
    )

    //doc Docio generateSite Use this only after you did parsing.
    generateSite := method(
        PageGenerator init
        PageGenerator generateSite
    )

    /*doc Docio printDocFor(query)
    Prints documentation for the given `query`.

    The method will try to extract the documentation from the `doc` comments, 
    if the `docs/docs.txt` doesn't exist in the package's directory.

    Examples of query:
    ```
    "ProtoName"
    "ProtoName slotName"
    "AddonName ProtoName slotName"
    ```
    */
    printDocFor := method(query,
        queryList := getListForQuery(query)
        addonName := queryList at(0)

        if(AddonLoader hasAddonNamed(addonName),
            prepareDocsForPackageNamed(addonName)
            result := getDocStringForQueryList(queryList)
            printDocsString(result)
            ,
            Exception raise("Can't find a package with name " .. addonName)
        )
    )

    getListForQuery := method(query,
        queryList := query asMutable splitNoEmpties
        if(queryList isEmpty, 
            Exception raise("Can't process query: " .. query)
        )
        return queryList
    )

    prepareDocsForPackageNamed := method(name,
        addon := AddonLoader addonFor(name)
        self setPackagePath(addon addonPath)
        
        exception := try(
            self getDocsTxt
            DocsParser parse
        )
        exception catch (
            self setTemplatePath(self getDocioPackage path .. "/template")
            self generateDocs
            DocsParser parse
        )
    )

    //doc Docio getDocsTxt
    getDocsTxt := method(
        docsTxt := File with(Path with(packagePath, "/docs/docs.txt"))
        docsTxt exists ifFalse(
            Exception raise("#{packagePath}/docs/docs.txt not found" interpolate)
        )

        return docsTxt
    )

    getDocStringForQueryList := method(queryList,
        //TODO: refactor
        docString := ""
        (queryList size == 1) ifTrue(
            docString := DocsParser docsMap at(queryList at(0)) ?at("description")
        )
        (queryList size == 2) ifTrue(
            protoName := queryList at(0)
            slotsMap := DocsParser docsMap at(protoName) ?at("slots")
            slotKey := getSlotKeyInMapForQuery(slotsMap, queryList at(1))
            docString := protoName .. " " .. slotKey .. "\n" .. slotsMap ?at(slotKey)
        )
        (queryList size == 3) ifTrue(
            protoName := queryList at(1)
            slotsMap := DocsParser docsMap at(protoName) ?at("slots")
            slotKey := getSlotKeyInMapForQuery(slotsMap, queryList at(2))
            docString := protoName .. " " .. slotKey .. "\n" .. slotsMap ?at(slotKey)
        )
        (queryList size > 3) ifTrue(
            Exception raise("Wrong query: " .. (queryList join(" ")))
        )
        return docString
    )

    getSlotKeyInMapForQuery := method(map, query,
        slotKey := map ?keys ?detect(asMutable strip containsSeq(query))
        if(slotKey not or map not, 
            Exception raise("Can't find slot named " .. query)
            ,
            slotKey
        )
    )

    printDocsString := method(docString,
        if(docString not or docString isEmpty, 
            "Documentation didn't found." println
            ,
            docString println
        )
    )

    //doc Docio openDocsForPackageWithName(packageName)
    openDocsForPackageWithName := method(packageName,
        if(AddonLoader hasAddonNamed(packageName),
            prepareDocsForPackageNamed(packageName)
            ,
            Exception raise("Can't find a package with name " .. packageName)
        )

        docsHomePage := File with(self packagePath .. "/docs/index.html")
        if(docsHomePage exists,
            OpenUrl open(docsHomePage path)
            ,
            Exception raise(docsHomePage path .. " doesn't exist.")
        )
    )

)

OpenUrl := Object clone

OpenUrl open := method(url,
    (System platform == "Darwin") ifTrue(
        self _openDarwin
    )
    ((System platform containsAnyCaseSeq("windows")) or(System platform containsAnyCaseSeq("mingw"))) ifTrue(
        self _openWin(url)
    ) ifFalse(
        self _openLinux(url)
    )
)

OpenUrl _openDarwin := method(url,
    System system("open #{url}" interpolate)
)

OpenUrl _openWin := method(url,
    System system("start \"\"" .. " " .. url)
)

OpenUrl _openLinux := method(url,
    System system("""URL=#{url}; xdg-open $URL \
    || sensible-browser $URL \
    || x-www-browser $URL \
    || gnome-open $URL""" interpolate)
)

Docio clone := Docio do(
    //doc Docio DocsParser [DocsParser](docsparser.html)
    doRelativeFile("Docio/DocsParser.io")
    doRelativeFile("Docio/CLI.io")
    doRelativeFile("Docio/DocsExtractor.io")
    //doc Docio PageGenerator [PageGenerator](pagegenerator.html)
    doRelativeFile("Docio/PageGenerator.io")
)
