@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here

  @testSetup static void setup() {
      Opportunity opp = new Opportunity(
              Name = 'OpportunityName',
              StageName = 'Prospecting',
              CloseDate = Date.today().addYears(1)
      );
      insert opp;

      Project__c project = new Project__c();
      project.ProjectRef__c = '1234';
      project.Opportunity__c = opp.Id;
      project.Billable_Amount__c = 100;
      project.Status__c = 'Running';
      insert project;

      ServiceCredentials__c sc = new ServiceCredentials__c();
      sc.name = 'BillingServiceCredential';
      sc.Username__c = 'username';
      sc.Password__c = 'password';
      insert sc;
  }

  @isTest private static void testSuccess() {
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

      Test.startTest();
      Project__c proj = [SELECT Id, Status__c FROM Project__c WHERE ProjectRef__c =: '1234'];
      proj.Status__c = 'Billable';
      update proj;
      Test.stopTest();

      Project__c project = [SELECT Status__c FROM Project__c WHERE ProjectRef__c =: '1234'];
      System.assertEquals('Billed', project.Status__c);
  }
}