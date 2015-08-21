global virtual class EasyXML extends EasyParser {
  private String text = null;
  protected Xmlexception xmlEx = null;
  
  global EasyXML(String str) {
    super();
    this.text = str;
  }
  
  global virtual override String getErrorMsg() {
    if (null != xmlEx) {
      return xmlEx.getMessage();
    }
    
    return '';
  }
  
  global virtual override Boolean isValid() {
    if (null == text) return false;
        
        try {
            if (!isParsed && !isError) {
                parseXML(false, new XmlStreamReader(text));
                isParsed = true;
            }
        } catch (System.Xmlexception ex) {
          xmlEx = ex;
            isError = true;
            System.debug(Logginglevel.WARN, 'Xmlexception was thrown from -- ' + ex.getStackTraceString());
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
        String s = '\n***************** Original Payload for XML Parser ***********************\n ';
        s = s + text + '\n\n';
        
        s = s + super.getDetails();
        
        return s;   
    } 
    
    private void parseXML(Boolean doLog, XmlStreamReader reader) {
        reader.setCoalescing(true);
        
        String location = EMPTY_STRING;

        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                location = location + SLASH + reader.getLocalName();
                if (metadata.containsKey(location)) {
                    metadata.put(location, (Integer) metadata.get(location)+1);
                    location = location + DOUBLE_UNDERSCORES + metadata.get(location);
                } else 
                    metadata.put(location, 0);
        
                if (doLog)
                    System.debug('START_ELEMENT: ' + location);
                else 
                    System.debug(Logginglevel.INFO, 'START_ELEMENT: ' + location);
            } 
            
            if (reader.getEventType() == XmlTag.CHARACTERS) {
                if (!reader.isWhitespace()) {
                    container.put(location, reader.getText());
                
                    if (doLog)
                        System.debug('Put: ' + location + '(' + reader.getText() + ')');
                    else 
                        System.debug(Logginglevel.INFO, 'Put: ' + location + '(' + reader.getText() + ')');
                }
            }
            
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                location = location.substring(0, location.lastIndexOf(reader.getLocalName())-1);        

                if (doLog)
                    System.debug('END_ELEMENT: ' + location);
                else 
                    System.debug(Logginglevel.INFO, 'END_ELEMENT: ' + location);
            }
            
            reader.next();
        }
    }
}
