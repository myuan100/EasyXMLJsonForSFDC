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
private class TestJSONResponse {
  static EasySOAResponse getMockObject() {
        new UnitTestMock(new JSONResponseMock()).prepareForTesting();

        // Test.setMock(HttpCalloutMock.class, new WSResponseMock());
      
        JSONRequest req = new JSONRequest();
        return req.callout(false);
  }
  
  static EasySOAResponse getMockObject2() {
        new UnitTestMock(new JSONResponseMock()).prepareForTesting();

        // Test.setMock(HttpCalloutMock.class, new WSResponseMock());
      
        JSONRequest req = new JSONRequest();
        return req.callout();
  }
  
  static testMethod void retrieveElement() {
      EasySOAResponse resp = getMockObject2();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/invoiceList/totalPrice'), '5.5');
      System.assertEquals(resp.getErrorMsg('/error'), null);
    }
  
  static testMethod void retrieveElement2() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/invoiceList/totalPrice', '/1/0'), '11.5');
    }

    static testMethod void retrieveElements() {
      EasySOAResponse resp = getMockObject();  
      
      List<String> l = new List<String>();
      l.add('/invoiceList/totalPrice');
      l.add('/invoiceList/invoiceNumber');
    
      Map<String, String> m = new Map<String, String>();
      m.put('/invoiceList/totalPrice', '5.5');
      m.put('/invoiceList/invoiceNumber', '1');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElements(l), m);
    }
    
    static testMethod void getNumberOfSiblings() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/invoiceList'), 2);      
      System.assertEquals(resp.getNumberOfSiblings('/invoiceList/lineItems'), 2);      
    }
    
    static testMethod void getNumberOfSiblings2() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/invoiceList/lineItems', '/1/0'), 3);      
      System.assertEquals(resp.getNumberOfSiblings('/invoiceList/lineItems', '/1/2'), 3);      
    }
    
    static testMethod void retrieveImmediateValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/totalPrice', '11.5');
      m.put('/statementDate', '2011-10-04 16:58:54');
      m.put('/invoiceNumber', '2');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveImmediateValuesInCollection('/invoiceList', '/1'), m);
    }  
    
    static testMethod void retrieveUniqueValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/totalPrice', '11.5');
      m.put('/statementDate', '2011-10-04 16:58:54');
      m.put('/invoiceNumber', '2');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveUniqueValuesInCollection('/invoiceList', '/1'), m);
    }      

    static testMethod void retrieveAllValuesInCollection() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
      m.put('/UnitPrice', '0.5');
      m.put('/Quantity', '1.0');
      m.put('/ProductName', 'Eraser');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveAllValuesInCollection('/invoiceList/lineItems', '/0/1'), m);
    }

    static testMethod void testUnmatchedPaths() {
      EasySOAResponse resp = getMockObject();
    
      Map<String, String> m = new Map<String, String>();
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveAllValuesInCollection('/invoiceList', '/0/1'), m);
    }

    static testMethod void retrieveValuesFromSiblings() {
      EasySOAResponse resp = getMockObject();
    
      List<String> l = new List<String>();
      l.add('0.5');
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveValuesFromSiblings('/invoiceList/lineItems/UnitPrice', '/0/1/0'), l);
    }

    static testMethod void debugAndLog() {
      EasySOAResponse resp = getMockObject();
      
      System.assertEquals(resp.isValid(), true);
    
      System.assertEquals(resp.debugAndLog(), true);
    } 
    
    static testMethod void buildStringFromCollection() {
        EasySOAResponse resp = getMockObject();
        
        System.assertEquals(resp.isValid(), true);
        System.assertEquals(resp.getErrorMsg('/path'), null);
        System.assertEquals(resp.buildStringFromCollection('/invoiceList/lineItems/ProductName', '/1/*/0', ':'), 'Notebook:Ruler:Pen');
    } 
    
    static testMethod void createNewSObject() {
        Test.startTest();
        
        EasySOAResponse resp = getMockObject();
        Map<String, String> m = new Map<String, String>();
        m.put('InvoiceNumber__c', '/invoiceList/invoiceNumber');
        m.put('TotalPrice__c', '/invoiceList/totalPrice');
        m.put('StatementDate__c', '/invoiceList/statementDate');
        
        System.assertEquals(resp.isValid(), true);
        LVT__Invoice__c book = (LVT__Invoice__c)resp.createNewSObject('LVT__Invoice__c', m);
        
        upsert book;
        System.assertEquals(book.InvoiceNumber__c, '1');
       
        Test.stopTest();
    }
    
    
    static testMethod void createNewSObject2() {
        Test.startTest();
        
        EasySOAResponse resp = getMockObject();
        Map<String, String> m = new Map<String, String>();
        m.put('InvoiceNumber__c', '/invoiceList/invoiceNumber');
        m.put('TotalPrice__c', '/invoiceList/totalPrice');
        m.put('StatementDate__c', '/invoiceList/statementDate');
        
        List<String> l = new List<String>();
        l.add('Description__c');
   
        System.assertEquals(resp.isValid(), true);
        LVT__Invoice__c book = (LVT__Invoice__c)resp.createNewSObject('LVT__Invoice__c', m, l);
        
        upsert book;
        System.assertEquals(book.InvoiceNumber__c, '1');
        Test.stopTest();
    }    
    
    static testMethod void populateFields() {
        EasySOAResponse resp = getMockObject();
        
        List<LVT__InvoiceMappingRules__c> l = new List<LVT__InvoiceMappingRules__c>();
        l.add(new LVT__InvoiceMappingRules__c(name='InvoiceNumber__c', Xpath__c='/invoiceList/invoiceNumber')); 
        l.add(new LVT__InvoiceMappingRules__c(name='TotalPrice__c', Xpath__c='/invoiceList/totalPrice'));
        l.add(new LVT__InvoiceMappingRules__c(name='StatementDate__c', Xpath__c='/invoiceList/statementDate'));
        upsert(l);
        
        Map<String, String> m = EasySOAHelper.getMappingRules('LVT__InvoiceMappingRules__c');
        
        System.assertEquals(resp.isValid(), true);
        LVT__Invoice__c invoice = new LVT__Invoice__c();
        
        resp.populateFields(invoice, m);
        
        System.assertEquals(invoice.InvoiceNumber__c, '1');
    }
    
    static testMethod void populateFields2() {
        EasySOAResponse resp = getMockObject();
        
        List<LVT__InvoiceMappingRules__c> l = new List<LVT__InvoiceMappingRules__c>();
        l.add(new LVT__InvoiceMappingRules__c(name='InvoiceNumber__c', Xpath__c='/invoiceList/invoiceNumber')); 
        l.add(new LVT__InvoiceMappingRules__c(name='TotalPrice__c', Xpath__c='/invoiceList/totalPrice'));
        l.add(new LVT__InvoiceMappingRules__c(name='StatementDate__c', Xpath__c='/invoiceList/statementDate'));
        upsert(l);
        
        Map<String, String> m = EasySOAHelper.getMappingRules('LVT__InvoiceMappingRules__c');
        
        System.assertEquals(resp.isValid(), true);
        LVT__Invoice__c invoice = new LVT__Invoice__c();
        
        List<String> l2 = new List<String>();
        l2.add('Description__c');
        
        
        resp.populateFields(invoice, m, l2);
        
        System.assertEquals(invoice.InvoiceNumber__c, '1');
    }
}
