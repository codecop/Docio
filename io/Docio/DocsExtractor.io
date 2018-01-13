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
                docString := removeWhitespacesAtLineBegginningsOfString(d)
				outFile write("doc ", docString strip, "\n------\n")
			)
			
			file metadocSlices foreach(d,
                docString := removeWhitespacesAtLineBegginningsOfString(d)
				outFile write("metadoc ", docString strip, "\n------\n")
			)
		)
		outFile close
	)

	sourceFiles := method(cFiles appendSeq(ioFiles))

    removeWhitespacesAtLineBegginningsOfString := method(string,
        string split("\n") map(lstrip) join("\n")
    )

	cFiles := method(
		if(folder directoryNamed("source") exists,
			folder directoryNamed("source") recursiveFilesOfTypes(list("c", "m"))
		,
			list()
		)
	)
	
	ioFiles := method(
		if(folder directoryNamed("io") exists, folder directoryNamed("io") recursiveFilesOfTypes(list("io")), list())
	)
)

