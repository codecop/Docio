Docio

describe("Docio",
    it("Should return list for query",
        query := "Docio   getListForQuery  "
        expected := list("Docio", "getListForQuery")

        expect(Docio getListForQuery(query)) toBe(expected)
    )
)
