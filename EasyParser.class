global abstract class EasyParser {
    public static final String EMPTY_STRING = '';
    public static final String DOUBLE_UNDERSCORES = '__';
    public static final String SLASH = '/';
    public static final Map<String, String> NO_DATA = new Map<String, String>();
    public static final List<String> EMPTY_LIST = new List<String>();
    
    protected Map<String, String> container = new Map<String, String>();
    protected Map<String, Integer> metadata = new Map<String, Integer>();
    protected Boolean isParsed = false;
    protected Boolean isError = false;
    
    protected EasyParser() {
    }
        
    // This method MUST be called before invoking other methods in this class. 
    // 
    // This method returns a Boolean indicating if the webservice endpoint has
    // sent back valid response. When a “true” is returned from this method, 
    // the calling client can use one of public methods to retrieve values from
    // the response. Otherwise, the client should invoke the “getFault” method to 
    // retrieve the fault message from the response. 

    global abstract Boolean isValid() ;
        
    global virtual Boolean debugAndLog(){
        isValid();
               
        for (String variable : getSortedKeySet(container.keySet())) {
                System.debug(variable+ ' --> ' +  container.get(variable));
        }
        
        System.debug('*********************************************');
        for (String variable : getSortedKeySet(metadata.keySet())) {
                System.debug(variable+ ' --> ' +  metadata.get(variable));
        }        
        
        System.debug('*********************************************');
        
        return !isError;    
    }
    
    global virtual String getDetails() {
        String s = '\n***************** name/value pairs ****************************\n\n ';
        for (String variable : getSortedKeySet(container.keySet())) {
                s = s + generatePath(variable) + ' --> ' +  container.get(variable) + '\n ';
        }
        
        s = s + '***************** number of occurrence ****************************\n\n ';
        for (String variable : getSortedKeySet(metadata.keySet())) {
                s = s + generatePath(variable) + ' --> ' +  (metadata.get(variable)+1) + '\n ';
        }        
        
        s = s + '*********************************************\n';    
        
        return s;    
    }
    
    protected String generatePath(String s) {
        String[] sarray = s.split(SLASH);

        String xpath = '';
        String indpath = '';

        for (Integer i = 1; i<Sarray.size(); i++) {
            String temp = sarray[i];
            Integer ind  = temp.lastIndexOf(DOUBLE_UNDERSCORES);
            if (ind < 0) {
                xpath = xpath + SLASH +  temp; indpath = indpath + SLASH + '0';
            } else {
                xpath = xpath + SLASH +  temp.substring(0, ind); indpath = indpath + SLASH + temp.substring(ind+2);
            }
        }

        String s1 = indpath.replaceall(SLASH,'');
        s1 = s1.replaceall('0','');
        
        if (s1.length() == 0)
            return xpath;
        else
            return xpath + ' [' + indpath + ']';
    }
    
    global abstract String getErrorMsg();    
    
    // This method returns the value in an xml element in webservice response. The xml element is 
    // identified by an xpath expression as the argument in its signature. 
    //
    // <root>
    //    <book>
    //       <title>APEX Developer Guide</title>
    //    </book>
    // </root>
    //
    // With an xpath value -- "/root/book/title", this method returns "APEX Developer Guide".
    //
    // DON'T use this method if any element in the xpath string is a memebr of colloction. 
    
    global String retrieveElement(String xpath) {
        return isError ? EMPTY_STRING: (String)container.get(xpath);
    }


    // This method returns the value of one XML element in webservice response. 
    // The two xpath in the argument list identify the XML element.    
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>Introduction to SaleForce</title>
    //          <price>$10</price>
    //       </book>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$30</price>
    //       </book>
    //    </books>
    // </root>
    //
    // If you pass in "/root/books/book/available/language" and "/0/0/1/0/1", this method returns "Spanish".
    
    global String retrieveElement(String xpath, String indexpath) {
        String temp = generateMapKey(xpath, indexpath);
        
        return (EMPTY_String.equals(temp)) ? EMPTY_String : container.get(temp);
    }


    // This method returns multiple values in xml elements in webservice response. These xml elements are 
    // identified by a list of xpath expressions as the argument in its signature. 
    //
    // <root>
    //    <firstbook>
    //       <title>APEX Developer Guide</title>
    //       <price>$10</price>
    //    </firstbook>
    //    <secondbook>
    //       <title>VisualForce Developer Guide</title>
    //       <price>$20</price>
    //    </secondbook>
    // </root>
    //
    // if you pass in a list consistin of "/root/firstbook/title" and "/root/secondbook/title", this 
    // method returns a Map object with two name-value pairs: 
    //      "/root/firstbook/title" --> "APEX Developer Guide"
    //      "/root/secondbook/title" --> "VisualForce Developer Guide"
    //
    // DON'T use this method if any element in the xpath string is a memebr of colloction. 
    
    global Map<String, String> retrieveElements(List<String> xpaths) {
        Map<String, String> values = new Map<String, String>();
        
        for (String variable: xpaths){
            String s = container.get(variable);
            if (null != s)
                values.put(variable, s);
        }
        
        return values;
    }
    

    // This method returns the number of sibling xml elements at a level in webservice response. 
    // You can pass in a xpath to identify the level or location.  
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$10</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //          </available>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in a xpath value "/root/books", this method returns 1.
    // if you pass in a xpath value "/root/books/book", this method returns 2.
    //
    // DON'T use this method if any element, other than the last one, in the xpath string is 
    // a memebr of colloction. For Example, this method always returns 3 if you pass in the
    // string of "/root/books/book/available/language"
    
    global Integer getNumberOfSiblings(String xpath) {
        return getNumberOfSiblings(xpath, null);
    }
    
    
    // This method returns the number of sibling xml elements at a location in webservice response. 
    // You need to pass in two xpath strings to identify the location.  
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$10</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //          </available>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in "/root/books/book/available/language" and "/0/0/0/0/0", this method returns 3.
    // if you pass in "/root/books/book/available/language" and "/0/0/0/0/1", this method returns 3.
    // if you pass in "/root/books/book/available/language" and "/0/0/1/0/0", this method returns 2.

    global Integer getNumberOfSiblings(String xpath, String indexpath) {
        String temp = generateKeyToCollectionMember(xpath, indexpath);
        
        if (EMPTY_String.equals(temp)) return -1;
        
        return null == metadata.get(temp)? 0 : metadata.get(temp) + 1;
    }
    


    // This method returns the values of immediate children of one XML element in webservice response. 
    // The two xpath in the argument list identify the XML element.    
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>Introduction to SaleForce</title>
    //          <price>$10</price>
    //       </book>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$30</price>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in "/root/books/book" and "/0/0/1", this method returns a Map with two name-value pairs: 
    //      "/title" --> "APEX Developer Guide"
    //      "/price" --> "$20"

    global Map<String, String> retrieveImmediateValuesInCollection(String xpath, String indexpath) {
        return retrieveValuesInCollection(xpath, indexpath, SLASH);
    }



    // This method returns the values of all children, with unique names, of a XML element in 
    // webservice response. The two xpath expressions in the argument list identify the XML element.    
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>Introduction to SaleForce</title>
    //          <price>$10</price>
    //       </book>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //          <publisher>
    //             <name>salesforce.com</name>
    //          </publisher>    
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$30</price>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in "/root/books/book" and "/0/0/1", this method returns a Map with three name-value pairs: 
    //      "/title" --> "APEX Developer Guide"
    //      "/price" --> "$20"
    //      "/publisher/name" --> "salesforce.com"
    
    global Map<String, String> retrieveUniqueValuesInCollection(String xpath, String indexpath) {
        return retrieveValuesInCollection(xpath, indexpath, DOUBLE_UNDERSCORES);
    }
    
    // This method returns the values of all children of a XML element in webservice response. 
    // The two xpath expressions in the argument list identify the XML element.    
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>Introduction to SaleForce</title>
    //          <price>$10</price>
    //       </book>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //          <publisher>
    //             <name>salesforce.com</name>
    //          </publisher>    
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$30</price>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in "/root/books/book" and "/0/0/1", this method returns a Map with three name-value pairs: 
    //      "/title" --> "APEX Developer Guide"
    //      "/price" --> "$20"
    //      "/available/language" --> "English"
    //      "/available/language__1" --> "Spanish"
    //      "/available/language__2" --> "Chinese"
    //      "/publisher/name" --> "salesforce.com"

    global Map<String, String> retrieveAllValuesInCollection(String xpath, String indexpath) {
        return retrieveValuesInCollection(xpath, indexpath, ' ');
    }

    // This method returns the values of all siblings of a XML element in webservice response. 
    // The two xpath expressions in the argument list identify the XML element.    
    //
    // <root>
    //    <books>
    //       <book>
    //          <title>Introduction to SaleForce</title>
    //          <price>$10</price>
    //       </book>
    //       <book>
    //          <title>APEX Developer Guide</title>
    //          <price>$20</price>
    //          <available>
    //             <language>English</language>
    //             <language>Spanish</language>
    //             <language>Chinese</language>
    //          </available>
    //          <publisher>
    //             <name>salesforce.com</name>
    //          </publisher>    
    //       </book>
    //       <book>
    //          <title>VisualForce Developer Guide</title>
    //          <price>$30</price>
    //       </book>
    //    </books>
    // </root>
    //
    // if you pass in "/root/books/book/available/language" and "/0/0/1/0/1", this method returns a list of stringd: 
    //      "English"
    //      "Spanish"
    //      "Chinese"

    global List<String> retrieveValuesFromSiblings(String xpath, String indexpath) {
        String temp = generateKeyToCollectionMember(xpath, indexpath);
            
        if (null == metadata.get(temp)) return EMPTY_LIST;  
        
        Integer total = metadata.get(temp) + 1;        
        
        List<String> l = new List<String>();        
        l.add(container.get(temp));
        
        for (Integer index = 1; index < total; index ++) {
            l.add(container.get(temp + DOUBLE_UNDERSCORES + index));
        }
        
        return l;
    }    
    
        
    global SObject createNewSObject(String name, Map<String, String> mappings) {    
        return createNewSObject(name, mappings, null);
    }
    
    global SObject createNewSObject(String name, Map<String, String> mappings, List<String> defaults) {    
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(name);
        if (targetType == null) {
            return null;    
        }
        
        SObject obj = targetType.newSObject();
        
        populateFields(obj, mappings, defaults);
    
        return obj; 
    }
    
    global virtual SObject[] createNewSObjects(String name, String rootPath, String indexPath, Map<String, String> mappings) {   
        return createNewSObjects(name, rootPath, indexPath, mappings, null);        
    }
    
    global virtual SObject[] createNewSObjects(String name, String rootPath, String indexPath, Map<String, String> mappings, List<String> defaults) {   
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(name);
        if (targetType == null) {
            return null;    
        }
                
        String accRootPath = generateMapKey(rootPath, indexPath);
        
        if (accRootPath == null || accRootPath == '') return null;
        
        List<SObject> myList = new List<SObject>();
        
        SObject obj = targetType.newSObject();
        
        populateFields(obj, accRootPath, mappings, defaults);
        
        myList.add(obj);
        
        Integer i = getNumberOfSiblings(accRootPath);
        
        for(Integer ind = 1; ind < i; ind ++) {
            obj = targetType.newSObject();        
            populateFields(obj, accRootPath+DOUBLE_UNDERSCORES+ind, mappings, defaults);
            
            myList.add(obj);
        }
    
        return myList; 
    }    
    
    protected void populateFields(SObject s, String rootPath, Map<String, String> mappings, List<String> defaults) {
      Map<String, Schema.SObjectField> m = s.getSobjectType().getDescribe().fields.getMap();
      
      if (null != defaults && !defaults.isEmpty()) {
        for (String variable : defaults) {
          if (m.get(variable).getDescribe().getSOAPType() == SOAPType.String) {
            s.put(variable, '');      
          } else 
            s.put(variable, null);
        }
      }
      
      for (String variable : getSortedKeySet(mappings.keySet())) {
        String value = container.get(mappings.get(rootPath + variable));
        System.debug('value ---->' + value +  '  variable ---->'  + variable);
        if (null == value) continue;
        assignAttributeValue(s, m.get(variable).getDescribe().getSOAPType(), variable, value);
       }
    }
    
    global Boolean populateFields(SObject s, Map<String, String> mappings) {      
      return populateFields(s, mappings, null);
    }

    global Boolean populateFields(SObject s, Map<String, String> mappings, List<String> defaults) {
      Map<String, Schema.SObjectField> m = s.getSobjectType().getDescribe().fields.getMap();
      
      if (null != defaults && !defaults.isEmpty()) {
        for (String variable : defaults) {
          if (m.get(variable).getDescribe().getSOAPType() == SOAPType.String) {
            s.put(variable, '');      
          } else 
            s.put(variable, null);
        }
      }
      
      for (String variable : getSortedKeySet(mappings.keySet())) {
        String value = container.get(mappings.get(variable));
        System.debug('value ---->' + value +  '  variable ---->'  + variable);
        if (null == value) continue;
        assignAttributeValue(s, m.get(variable).getDescribe().getSOAPType(), variable, value);
       }
      
      return true;
    }
    
    global String buildStringFromCollection(String xpath, String indexpath, String delimiter) {
      String retString = EMPTY_STRING;
      String s = generateMapKey(xpath, indexpath);
      
      Integer i = s.indexOf('__*');
      
      if (i > 0) {
        String tempKey = s.substring(0, i);
        i = getNumberOfSiblings(tempKey);
        
        String key = s.replace('__*', EMPTY_STRING);
        retString = container.get(key);
        
        if (i > 1) {
          for (Integer ind = 1; ind < i; ind++) {
            key = s.replace('*', EMPTY_STRING + ind);
            String v = container.get(key);
            if (null != v && !v.equals(EMPTY_STRING))
              retString = retString + delimiter + container.get(key);
          }
        }
      }
      
      return retString;
    }
    
    private void assignAttributeValue(SObject s, SOAPType fieldType, String fieldName, String fieldValue) {     
        if (fieldType == SOAPType.Boolean) {
          s.put(fieldName, ('true'.equals(fieldValue) | 'T'.equals(fieldValue)) );
          return;
        }
        
        if (fieldType == SOAPType.Integer) {
          s.put(fieldName, Integer.valueof(fieldValue));
          return;
        }
        
        if (fieldType == SOAPType.Double) {
          s.put(fieldName, Decimal.valueof(fieldValue));
          return;
        }
              
        if (fieldType == SOAPType.String) {
            s.put(fieldName, fieldValue);   
            return;   
        }   
        
        if (fieldType == SOAPType.DateTime) {
            s.put(fieldName, DateTime.valueof(fieldValue));
            return;
        }
        
        if (fieldType == SOAPType.Date) {
            s.put(fieldName, Date.valueof(fieldValue));
            return;
        }
    }
    
        
    protected List<String> getSortedKeySet(Set<String> keys) {
        List <String> keySet = new List<string>();
        keyset.addAll(keys);
        keySet.sort();
        
        return keySet;      
    }
    
    protected String generateMapKey(String xpath, String indexpath) {
      if (null == indexpath) return xpath;
        
        String[] xpathElements = xpath.split(SLASH);
        String[] indexElements = indexpath.split(SLASH);
        
        if (xpathElements.size() != indexElements.size()) {
          System.debug(Logginglevel.INFO, 'xpath (' + xpath + ') vs. indexpath (' + indexpath + ') ');
          return EMPTY_STRING;
        }
        
        String s = EMPTY_STRING;
        
        for(Integer i = 1; i<xpathElements.size(); i++) {
            s = s + SLASH + xpathElements[i] + ('0'.equals(indexElements[i])? EMPTY_STRING : DOUBLE_UNDERSCORES + indexElements[i]);
        }
        
        System.debug('Combined xpath: ' + s);
        
        return s;
    }

  
    protected Map<String, String> retrieveValuesInCollection(String xpath, String indexpath, String delimiter) {
        String key = generateMapKey(xpath, indexpath);
        
        if (EMPTY_String.equals(key)) return NO_DATA;
        
        key = key + SLASH;
        
        Map<String, String> values = new Map<String, String>();
        
        for (String variable : getSortedKeySet(container.keySet())) {
                if(variable.startsWith(key)) {
                    String temp = variable.substring(key.length());
                    
                    if (!temp.contains(delimiter)) 
                        values.put(SLASH + temp, container.get(variable));
                        
                    if (DOUBLE_UNDERSCORES.equals(delimiter)) {
                        Integer i = temp.indexOf(DOUBLE_UNDERSCORES);
                        
                        if (i > 0) {
                          String r = temp.subString(i);
                          Integer ind = r.indexof(SLASH);
                          
                          if (ind > 0)
                              r = r.subString(ind);
                          else 
                              r = '';
                          
                          values.remove(SLASH + temp.substring(0, i) + r);
                        }
                    }    
                }
        }       
        
        return values;
    }
    
    protected String generateKeyToCollectionMember(String xpath, String indexpath) {
        String temp = generateMapKey(xpath, indexpath);
                
        if (temp.lastIndexOf(SLASH) < temp.lastIndexOf(DOUBLE_UNDERSCORES))
            temp = temp.substring(0, temp.lastIndexOf(DOUBLE_UNDERSCORES));
            
        return temp;    
    }
}
