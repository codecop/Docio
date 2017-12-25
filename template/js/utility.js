// updates address bar with link address including anchor links
// without reloading the page
function updateAddressWithAnchorLink(obj) {
    history.pushState({}, "", obj.href);
}
