PrototypePage := Object clone do(
    globalNavigation := "" asMutable
    slotsNavigation := "" asMutable
    slotsDocs := "" asMutable
    slotsNamesSorted := nil

    init := method(
        slotsNamesSorted = DocioPageGenerator currentPrototype at("slots") keys sort

        generateSlotsDocs()
        generateSlotsNavigation()
        generateGlobalNavigation()
    )

    generateSlotsDocs := method(
        slotsNamesSorted foreach(slotName,
            slotDescription := DocioPageGenerator currentPrototype at("slots") at(slotName)
            slotsDocs appendSeq("<dt><h4 class=\"uk-h4\" id=\"#{slotName}\"><a class=\"uk-link-reset header-anchor\" href=\"##{slotName}\" onclick=\"updateAddressWithAnchorLink(this)\" uk-scroll=\"offset: 100\"><span class=\"header-anchor-icon\" uk-icon=\"icon: link\"></span>#{slotName}</a></h4></dt>" interpolate)
            slotsDocs appendSeq("<dd>#{slotDescription}</dd>" interpolate)
        )
    )

    generateSlotsNavigation := method(
        slotsNamesSorted foreach(slotName,
            slotsNavigation appendSeq("<li class=\"uk-padding-small uk-padding-remove-vertical\"><a href=\"##{slotName}\" class=\"header-anchor\" onclick=\"updateAddressWithAnchorLink(this)\" uk-scroll=\"offset: 100\">#{slotName}</a></li>" interpolate)
        )
    )

    generateGlobalNavigation := method(
        categoriesSorted := Docio categories keys sort

        categoriesSorted foreach(categoryName,
            categoryObj := Docio categories at(categoryName)
            globalNavigation appendSeq("<li class=\"uk-nav-header\">#{categoryName}</li>" interpolate)

            prototypesNamesSorted := categoryObj keys sort
            prototypesNamesSorted foreach(protoName,
                slotsSorted := categoryObj at(protoName) at("slots") keys sort
                parentClass := if(slotsSorted size > 0, "uk-parent", "")

                if(protoName != DocioPageGenerator currentPrototypeName,
                    globalNavigation appendSeq("<li class=\"#{parentClass}\"><a href=\"#{protoName asLowercase}.html\">#{protoName}</a>" interpolate),
                    // else
                    globalNavigation appendSeq("<li class=\"uk-active #{parentClass}\"><a href=\"#\">#{protoName}</a>" interpolate)
                )
                
                // fill up slots submenus
                shouldScroll := if(protoName == DocioPageGenerator currentPrototypeName, "onclick=\"updateAddressWithAnchorLink(this)\" uk-scroll=\"offset: 100\"", "")

                if(slotsSorted size > 0,
                    globalNavigation appendSeq("<ul class=\"uk-nav-sub\">")
                    protoPageLink := if(protoName != DocioPageGenerator currentPrototypeName, "#{protoName asLowercase}.html" interpolate, "")
                    slotsSorted foreach(slotName,
                        globalNavigation appendSeq("<li><a href=\"#{protoPageLink}##{slotName}\" #{shouldScroll}>#{slotName}</a></li>" interpolate)
                    )
                    globalNavigation appendSeq("</ul>")
                )

                // close parent
                globalNavigation appendSeq("</li>")
            )
        )
    )
)

PrototypePage init

""
