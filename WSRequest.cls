global class WSRequest extends EasySOARequest {

    public WSRequest() {
      super();
      endpoint ='http://api.salesforce.com/SOATest';
      
      Map<String, String> headers = new Map<String, String>();
      headers.put('mykey1', 'myvalue1');
      headers.put('mykey2', 'myvalue2');
      setHTTPHeaders(headers);
      setTimeOut(10000);
    }
    
    public override String getPayload() {
      return getSOAPRequest('<request>value</request>');
    }
}
