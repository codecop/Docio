s := "" asMutable
Docio prototypes keys foreach(k, s appendSeq("<li><a href=\"prototypes/#{k asLowercase}.html\">#{k}</a></li>" interpolate))
s println
