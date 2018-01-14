Docio
=====

Documentation generator for [Eerie](https://github.com/AlesTsurko/eerie) packages. 

## Install
No need to install. If you've installed [Eerie](https://github.com/AlesTsurko/eerie) you already have Docio.

## Usage
```
docio package=/path/to/package [template=/path/to/template]
```

It will search recursively for files with extensions "io", "docio", "c" and "m" in the directories `source` and `io`,
then it'll extract documentation from it and compile HTML using the provided or the default template. 
After that it will put all the documentation in `docs` folder of the package directory.

## Comments format
Firstly add your object to a category. The category can be named any you like.
```Io
//metadoc Prototype category API
```

Then add an optional description to the object:
```Io
/*metadoc Prototype description
Desciption goes here.
*/
```

Then comment your public API like this:
```Io
//doc Prototype slotName(args) Description
```

You can also use markdown in your comments. It will be parsed to equivalent HTML code during generation.

## Writing templates
You should provide two template files: `main_template.html` and `prototype_template.html`.

The first one is used to generate the main page.

The second is for the documentation pages.

In the HTML files you can use Io code:

```Io
<h1>#{"Hello"}</h1>
```

Check out `template` folder to get an example.

## Examples
Docio [site](http://alestsurko.by/docio/) was fully generated with Docio itself.
