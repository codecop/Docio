DocioSearch = {};

DocioSearch.urlPrefix = "";
DocioSearch.docsData = JSON.parse(data);
DocioSearch.prototypesKeys = Object.keys(DocioSearch.docsData).sort();

DocioSearch.query = ""
DocioSearch.result = {};
DocioSearch.result.protos = {};
DocioSearch.result.slots = {};
DocioSearch.result.descs = {};


DocioSearch.setQuery = function(query) {
    DocioSearch.query = query;
    DocioSearch.result = {};
    DocioSearch.result.protos = {};
    DocioSearch.result.slots = {};
    DocioSearch.result.descs = {};

    if (query.length > 0) {
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

        if (protoKeyMatch && protoKeyMatch.length > 0) {
            // highlight match
            var key = element.replace(regex, "<span class=\"uk-text-success\">$&</span>");
            // add match to object
            DocioSearch.result.protos[key] = {};
            DocioSearch.result.protos[key]["description"] = protoDesc;
            DocioSearch.result.protos[key]["url"] = DocioSearch.urlPrefix + element.toLowerCase() + ".html";
        }

        if (descMatch && descMatch.length > 0 && !DocioSearch.result.protos[element]) {
            // highlight match
            protoDesc = protoDesc.replace(regex, "<span class=\"uk-text-success\">$&</span>");
            // add match to object
            DocioSearch.result.descs[element] = {};
            DocioSearch.result.descs[element]["description"] = protoDesc;
            DocioSearch.result.descs[element]["url"] = DocioSearch.urlPrefix + element.toLowerCase() + ".html";
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
        var key = prototypeKey + " " + slotKey;
        // it's possible to include all the slots for matching prototype
        // by uncomment bellow lines, but does it needed? 
        // The searching results now is: prototype names (and there is all the slots), 
        // slot names, matches in descriptions for prototypes and slots.
        // var slotKeyMatch = key.match(regex);
        var descMatch = slotDescription.match(regex);

        if (slotKeyMatch && slotKeyMatch.length > 0) {
            // highlight match
            var slotName = slotKey.replace(regex, "<span class=\"uk-text-success\">$&</span>");
            key = prototypeKey + " " + slotName;
            // add match to object
            DocioSearch.result.slots[key] = {};
            DocioSearch.result.slots[key]["description"] = slotDescription;
            DocioSearch.result.slots[key]["url"] = DocioSearch.urlPrefix + prototypeKey.toLowerCase() + ".html#" + slotKey;
        }

        if (descMatch && descMatch.length > 0 && !DocioSearch.result.slots[key]) {
            // highlight match
            slotDescription = slotDescription.replace(regex, "<span class=\"uk-text-success\">$&</span>");
            // add match to object
            DocioSearch.result.descs[key] = {};
            DocioSearch.result.descs[key]["description"] = slotDescription;
            DocioSearch.result.descs[key]["url"] = DocioSearch.urlPrefix + prototypeKey.toLowerCase() + ".html#" + slotKey;
        }
    });
}

// View
DocioSearchView = {};

// UIkit.util.on(".nav-overlay", "show", function() {
    // UIkit.dropdown(".search-results").show();
// });
// 
// UIkit.util.on(".nav-overlay", "hide", function() {
    // UIkit.dropdown(".search-results").hide();
// });

DocioSearchView.clearResultsList = function() {
    var dl = document.getElementById("search-results-table");
    while (dl.firstChild) {
        dl.removeChild(dl.firstChild);
    }
}

DocioSearchView.redrawResultsList = function() {
    DocioSearchView.clearResultsList();

    var addResultEntry = function(resName, resDesc, url) {
        var tr = document.createElement("tr");

        // title
        var link = document.createElement("a");
        link.setAttribute("class", "uk-link-reset");
        link.setAttribute("href", url);

        var tdTitle = document.createElement("td");
        // var title = document.createTextNode(resName);
        console.log(resName);
        link.innerHTML = resName;
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
    };

    // Prototypes
    Object.keys(DocioSearch.result.protos).forEach(function(resName) {
        var resDesc = DocioSearch.result.protos[resName]["description"];
        var url = DocioSearch.result.protos[resName]["url"];

        addResultEntry(resName, resDesc, url);
    });

    // Slots
    Object.keys(DocioSearch.result.slots).forEach(function(resName) {
        var resDesc = DocioSearch.result.slots[resName]["description"];
        var url = DocioSearch.result.slots[resName]["url"];

        addResultEntry(resName, resDesc, url);
    });

    // Descriptions
    Object.keys(DocioSearch.result.descs).forEach(function(resName) {
        var resDesc = DocioSearch.result.descs[resName]["description"];
        var url = DocioSearch.result.descs[resName]["url"];

        addResultEntry(resName, resDesc, url);
    });
}

DocioSearchView.queryDidSet = function() {
    DocioSearchView.redrawResultsList()
    UIkit.dropdown(".search-results").show();
}
