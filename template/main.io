s := "" asMutable
Docio prototypes keys foreach(k, s appendSeq("<li>#{k}</li>" interpolate))
s println
