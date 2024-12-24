Docio
=====

Documentation generator for [Eerie](https://github.com/AlesTsurko/eerie)
packages. 




## Install

Docio ships with Eerie by default. If you've installed
[Eerie](https://github.com/AlesTsurko/eerie) you already have Docio.




## Usage

For the API documentation and guide check Docio's site (which is also an example
of generated output): http://iolanguage.github.io/docio


### CLI

```
docio --package=/path/to/package [--template=/path/to/template]
```

This command recursively searches for files with extensions "io", "docio", "c"
and "m" in the `source` and `io` directories. Then it extracts documentation
from theses files and compiles HTML using either the provided or default
template. After that it put all the documentation in `docs` folder in the
package directory.


### Documentation Comments Format

You need to add your object to a category first. The category can be named
whatever you like. You'll get more understanding of what is a category, when you
generate your docs. So just try it and see.

```Io
//metadoc Prototype category API
```

Optionally add a description to the object:

```Io
/*metadoc Prototype description
Desciption goes here.
*/
```

Then comment out your public API like this:
```Io
//doc Prototype slotName(args) Description
```

Markdown is fully supported.


### Writing Templates

You should provide two template files: `main_template.html` and
`prototype_template.html`. The first one is used to generate the main page. The
second is for the documentation pages.

In the template files you can use Io code:

```Io
<h1>#{"Hello"}</h1>
```

Check out `template` folder to get an example.
