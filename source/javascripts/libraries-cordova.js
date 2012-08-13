if(isAndroid()) {
  $("script").attr("src", "lib/android/cordova-2.0.0.js").appendTo("head");
} else if(isiOS()){
  $("script").attr("src", "lib/ios/cordova-2.0.0.js").appendTo("head");
}
  
function isAndroid(){
  return navigator.userAgent.indexOf("Android") > 0;
}

function isiOS(){
  return ( navigator.userAgent.indexOf("iPhone") > 0 || navigator.userAgent.indexOf("iPad") > 0 || navigator.userAgent.indexOf("iPod") > 0); 
}
