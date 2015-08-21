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
@isTest
private class TestXMLString {
  static testMethod void testInvalidXML() {
      EasyXML resp = new EasyXML(WSResponseMock.invalidString);
      
      System.assertEquals(resp.isValid(), false);
      System.assertEquals(resp.getErrorMsg().substring(resp.getErrorMsg().indexof('Message:')), 'Message: The element type "book" must be terminated by the matching end-tag "</book>".' );
    }
  
  static testMethod void retrieveElement() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/root/firstbook/title'), 'APEX Developer Guide');
      System.assertEquals(resp.getDetails().length(), 2984);
    }
  
    static testMethod void retrieveElement2() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveElement('/root/books/book/available/language', '/0/0/1/0/1'), 'Spanish');
    }

    static testMethod void retrieveElements() {
    EasyXML resp = new EasyXML(WSResponseMock.xmlString);  
      
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
    EasyXML resp = new EasyXML(WSResponseMock.xmlString);
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/root/books'), 1);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book'), 3);      
    }
    
    static testMethod void getNumberOfSiblings2() {
    EasyXML resp = new EasyXML(WSResponseMock.xmlString);
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/0'), 3);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/1'), 3);      
      System.assertEquals(resp.getNumberOfSiblings('/root/books/book/available/language', '/0/0/1/0/0'), 3);      
    }
    
    static testMethod void retrieveImmediateValuesInCollection() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
    Map<String, String> m = new Map<String, String>();
    m.put('/title', 'APEX Developer Guide');
      m.put('/price', '20');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveImmediateValuesInCollection('/root/books/book', '/0/0/1'), m);
    }  
    
    static testMethod void retrieveUniqueValuesInCollection() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
    Map<String, String> m = new Map<String, String>();
    m.put('/title', 'APEX Developer Guide');
      m.put('/price', '20');
      m.put('/publisher/name', 'salesforce.com');
      
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveUniqueValuesInCollection('/root/books/book', '/0/0/1'), m);
    }      

    static testMethod void retrieveAllValuesInCollection() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
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
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
    Map<String, String> m = new Map<String, String>();
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveAllValuesInCollection('/root/books/book', '/0/1'), m);
    }

    static testMethod void retrieveValuesFromSiblings() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
    List<String> l = new List<String>();
    l.add('English');
    l.add('Spanish');
    l.add('Chinese');
    
      System.assertEquals(resp.isValid(), true);
      System.assertEquals(resp.retrieveValuesFromSiblings('/root/books/book/available/language', '/0/0/1/0/1'), l);
    }

    static testMethod void debugAndLog() {
      EasyXML resp = new EasyXML(WSResponseMock.xmlString);
    
      System.assertEquals(resp.debugAndLog(), true);
    }
}
