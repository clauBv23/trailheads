@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here

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

    Project__c proj = new Project__c();
    proj.Name = 'Test Project ';
    proj.Opportunity__c = opp.Id;
    proj.Billable_Amount__c = 10;
    proj.ProjectRef__c = 'ProjectRef__c test';
    proj.Start_Date__c = Date.today();
    proj.Status__c = 'Billed';
    insert proj;
  }

  @isTest
  static void testRestPost(){

    Test.startTest();
    Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];
    String result =  ProjectRESTService.postProjectData('ProjectRef__c test', 'Test Project New Name', (String) op.Id, Date.today(), Date.today(), (Double) 100, 'Billed');
    Test.stopTest();

    System.debug(result);

    Project__c proj = [SELECT Id, Name FROM Project__c LIMIT 1];
    System.assertEquals('Test Project New Name', proj.Name);
  }

  @isTest
  static void testRestPostCatch(){

    Test.startTest();
    // Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];
    String result =  ProjectRESTService.postProjectData('ProjectRef__c test', 'Test Project New Name', 'None', Date.today(), Date.today(), (Double) 100, 'Billed');
    Test.stopTest();

    System.debug(result);

    Project__c proj = [SELECT Id, Name FROM Project__c LIMIT 1];
    System.assertEquals('Test Project', proj.Name);
  }
  
}