global abstract class EasySOARequest {
    global String endpoint = '';
    global String httpMethod = 'GET';
    global Map<String, String> headers = new Map<String, String>();
    global Integer timeOut = 120000;
    
    global void setHTTPMethod(String s ) {
        httpMethod = s;
    }
    
    global void setEndpoint(String s) {
        endpoint = s;
    }
    
    global virtual void setHTTPHeaders(Map<String, String> myMap) {
        headers.putAll(myMap);
    }
    
    global virtual void setTimeOut(Integer i) {
        timeOut = i;
    }
  
    global EasySoaRequest() {
    }

    global EasySOAResponse callout() {   
        return this.callout(true);
    } 
    
    global EasySOAResponse callout(Boolean isXml) {    
        if (timeOut <=0 || timeOut > 120000)
            timeOut = 120000;
            
        try {        
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod(httpMethod);
            req.setTimeout(timeOut);
            setHeaders(req);
            
            String body = getPayload();
            if (null != body) 
                req.setBody(body);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            return new LVT.EasySOAResponse(res, null, isXml);
        } catch(CalloutException callEx) {
            return new LVT.EasySOAResponse(null, callEx, false);
        } catch(Exception callEx) {
            return new LVT.EasySOAResponse(null, callEx, false);
        } 
    }
    
    global String getSOAPRequest(String s) {
        return '<?xml version="1.0" encoding="UTF-8" ?><env:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Header /><env:Body>' + 
        s + '</env:Body></env:Envelope>';
    }
    
    global abstract String getPayload();
    
    private void setHeaders(HttpRequest req) {
        if (headers.size() <= 0)
            return;
        
        Set <String> mapKeys = headers.keySet();
        
        for(String s: mapKeys) {
            req.setHeader(s, headers.get(s));
        }        
    }
}
