export function setCookie(name, value, hours, secure = true) {
  var expires = "";
  var date = new Date();
  date.setTime(date.getTime() + hours * 60 * 60 * 1000);
  expires = "; expires=" + date.toUTCString();
  document.cookie = name + "_expiry=" + date.getTime() + "; path=/" + (secure ? "; Secure" : "");
  expires = "; expires=Session"; // Expire when browser session ends
  document.cookie = name + "=" + (value || "") + expires + "; path=/" + (secure ? "; Secure" : "");
}

export function getCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(";");
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) === " ") c = c.substring(1, c.length);
    if (c.indexOf(nameEQ) === 0) {
      var cookieValue = c.substring(nameEQ.length, c.length);
      var expiryCookie = getCookie(name + "_expiry");
      if (expiryCookie) {
        var expiryTime = parseInt(expiryCookie);
        if (Date.now() > expiryTime) {
          deleteCookie(name);
          return null;
        }
      }
      return cookieValue;
    }
  }
  return null;
}

export function deleteCookie(name) {
  document.cookie = name + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; Secure";
  document.cookie = name + "_expiry=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; Secure";
}

export function eraseCookie(name) {
  document.cookie = name + "=; Max-Age=-99999999; Secure";
}
