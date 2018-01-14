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

DocsExtractor := Object clone do(
	init := method(
		self folder := Directory clone
		self outFile := File clone
	)

	setPath := method(path,
		folder setPath(path) createSubdirectory("docs")
		outFile setPath(Path with(path, "docs/docs.txt"))
	)

	clean := method(
		outFile remove
	)

	extract := method(
		outFile remove open
		sourceFiles foreach(file,
			file docSlices foreach(d,
                docString := removeIndentInDocString(d)
				outFile write("doc ", docString, "\n------\n")
			)
			
			file metadocSlices foreach(d,
                docString := removeIndentInDocString(d)
				outFile write("metadoc ", docString, "\n------\n")
			)
		)
		outFile close
	)

	sourceFiles := method(cFiles appendSeq(ioFiles))

	cFiles := method(
		if(folder directoryNamed("source") exists,
			folder directoryNamed("source") recursiveFilesOfTypes(list("c", "m"))
		,
			list()
		)
	)
	
	ioFiles := method(
		if(folder directoryNamed("io") exists, folder directoryNamed("io") recursiveFilesOfTypes(list("io", "docio")), list())
	)

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

