global class EasySOAResponse{

  private HTTPResponse resp = null;
  private Exception calloutEx = null;
  private EasyParser parser = null;
  private Boolean isX = true;
  
  global EasySOAResponse (HTTPResponse resp, Exception ex, Boolean isXML) {
    this.resp = resp;
    this.calloutEx = ex;  
    this.isX = isXML;  
  }
  
  global virtual String getErrorMsg(String xpath) {
    String errString = getErrorMsg();
    
    if (errString.length() > 0)
      return errString;
    
    return parser.retrieveElement(xpath);
  }

  global virtual String getErrorMsg() {
    if (null != calloutEx) 
      return calloutEx.getMessage();
    
    if (resp.getStatusCode() != 200 && null == parser)
      return 'The service returned HTTP status code <' + resp.getStatusCode() + '> and payload <' + resp.getBody() + '>.';
      
    if (null == parser)
      return 'The response\'s Content-Type header has <' + resp.getHeader('Content-Type') + '> value.';
    
    String errString = parser.getErrorMsg();
    if (null != errString) {
      return errString;
    }
    
    return '';
  }  
  
  global Boolean isValid() {
        if (null == resp) return false;
      
        String httpHeader = resp.getHeader('Content-Type');

        if(null == httpHeader) {
            if (this.isX) 
                this.parser = new EasyXML(resp.getBody());
            else 
                this.parser = new EasyJSON(resp.getBody());
        } else {
            String temp = httpHeader.toUpperCase();
        
            if (temp.contains('XML'))
                this.parser = new EasyXML(resp.getBody());
            
            if (temp.contains('JSON') || temp.contains('PLAIN') ) 
                this.parser = new EasyJSON(resp.getBody());
        }  
        
        if (null == parser) return false;
              
        return parser.isValid() && resp.getStatusCode() == 200 ;
    } 
    
  global Boolean debugAndLog() {
        return parser.debugAndLog();
    }
  
  global String getDetails() {
      if (null == resp) {
          return (null == calloutEx) ? 'No data returned.': calloutEx.getStackTraceString();
      }
          
      return parser.getDetails();
  }  
    
  global String retrieveElement(String xpath)  {
    return parser.retrieveElement(xpath);
  }
  
  global String retrieveElement(String xpath, String indexpath) {
    return parser.retrieveElement(xpath, indexpath);
  }
  
  global Map<String, String> retrieveElements(List<String> xpaths){
    return parser.retrieveElements(xpaths);
  }
  
   global Integer getNumberOfSiblings(String xpath) {
    return parser.getNumberOfSiblings(xpath);
   }
   
   global Integer getNumberOfSiblings(String xpath, String indexpath) {
    return parser.getNumberOfSiblings(xpath, indexpath);
   }
   
   global Map<String, String> retrieveImmediateValuesInCollection(String xpath, String indexpath) {
    return parser.retrieveImmediateValuesInCollection(xpath, indexpath);
   }
   
   global Map<String, String> retrieveUniqueValuesInCollection(String xpath, String indexpath) {
    return parser.retrieveUniqueValuesInCollection(xpath, indexpath);
   }
   
   global Map<String, String> retrieveAllValuesInCollection(String xpath, String indexpath) {
    return parser.retrieveAllValuesInCollection(xpath, indexpath);
   }
   
   global List<String> retrieveValuesFromSiblings(String xpath, String indexpath) {
    return parser.retrieveValuesFromSiblings(xpath, indexpath);
   }
   
   global SObject createNewSObject(String name, Map<String, String> mappings) {   
    return parser.createNewSObject(name, mappings);
   }
   
   global SObject createNewSObject(String name, Map<String, String> mappings, List<String> defaults) {
    return parser.createNewSObject(name, mappings, defaults);
   }
   
   global Boolean populateFields(SObject s, Map<String, String> mappings) { 
    return parser.populateFields(s, mappings);
   }
   
   global Boolean populateFields(SObject s, Map<String, String> mappings, List<String> defaults) {
    return parser.populateFields(s, mappings, defaults);
   }
   
   global String buildStringFromCollection(String xpath, String indexpath, String delimiter) {
    return parser.buildStringFromCollection(xpath, indexpath, delimiter);
   }
   
   global virtual SObject[] createNewSObjects(String name, String rootPath, String indexPath, Map<String, String> mappings) {   
    return parser.createNewSObjects(name, rootPath, indexPath, mappings);        
   }
    
   global virtual SObject[] createNewSObjects(String name, String rootPath, String indexPath, Map<String, String> mappings, List<String> defaults) {  
    return parser.createNewSObjects(name, rootPath, indexPath, mappings, defaults);   
   } 
}
