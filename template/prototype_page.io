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
            slotsDocs appendSeq("<tr>")
            slotsDocs appendSeq("<td><h4 class=\"uk-h4\" id=\"#{slotName}\"><a class=\"uk-link-reset\">#{slotName}</a></h4></td>" interpolate)
            slotsDocs appendSeq("<td>#{slotDescription}</td>" interpolate)
            slotsDocs appendSeq("</tr>")
        )
    )

    generateSlotsNavigation := method(
        slotsNamesSorted foreach(slotName,
            slotsNavigation appendSeq("<li class=\"uk-padding-small uk-padding-remove-vertical\"><a href=\"##{slotName}\" uk-scroll>#{slotName}</a></li>" interpolate)
        )
    )

    generateGlobalNavigation := method(
        protoNamesSorted := Docio prototypes keys sort
        protoNamesSorted foreach(protoName,
            prototypeObj := Docio prototypes at(protoName)
            globalNavigation appendSeq("<li><a href=\"#{protoName asLowercase}.html\">#{protoName}</a></li>" interpolate)

            // TODO:
            // 1) generate navigation for slots of the each prototype
            // 2) make current prototype an active one (see UIKit api for nav)
        )
    )
)

PrototypePage init

""
