global class WSResponseMock implements HttpCalloutMock{
  public static String xmlString = 
  '<root>' + 
  '   <firstbook>' + 
  '      <title>APEX Developer Guide</title>' + 
  '      <price>10</price>' + 
  '      <publishdate>2010-03-01 11:30:00</publishdate>' +
  '      <instock>true</instock>' +
  '   </firstbook>' + 
    '   <secondbook>' + 
    '      <title>VisualForce Developer Guide</title>' + 
    '      <price>20</price>' + 
    '   </secondbook>' + 
  '   <books>' + 
  '      <book>' + 
  '         <title>Introduction to SaleForce</title>' + 
  '         <price>10</price>' +
  '      </book>' + 
  '      <book>' + 
  '         <title>APEX Developer Guide</title>' + 
  '         <price currency="USD">20</price>' + 
  '         <available>' + 
  '             <language>English</language>' + 
  '             <language>Spanish</language>' + 
  '             <language>Chinese</language>' + 
  '         </available>' + 
  '         <publisher>' + 
  '             <name>salesforce.com</name>' +
  '         </publisher>' + 
  '      </book>' + 
  '      <book>' + 
  '         <title>VisualForce Developer Guide</title>' + 
  '         <price>30</price>' + 
  '         <available>' + 
  '             <language>English</language>' + 
  '             <language>Spanish</language>' + 
  '         </available>' + 
  '      </book>' + 
  '   </books>' + 
  '</root>';
  
  public static String invalidString = '<root><book><title>APEX Developer Guide</title><book></root>';

    global HTTPResponse respond(HTTPRequest req) {
        System.debug('mykey1 --> ' + req.getHeader('mykey1'));
        System.debug('mykey2 --> ' + req.getHeader('mykey2'));
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        if ('http://api.salesforce.com/SOATest'.equals(req.getEndpoint()))
          res.setBody(xmlString);
        else {
          if ('http://api.salesforce.com/SOATest/error'.equals(req.getEndpoint()))
            res.setBody(invalidString);
        }
        res.setStatusCode(200);
        return res;
    }
}
