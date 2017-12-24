DocioSearch = {};

DocioSearch.urlPrefix = "";
DocioSearch.docsData = JSON.parse(data);
DocioSearch.prototypesKeys = Object.keys(DocioSearch.docsData).sort();

DocioSearch.query = ""
DocioSearch.result = {};


DocioSearch.setQuery = function(query) {
    DocioSearch.query = query;
    DocioSearch.result = {};

    if (query.length > 1) {
        DocioSearch.__searchPrototypes();
    }

    DocioSearchView.queryDidSet()
}

DocioSearch.__searchPrototypes = function() {
    var regex = new RegExp("\\b(?:"+DocioSearch.query+")", "gi");
    var protoDesc = "";

    DocioSearch.prototypesKeys.forEach(function(element) {
        protoDesc = DocioSearch.docsData[element].description;

        var protoKeyMatch = element.match(regex);
        var descMatch = protoDesc.match(regex);

        if ((protoKeyMatch && protoKeyMatch.length > 0) || (descMatch && descMatch.length > 0)) {
            DocioSearch.result[element] = {};
            DocioSearch.result[element]["description"] = protoDesc;
            DocioSearch.result[element]["url"] = DocioSearch.urlPrefix + element.toLowerCase() + ".html";
        }

        DocioSearch.__searchSlotsInPrototype(element);
    });
}

// called inside of __searchPrototypes for each prototype
DocioSearch.__searchSlotsInPrototype = function(prototypeKey) {
    var slotsKeys = Object.keys(DocioSearch.docsData[prototypeKey].slots).sort();
    var slotDescription = "";
    var regex = new RegExp("\\b(?:"+DocioSearch.query+")", "gi");

    slotsKeys.forEach(function(slotKey) {
        slotDescription = DocioSearch.docsData[prototypeKey].slots[slotKey];

        var slotKeyMatch = slotKey.match(regex);
        var descMatch = slotDescription.match(regex);

        if ((slotKeyMatch && slotKeyMatch.length > 0) || (descMatch && descMatch.length > 0)) {
            DocioSearch.result[prototypeKey + " " + slotKey] = {};
            DocioSearch.result[prototypeKey + " " + slotKey]["description"] = slotDescription;
            DocioSearch.result[prototypeKey + " " + slotKey]["url"] = DocioSearch.urlPrefix + prototypeKey.toLowerCase() + ".html#" + slotKey;
        }
    });
}

// View
DocioSearchView = {};

UIkit.util.on(".nav-overlay", "show", function() {
    UIkit.dropdown(".search-results").show();
});

UIkit.util.on(".nav-overlay", "hide", function() {
    UIkit.dropdown(".search-results").hide();
});

DocioSearchView.clearResultsList = function() {
    var dl = document.getElementById("search-results-table");
    while (dl.firstChild) {
        dl.removeChild(dl.firstChild);
    }
}

DocioSearchView.redrawResultsList = function() {
    DocioSearchView.clearResultsList();

    Object.keys(DocioSearch.result).forEach(function(resName) {
        var resDesc = DocioSearch.result[resName]["description"];
        var url = DocioSearch.result[resName]["url"];

        var tr = document.createElement("tr");

        // title
        var link = document.createElement("a");
        link.setAttribute("class", "uk-link-reset");
        link.setAttribute("href", url);

        var tdTitle = document.createElement("td");
        var title = document.createTextNode(resName);
        link.appendChild(title);
        tdTitle.appendChild(link);
        tdTitle.setAttribute("class", "uk-width-small uk-table-link");

        // description
        var link = document.createElement("a");
        link.setAttribute("class", "uk-link-reset");
        link.setAttribute("href", url);
        var tdDesc = document.createElement("td");
        var description = document.createTextNode(resDesc);
        link.innerHTML = resDesc;
        tdDesc.appendChild(link);
        tdDesc.setAttribute("class", "uk-text-truncate");

        // append
        tr.appendChild(tdTitle);
        tr.appendChild(tdDesc);

        var resultsList = document.getElementById("search-results-table");
        resultsList.appendChild(tr);
    });
}

DocioSearchView.queryDidSet = function() {
    DocioSearchView.redrawResultsList()
    UIkit.dropdown(".search-results").show();
}
