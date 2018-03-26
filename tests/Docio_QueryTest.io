QueryTest := UnitTest clone do(
    testQueryList := method(
        query := "Docio   getListForQuery  "
        expected := list("Docio", "getListForQuery")

        assertEquals(Docio getListForQuery(query), expected)
    )
)
