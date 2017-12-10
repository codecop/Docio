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
            slotsDocs appendSeq("<a class=\"uk-link-reset\" id=\"#{slotName}\"><h3 class=\"uk-heading-divider\">#{slotName}</h3></a>" interpolate)
            slotsDocs appendSeq("<p>#{slotDescription}</p>" interpolate)
        )
    )

    generateSlotsNavigation := method(
        slotsNamesSorted foreach(slotName,
            slotsNavigation appendSeq("<li><a href=\"##{slotName}\">#{slotName}</a></li>" interpolate)
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
