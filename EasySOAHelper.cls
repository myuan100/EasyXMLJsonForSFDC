global class EasySOAHelper {
    global static map<string, string> getMappingRules(string customSetting){
        Map<String, String> mapXpath = new Map<String, String> ();
    
    String soql = 'select name, xpath__c from ' + customSetting;    
    List<sObject> listsObjects = Database.query(soql);

    
        for (sObject sObj : listsObjects){        
            mapXpath.put((string)sObj.get('name'), (string)sObj.get('Xpath__c'));
          } 

        return mapXpath;
    }

     global static string getRequestXML(string payLoad, map<string, string> keyValues){
      String temp = payload;
      
      for(string key : keyValues.keyset()){
          if (temp.contains(key)){
            temp = temp.replace(key, keyValues.get(key));
          }
      }
      
      return temp;
   }   
}
