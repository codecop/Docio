Eerie
Markdown
DocsExtractor

//metadoc Docio category API
//metadoc Docio description Main interface for Docio. 
Docio := Object clone do(
    prototypes   := Map clone
    modules      := Map clone
    categories   := Map clone
    //doc Docio packagePath Path of the package directory.
    packagePath  ::= nil
    outputPath   := method(packagePath .. "/docs")
    //doc Docio packageInfo Returns package.json as an instance of Map.
    packageInfo  := nil
    //doc Docio packageName Returns the name of the package as it's specified in the package.json.
    packageName  := nil
    templatePath ::= nil
    
    printDocFor := method(query,
        queryList := getListForQuery(query)
        queryMap := getQueryMapFromList(queryList)
        addonName := queryMap at("addonName")

        if(AddonLoader hasAddonNamed(addonName),
            addon := AddonLoader addonFor(addonName)
            setPackagePath(addon addonPath)
            docsTxt := File with(outputPath .. "/docs.txt")
            if(docsTxt exists,
                parseDocsTxtForQueryMap(docsTxt, queryMap)
                ,
                setTemplatePath(getDocioPackage path .. "/template")
                generateDocs
                parseDocsTxtForQueryMap(docsTxt, queryMap)
            )
        )
    )

    getListForQuery := method(query,
        queryList := query asMutable splitNoEmpties
        if(queryList isEmpty, 
            Exception raise("Can't process query: " .. query)
        )
        return queryList
    )

    getQueryMapFromList := method(queryList,
        addonName := queryList at(0)
        query := parseQueryListForQuery(queryList)
        return Map with("addonName", queryList at(0), "query", query)
    )

    parseQueryListForQuery := method(queryList,
        parsedQuery := ""
        if(queryList size == 1, 
            parsedQuery = queryList at(0)
            ,
            queryListCopy := list() appendSeq(queryList)
            queryListCopy removeFirst
            parsedQuery = queryListCopy join(" ")
        )
        return parsedQuery
    )

    parseDocsTxtForQueryMap := method(docsTxt, queryMap,
        docsTxt open
        docsTxt contents println
    )

    getDocioPackage := method(
        return Eerie activeEnv packageNamed("Docio")
    )


    //doc Docio generateDocs Generates documentation for the package at `packagePath`.
    generateDocs := method(
        parsePackageJSON()
        copyTemplate(Directory with(templatePath))
        parseDocs()
        PageGenerator init
        PageGenerator generateSite
    )

    parsePackageJSON := method(
        packageJson := getDestinationPackageJSON()
        packageInfo = Yajl parseJson(packageJson contents)
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
        if(file path pathExtension != "DS_Store" and file name != "main_template.html" and file name != "prototype_template.html" and file path pathExtension != "io",
            destinationPath := outputPath .. "/" .. file path afterSeq("./")
            file copyToPath(destinationPath)
        )
    )

    parseDocs := method(
        extractDocs()
        docsTxt := getDocsTxt()
        docsTxt contents split("------\n") foreach(entry, parseDocEntry(entry))
        generateCategories()
        writeDocsToJson()
    )

    extractDocs := method(
        docsExtractor := DocsExtractor clone
        docsExtractor setPath(packagePath)
        docsExtractor extract
    )

    getDocsTxt := method(
        docsTxt := File with(Path with(packagePath, "/docs/docs.txt"))
        docsTxt exists ifFalse(
            Exception raise("#{packagePath}/docs/docs.txt not found" interpolate)
        )

        return docsTxt
    )

    parseDocEntry := method(docEntry,
        header := docEntry beforeSeq("\n") afterSeq(" ") 
        if(header, parseDocHeader(header, docEntry))
    )

    parseDocHeader := method(header, docEntry,
        headerCopy := header asMutable strip asSymbol
        protoName := headerCopy beforeSeq(" ") ?asMutable ?strip ?asSymbol
        prototypes atIfAbsentPut(protoName, Map clone atPut("slots", Map clone))
        if(protoName == nil, writeln("ERROR: " .. headerCopy))
        parseDocSlot(headerCopy, docEntry, protoName)
    )

    parseDocSlot := method(header, docEntry, protoName,
        slotName := header afterSeq(" ") ?asMutable ?strip ?asSymbol
        if(slotName == nil, writeln("ERROR: " .. header))
        description := docEntry afterSeq("\n") markdownToHTML

        isSlot := docEntry beginsWithSeq("doc")
        if(isSlot, 
            prototypes at(protoName) at("slots") atPut(slotName, description)
            ,
            prototypes at(protoName) atPut(slotName, description)
        )
    )

    generateCategories := method(
        firstProto := nil
        firstProtoName := prototypes keys sort detect(k, prototypes at(k) at("category"))

        catNameMap := Map clone
        prototypes values select(at("category")) foreach(m, 
            count := catNameMap at(m at("category")) 
            if(count == nil, count = 0)
            catNameMap atPut(m at("category"), count + 1)
        )

        maxCount := 0
        catName := nil
        catNameMap foreach(name, count,
            if(count > maxCount, catName = name; maxCount = count)
        )

        if(catName == nil, catName = "Misc")
        categories atIfAbsentPut(catName asMutable strip, prototypes)
    )

    writeDocsToJson := method(
        if(prototypes size < 1, return)
        docsJson := File with(outputPath .. "/data.js") create
        docsJson open
        docsJson setContents("data = JSON.stringify(" .. prototypes asJson .. ");")
        docsJson close
    )
)

Docio clone := Docio do(
    doRelativeFile("CLI.io")
    doRelativeFile("PageGenerator.io")
)
