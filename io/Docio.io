Eerie
Regex

//metadoc Docio category API
Docio := Object clone do(
    //doc Docio categories `DocsParser docsMap` sorted by categories.
    categories   := Map clone
    //doc Docio packagePath 
    packagePath  ::= nil
    //doc Docio outputPath
    outputPath   := method(packagePath .. "/docs")
    //doc Docio packageInfo Returns package.json as an instance of Map.
    packageInfo  := nil
    //doc Docio packageName 
    packageName  := nil
    //doc Docio templatePath
    templatePath ::= nil
    
    getDocioPackage := method(
        return Eerie activeEnv packageNamed("Docio")
    )

    //doc Docio generateDocs Generates documentation for the package at `packagePath`.
    generateDocs := method(
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
        if(file path pathExtension != "DS_Store" and file name != "main_template.html" and file name != "prototype_template.html" and file path pathExtension != "io",
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
        //TODO: refactor
        firstProto := nil
        firstProtoName := DocsParser docsMap keys sort detect(k, DocsParser docsMap at(k) at("category"))

        catNameMap := Map clone
        DocsParser docsMap values select(at("category")) foreach(m, 
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
        categories atIfAbsentPut(catName asMutable strip, DocsParser docsMap)
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
    Prints documentation for given query.
    The method will try to extract the documentation from `doc` comments, 
    if the `docs/docs.txt` wouldn't exist in the package's directory.

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
        setPackagePath(addon addonPath)
        exception := try(
            getDocsTxt
            DocsParser parse
        )
        exception catch (
            setTemplatePath(getDocioPackage path .. "/template")
            generateDocs
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
        regex := "\\b".. query .. "(?:(?:\\(.*\\))|\\b)"
        slotKey := map ?keys ?detect(matchesRegex(regex))
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
)

Docio clone := Docio do(
    //doc Docio Parser [DocsParser](docsparser.html)
    doRelativeFile("Docio/Parser.io")
    //doc Docio CLI [CLI](cli.html)
    doRelativeFile("Docio/CLI.io")
    //doc Docio DocsExtractor [DocsExtractor](docsextractor.html)
    doRelativeFile("Docio/DocsExtractor.io")
    //doc Docio PageGenerator [PageGenerator](pagegenerator.html)
    doRelativeFile("Docio/PageGenerator.io")
)
