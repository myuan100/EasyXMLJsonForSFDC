/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (seealldata=true)
private class TestSOAResponse {
  static EasySOAResponse getMockObject() {
        new UnitTestMock(new WSResponseMock()).prepareForTesting();

        // Test.setMock(HttpCalloutMock.class, new WSResponseMock());
      
        WSRequest req = new WSRequest();
        return req.callout(true);
  }
  
  static testMethod void testCreatingRequest() {
        WSRequest req = new WSRequest();
        System.assertEquals(req.getPayload(), '<?xml version="1.0" encoding="UTF-8" ?><env:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"><env:Header /><env:Body><request>value</request></env:Body></env:Envelope>');  
  }
  
  static testMethod void testCreatingXML() {
      String s = '<request>VALUE_KEY</request>'; 
      Map <String, String> m = new Map <String, String>();
      m.put('VALUE_KEY', 'realvalue');
      
      System.assertEquals(EasySOAHelper.getRequestXML(s, m), '<request>realvalue</request>');
  }

  static testMethod void testInvalidXML() {
      Test.setMock(HttpCalloutMock.class, new WSResponseMock());
      
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/SOATest/error');
        req.setMethod('GET');
        Http h = new Http();
        
        EasySOAResponse resp = new EasySOAResponse(h.send(req), null, true);
      
      System.assertEquals(resp.isValid(), false);
      System.assertEquals(resp.getErrorMsg('').substring(resp.getErrorMsg('').indexof('Message:')), 'Message: The element type "book" must be terminated by the matching end-tag "</book>".' );
    }
    
    static testMethod void retrieveElement() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/root/firstbook/title'), 'APEX Developer Guide');
    }
  
   static testMethod void retrieveElement2() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/root/books/book/available/language', '/0/0/1/0/1'), 'Spanish');
    }

    static testMethod void retrieveElements() {
      EasySOAResponse resp = getMockObject();  
      
      List<String> l = new List<String>();
      l.add('/root/firstbook/title');
      l.add('/root/secondbook/title');
    
      Map<String, String> m = new Map<String, String>();
      m.put('/root/firstbook/title', 'APEX Developer Guide');
      m.put('/root/secondbook/title', 'VisualForce Developer Guide');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElements(l), m);
    }
    
    static testMethod void getNumberOfSiblings() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/root/books'), 1);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book'), 3);      
    }
    
    static testMethod void getNumberOfSiblings2() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/0'), 3);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/1'), 3);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/0'), 3);      
    }
    
    static testMethod void retrieveImmediateValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/title', 'APEX Developer Guide');
      m.put('/price', '20');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveImmediateValuesInCollection('/root/books/book', '/0/0/1'), m);
    }  
    
    static testMethod void retrieveUniqueValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/title', 'APEX Developer Guide');
      m.put('/price', '20');
      m.put('/publisher/name', 'salesforce.com');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveUniqueValuesInCollection('/root/books/book', '/0/0/1'), m);
    }      

    static testMethod void retrieveAllValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/title', 'APEX Developer Guide');
      m.put('/price', '20');
      m.put('/publisher/name', 'salesforce.com');
      m.put('/available/language', 'English');
      m.put('/available/language__1', 'Spanish');
      m.put('/available/language__2', 'Chinese');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveAllValuesInCollection('/root/books/book', '/0/0/1'), m);
    }

    static testMethod void testUnmatchedPaths() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveAllValuesInCollection('/root/books/book', '/0/1'), m);
    }

    static testMethod void retrieveValuesFromSiblings() {
      EasySOAResponse resp = getMockObject();
    
      List<String> l = new List<String>();
      l.add('English');
      l.add('Spanish');
      l.add('Chinese');
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveValuesFromSiblings('/root/books/book/available/language', '/0/0/1/0/1'), l);
    }

    static testMethod void debugAndLog() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
    
      System.assertEquals(resp.debugAndLog(), true);
    } 
    
    static testMethod void createNewSObject() {
        Test.startTest();
        
        EasySOAResponse resp = getMockObject();
        Map<String, String> m = new Map<String, String>();
        m.put('Name', '/root/firstbook/title');
        m.put('Price__c', '/root/firstbook/price');
        m.put('PublishDate__c', '/root/firstbook/publishdate');
        
        System.assertEquals(resp.isValid(), true);
        Book__c book = (Book__c)resp.createNewSObject('LVT__Book__c', m);
        
        upsert book;
        System.assertEquals(book.name, 'APEX Developer Guide');
        System.assertEquals(book.Price__c, 10);
        
        system.debug(book.PublishDate__c);
        
        Test.stopTest();
    }
    
    static testMethod void createNewSObject2() {
        Test.startTest();
        
        EasySOAResponse resp = getMockObject();
        Map<String, String> m = new Map<String, String>();
        m.put('Name', '/root/firstbook/title');
        m.put('Price__c', '/root/firstbook/price');
        m.put('isInStock__c', '/root/firstbook/instock');
        
        List<String> l = new List<String>();
        l.add('PublishDate__c');
        l.add('Description__c');
   
        System.assertEquals(resp.isValid(), true);
        LVT__Book__c book = (LVT__Book__c)resp.createNewSObject('LVT__Book__c', m, l);
        
        upsert book;
        System.assertEquals(book.name, 'APEX Developer Guide');
        System.assertEquals(book.Price__c, 10);
        System.assertEquals(book.PublishDate__c, null);
        System.assertEquals(book.isInStock__c, true);
        system.debug(book);
        Test.stopTest();
    }    

    static testMethod void createNewSObject3() {
        Test.startTest();
        
        EasySOAResponse resp = getMockObject();
        Map<String, String> m = new Map<String, String>();
        m.put('Name', '/root/firstbook/title');
        m.put('Price__c', '/root/firstbook/price');
        
        System.assertEquals(resp.isValid(), true);
        System.assertEquals(resp.createNewSObject('Book', m), null);
        Test.stopTest();
    }
    
    static testMethod void populateFields() {
        EasySOAResponse resp = getMockObject();
        
        List<LVT__BookMappingRules__c> l = new List<LVT__BookMappingRules__c>();
        l.add(new LVT__BookMappingRules__c(name='Name', Xpath__c='/root/firstbook/title')); 
        l.add(new LVT__BookMappingRules__c(name='Price__c', Xpath__c='/root/firstbook/price'));
        upsert(l);
        
        Map<String, String> m = EasySOAHelper.getMappingRules('LVT__BookMappingRules__c');
        
        System.assertEquals(resp.isValid(), true);
        Book__c book = new Book__c();
        
        resp.populateFields(book, m);
        
        System.assertEquals(book.name, 'APEX Developer Guide');
        System.assertEquals(book.Price__c, 10);
    }
    
  static testMethod void buildStringFromCollection() {
        EasySOAResponse resp = getMockObject();
        
        System.assertEquals(resp.isValid(), true);
        System.assertEquals(resp.getErrorMsg('/path'), null);
        System.assertEquals(resp.buildStringFromCollection('/root/books/book/available/language', '/0/0/1/0/*', ':'), 'English:Spanish:Chinese');
    } 
}
