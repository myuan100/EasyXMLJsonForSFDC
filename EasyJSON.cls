// This class extends from EsayParser and handles JSON parsing logic. 

global class EasyJSON extends EasyParser {
  private String text = null;
  private JSONException ex = null;
   
  global EasyJSON(String str) {
    super();
    this.text = str.trim();
  }
  
  global virtual override String getErrorMsg() {  
    if(null != ex) return ex.getMessage();  
    return '';
  }
  
  global virtual override Boolean isValid() {
    if (null == text) return false;
    
    if (!isParsed && !isError) {
        parseJSON(false, text);
        isParsed = true;  
    }      
    
    return !isError;

  }
  
  global virtual override Boolean debugAndLog() {
        System.debug('********** Original payload *****************');
        System.debug(text);
        System.debug('*********************************************');
        
        return super.debugAndLog();  
    }
  global virtual override String getDetails() {
        String s = '\n***************** Original Payload for JSON Parser ********************\n ';
        s = s + text + '\n\n';
     
        s = s + super.getDetails();
        
        return s;   
    }  
     
  private void parseJSON(Boolean doLog, String jsonStr) {
        String temp = '';
        
        try {
            if (!jsonStr.startsWith('{') && !jsonStr.startsWith('[')) {
                container.put('/key', jsonStr);
                metadata.put('/key', 0);
                
                return;
            } 
            
            
            JSONParser parser = jsonStr.startsWith('[')? JSON.createParser('{"rootitem":' + jsonStr + '}'): JSON.createParser(jsonStr) ;
            
            while (parser.nextToken() != null) {      
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    Integer indUnderscores = temp.lastIndexOf(DOUBLE_UNDERSCORES);
                    Integer indSlash = temp.lastIndexOf(SLASH);
                    if (indUnderscores > indSlash) {
                        Integer seq = Integer.valueOf(temp.subString(temp.lastIndexOf(DOUBLE_UNDERSCORES) + 2));
                        temp = temp.substring(0, temp.lastIndexOf(DOUBLE_UNDERSCORES) + 2) + String.valueOf(seq+1);
                    } else 
                        temp = temp + DOUBLE_UNDERSCORES + '0';
                        
                    continue;
                }
            
                if (parser.getCurrentToken() == JSONToken.END_ARRAY) {
                    Integer ind = Integer.valueOf(temp.subString(temp.lastIndexOf(DOUBLE_UNDERSCORES) + 2));
                    String key = removeZeros(temp);
                
                    metadata.put(key.subString(0, key.lastIndexOf(DOUBLE_UNDERSCORES)), ind - 1);
                    continue;
                }
            
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    temp = temp + SLASH;
                    continue;
                } 
            
                if (parser.getCurrentToken() == JSONToken.END_OBJECT) {
                    temp = temp.substring(0, temp.lastIndexOf(SLASH));
                    
                    Integer indUnderscores = temp.lastIndexOf(DOUBLE_UNDERSCORES);
                    Integer indSlash = temp.lastIndexOf(SLASH);
                    
                    if (indUnderscores > indSlash) {
                        Integer seq = Integer.valueOf(temp.subString(temp.lastIndexOf(DOUBLE_UNDERSCORES) + 2));
                        temp = temp.substring(0, temp.lastIndexOf(DOUBLE_UNDERSCORES) + 2) + String.valueOf(seq+1);
                    } 

                    continue;
                } 
            
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    Integer i = temp.lastIndexOf(SLASH);
                
                    if(i < 0)
                        temp = temp + parser.getText();                  
                    else 
                        temp = temp.substring(0, temp.lastIndexOf(SLASH) + 1) + parser.getText();
                
                    continue;
                }
            
                String key = removeZeros(temp);
                container.put(key, parser.getText());
                metadata.put(key, 0);
            }
        } catch (JSONException e) {
            isError = true;
            this.ex = e;
        }
    }
    
    private String removeZeros(String s) {
        String key = s;
        key = key.replaceAll('__0', '');
        
        return key;
    }
}
