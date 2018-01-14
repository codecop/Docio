data = JSON.stringify({"CLI":{"category":"<p>API</p>","slots":{},"description":"<p>Docio command line interface.</p>"},"Docio":{"category":"<p>API</p>","slots":{"DocsExtractor":"<p><a href=\"docsextractor.html\">DocsExtractor</a></p>","templatePath":"","printDocFor(query)":"<p>Prints documentation for given <code>query</code>.</p>\n\n<p>The method will try to extract the documentation from <code>doc</code> comments,\nif the <code>docs/docs.txt</code> wouldn't exist in the package's directory.</p>\n\n<p>Examples of query:\n<code>\n\"ProtoName\"\n\"ProtoName slotName\"\n\"AddonName ProtoName slotName\"\n</code></p>","copyTemplate(templateDir)":"","extractDocs":"<p>Generates <code>docs.txt</code> using <a href=\"docsextractor.html\">DocsExtractor</a>.</p>","packageInfo":"<p>Returns package.json as an instance of Map.</p>","generateDocs":"<p>Generates documentation for the package at <code>packagePath</code>.</p>","packageName":"","Parser":"<p><a href=\"docsparser.html\">DocsParser</a></p>","CLI":"<p><a href=\"cli.html\">CLI</a></p>","outputPath":"<p>Path to the <code>docs</code> in the destination package's directory.</p>","getDocsTxt":"","generateSite":"<p>Use this only after you did parsing.</p>","PageGenerator":"<p><a href=\"pagegenerator.html\">PageGenerator</a></p>","packagePath":"","categories":"<p><code>DocsParser docsMap</code> sorted by categories.</p>"}},"PageGenerator":{"category":"<p>API</p>","slots":{"generateSite":"","generateMainPage":"<p>Generates the <code>index.html</code> from the <code>main_template.html</code>.</p>","init":"","generatePrototypesPages":"<p>Generates a page for each of the prototype of the given map.\nThis method creates a page for each object from the prototype_template.html.</p>"},"description":"<p>Generates documentation pages.</p>"},"01_Introduction":{"category":"<p>Guide</p>","slots":{},"description":"<p>Docio is the documentation generator for Eerie — the package manager for Io.\nThat means that it generates documentation from comments in sources of an Eerie's package.</p>\n\n<p>After generation process it provides you with an HTML documentation pack that can be used as a site for\nyour project. It's also generates <code>docs.txt</code>, which is used by Docio to print you documentation right\nin the console while you interact with the Io's interpreter.</p>\n\n<p>Docio comes with a default template, based on <a href=\"http://geuikit.com\">uikit</a>. But you can provide\nyour own template. And you can mix HTML with Io in such template.</p>\n\n<p>This site is produced by Docio.</p>\n\n<p>Docio's source code is available <a href=\"https://github.com/AlesTsurko/docio\">here</a>.</p>"},"DocsParser":{"category":"<p>API</p>","slots":{"docsMap":"<p>The map generated after parse process.</p>","parse":"<p>Parses <code>docs.txt</code> generated by <a href=\"docsextractor.html\">DocsExtractor</a> and fills up the <code>docsMap</code>.</p>"}}});