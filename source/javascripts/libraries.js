//= require libraries/jquery
//= require libraries/json2
//= require libraries/underscore
//= require libraries/underscore-addons
//= require libraries/backbone
//= require libraries/backbone-modelbinding
//= require libraries/polymaps
//= require libraries/xdate

// http://stackoverflow.com/questions/646628/javascript-startswith
String.prototype.startsWith = function (str){
    return this.indexOf(str) == 0;
};

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
