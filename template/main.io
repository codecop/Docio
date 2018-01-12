MainPage := Object clone do(
    globalNavigation := "" asMutable
    maxSlotsNumber := 1

    init := method(
        generateGlobalNavigation()
    )

    generateGlobalNavigation := method(
        categoriesSorted := Docio categories keys sort

        categoriesSorted foreach(categoryName,
            categoryObj := Docio categories at(categoryName)
            globalNavigation appendSeq("<li class=\"uk-nav-header\">#{categoryName}</li>" interpolate)

            prototypesNamesSorted := categoryObj keys sort
            prototypesNamesSorted foreach(protoName,
                slotsSorted := categoryObj at(protoName) at("slots") keys sort

                globalNavigation appendSeq("<li class=\"uk-margin uk-padding-small uk-padding-remove-vertical\"><a href=\"docs/#{protoName asLowercase}.html\">#{protoName}</a>" interpolate)
                
                if(slotsSorted size > 0,
                    globalNavigation appendSeq("<ul class=\"uk-nav-sub\">")
                    protoPageLink := if(protoName != Docio PageGenerator currentPrototypeName, "docs/#{protoName asLowercase}.html" interpolate, "")
                    slotsSorted foreach(slotName,
                        globalNavigation appendSeq("<li><a href=\"#{protoPageLink}##{slotName}\">#{slotName}</a></li>" interpolate)
                    )
                    globalNavigation appendSeq("</ul>")
                )

                maxSlotsNumber = if(slotsSorted size > maxSlotsNumber, slotsSorted size, maxSlotsNumber)

                // close parent
                globalNavigation appendSeq("</li>")
            )
        )
    )
)

MainPage init

""
