// This file is from Io's sources

File do(
	docSlicesFor := method(name,
		contents slicesBetween("//" .. name .. " ", "\n") map(strip) map(s,
			i := s findSeq(" ") + 1 // after doc
			i1 := s findSeq("(", i)  // (
			i2 := s findSeq(" ", i) // 
			if(i1 and i1 < i2, i2 := s findSeq(")", i))
			if(i2, s atInsertSeq(i2 + 1, "\n"))
			s
		) appendSeq(contents slicesBetween("/*" .. name .. " ", "*/"))		
	)

	docSlices := method(
		docSlicesFor("doc")
	)
	
	metadocSlices := method(
		docSlicesFor("metadoc")
	)
)

DocsExtractor := Object clone do (
	
    dir := Directory clone

    outFile := File clone

	setPath := method(path,
		self dir setPath(path) createSubdirectory("docs")
		self outFile setPath(Path with(path, "docs/docs.txt")))

	clean := method(self outFile remove)

	extract := method(
		self outFile remove open

		self files foreach(file,
			file docSlices foreach(d,
                docString := removeIndentInDocString(d)
				self outFile write("doc ", docString, "\n------\n"))
			
			file metadocSlices foreach(d,
                docString := removeIndentInDocString(d)
				self outFile write("metadoc ", docString, "\n------\n")))

		self outFile close)

	files := method(
        self cFiles appendSeq(self ioFiles) appendSeq(self docioFiles))

    cFiles := method(
        if (self dir directoryNamed("source") exists not, return list())
        self dir directoryNamed("source") recursiveFilesOfTypes(list("c", "m")))
	
	ioFiles := method(
		if (self dir directoryNamed("io") exists not, return list()) 
        self dir directoryNamed("io") \
            recursiveFilesOfTypes(list("io", "docio")), list())

    docioFiles := method(
        if (self dir directoryNamed("docio") exists not, return list()) 
        self dir directoryNamed("docio") \
            recursiveFilesOfTypes(list("docio")), list()))

    // it's important to understand, that the indent is the indent of the first
    // line after /*doc line, that is the second line in the string
    removeIndentInDocString := method(string,
        lines := string split("\n")
        firstDocLine := lines at(1)
        if(firstDocLine,
            indent := getIndentForString(firstDocLine)
            lines map(asMutable removePrefix(indent)) join("\n") strip
            ,
            string asMutable strip
        )
    )

    getIndentForString := method(string,
        string ?beforeSeq(string ?asMutable ?lstrip)
    )

)

