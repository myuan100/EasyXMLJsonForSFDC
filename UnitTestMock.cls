global class UnitTestMock {
  
  private HttpCalloutMock myMock = null;
  
  global UnitTestMock(HttpCalloutMock m) {
      myMock = m;
  }
    
  global void prepareForTesting() {
      if (null != myMock)
            Test.setMock(HttpCalloutMock.class, myMock);
  }
}
