// http://stackoverflow.com/a/4198132/40956
function getHashParams() {

    var hashParams = {};
    var e,
        a = /\+/g,  // Regex for replacing addition symbol with a space
        r = /([^&;=]+)=?([^&;]*)/g,
        d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
        q = window.location.hash.substring(1);
        q = q.split("?").pop()

    while (e = r.exec(q))
       hashParams[d(e[1])] = d(e[2]);

    return hashParams;
}
