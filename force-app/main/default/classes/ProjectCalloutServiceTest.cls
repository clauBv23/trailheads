@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here

  @testSetup 
    static void makeData(){

      Account acc = new Account();
      acc.Name = 'Test Account';
      insert acc;

      Opportunity opp = new Opportunity();
      opp.Name = 'Super-Duper Big Deal';
      opp.Amount = 150000;
      opp.AccountId = acc.Id;
      opp.Type = 'New Project';
      opp.StageName = 'Prospecting';
      opp.CloseDate = Date.today();
      insert opp;

      ServiceTokens__c token = new ServiceTokens__c();
      token.Name = 'ProjectServiceToken';
      token.Token__c = '9f7b5e9b-c675-4dfd-a7fd-f00bccd7d2f1';
      insert token;

    }

    @isTest 
    static void testExecSuccess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        List<Id> ids = new List<Id>();
        ids.add(opp.Id);
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(ids);
        Test.stopTest();

        String oppStage = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id].StageName;
        System.assertEquals('Submitted Project', oppStage, 'Expected Submited Project stage');
    }

    @isTest 
    static void testExecFailure() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        List<Id> ids = new List<Id>();
        ids.add(opp.Id);
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(ids);
        Test.stopTest();

        String oppStage = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id].StageName;
        System.assertEquals('Resubmit Project', oppStage, 'Expected Resubmit Project stage');
    }
}
