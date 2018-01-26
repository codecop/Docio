data = JSON.stringify({"03_CommentsFormat":{"slots":{},"category":"<p>Guide</p>","description":"<p>Use single- or multiline comments with following keyword <code>doc</code> or <code>metadoc</code>.</p>\n\n<p>Firstly add your object to a category. The category can be named any you like.</p>\n\n<pre><code class=\"language-io\">&#47;&#47;metadoc Prototype category API\n</code></pre>\n\n\n<blockquote><p> Instead of <code>category</code> you can use any keyword — all following this keyword will be\n available in <code>DocsParser docsMap</code> and <code>Docio categories</code>.</p></blockquote>\n\n<p>Then add an optional description to the object:</p>\n\n<pre><code class=\"language-io\">&#47;*metadoc Prototype description\nSome desciption.*&#47;\n</code></pre>\n\n\n<p>Then comment your public API:</p>\n\n<pre><code class=\"language-io\">&#47;&#47;doc Prototype slotName(args) Description</code></pre>\n\n\n<p>You can use markdown in your comments. It will be parsed to equivalent HTML code during generation.</p>\n\n<p><a href=\"04_creatingtemplates.html\">Next</a></p>"},"01_Introduction":{"slots":{},"category":"<p>Guide</p>","description":"<p>Docio is the documentation generator for Eerie — the package manager for Io.\nThat means that it generates documentation from comments in sources of an Eerie's package.</p>\n\n<p>After generation process it provides you with an HTML documentation pack that can be used as a site for\nyour project. It's also generates <code>docs.txt</code>, which is used by Docio to print you documentation right\nin the console while you interact with the Io's interpreter.</p>\n\n<p>Docio comes with a default template, based on <a href=\"http://getuikit.com\">uikit</a>. But you can provide\nyour own template. And you can mix HTML with Io in such template.</p>\n\n<p>This site is generated by Docio.</p>\n\n<p>Docio's source code is available <a href=\"https://github.com/AlesTsurko/docio\">here</a>.</p>\n\n<p><a href=\"02_usage.html\">Next</a></p>"},"PageGenerator":{"slots":{"generateMainPage":"<p>Generates the <code>index.html</code> from the <code>main_template.html</code>.</p>","generateSite":"","generatePrototypesPages":"<p>Generates a page for each of the prototype of the given map.\nThis method creates a page for each object from the prototype_template.html.</p>","init":""},"category":"<p>API</p>","description":"<p>Generates documentation pages.</p>"},"02_Usage":{"slots":{},"category":"<p>Guide</p>","description":"<p>Docio comes with a command line application <code>docio</code>, that you can use\nlike this:</p>\n\n<pre><code class=\"language-shell\">docio package=/path/to/package [template=/path/to/template]\n</code></pre>\n\n\n<p>After running, it will search recursively for files with extensions \"io\", \"docio\",\n\"c\" and \"m\" in the directories <code>source</code> and <code>io</code>, then it'll extract documentation from\nit and compile HTML using the provided or the default template. After that it will\nput all the documentation in the <code>docs</code> folder of the package directory.</p>\n\n<p>You'll also find useful <a href=\"docio.html\"><code>Docio printDocFor(query)</code></a>.</p>\n\n<p><a href=\"03_commentsformat.html\">Next</a></p>"},"Docio":{"slots":{"outputPath":"<p>Path to the <code>docs</code> in the destination package's directory.</p>","openDocsForPackageWithName(packageName)":"","packageName":"","packageInfo":"<p>Returns package.json as an instance of Map.</p>","categories":"<p><code>DocsParser docsMap</code> sorted by categories.</p>","generateDocs":"<p>Generates documentation for the package at <code>packagePath</code>.</p>","DocsParser":"<p><a href=\"docsparser.html\">DocsParser</a></p>","generateSite":"<p>Use this only after you did parsing.</p>","extractDocs":"<p>Generates <code>docs.txt</code> using <a href=\"docsextractor.html\">DocsExtractor</a>.</p>","templatePath":"","getDocsTxt":"","PageGenerator":"<p><a href=\"pagegenerator.html\">PageGenerator</a></p>","copyTemplate(templateDir)":"","packagePath":"","printDocFor(query)":"<p>Prints documentation for given <code>query</code>.</p>\n\n<p>The method will try to extract the documentation from <code>doc</code> comments,\nif the <code>docs/docs.txt</code> wouldn't exist in the package's directory.</p>\n\n<p>Examples of query:\n<code>\n\"ProtoName\"\n\"ProtoName slotName\"\n\"AddonName ProtoName slotName\"\n</code></p>"},"category":"<p>API</p>"},"04_CreatingTemplates":{"slots":{},"category":"<p>Guide</p>","description":"<p>You should provide two template files: <code>main_template.html</code> and <code>prototype_template.html</code>.</p>\n\n<p>The first one is used to generate the main page. The second one is for the documentation pages.</p>\n\n<p>In the HTML files you can use Io code:</p>\n\n<pre><code class=\"language-io\">&lt;h1>#{\"Hello\"}&lt;/h1>\n</code></pre>\n\n\n<p>Check out Docio's default template <a href=\"https://github.com/AlesTsurko/docio/tree/master/template\">directory</a> to get an example.</p>"},"DocsParser":{"slots":{"parse":"<p>Parses <code>docs.txt</code> generated by [DocsExtractor] and fills up the <code>docsMap</code>.</p>","docsMap":"<p>The map generated after parse process.</p>"},"category":"<p>API</p>"}});