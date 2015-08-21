global class JSONRequest extends EasySOARequest {
    static String s = '<request>VALUE_KEY</request>'; 
    
    public JSONRequest() {
        super();
        endpoint ='http://api.salesforce.com/JSONTest';
    }
    
    public override String getPayload() {
        Map <String, String> m = new Map <String, String>();
        m.put('VALUE_KEY', 'value');
        
        return getSOAPRequest(EasySOAHelper.getRequestXML(s, m));
    }
}
