// http://stackoverflow.com/questions/646628/javascript-startswith
String.prototype.startsWith = function (str){
    return this.indexOf(str) == 0;
};
