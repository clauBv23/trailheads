@isTest
public with sharing class MaintenanceRequestHelperTest {
    @testSetup 
    static void makeData(){
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Web';
        c.Type = 'Repair';
        insert c;

        Product2 equip = new Product2();
        equip.Name = 'testequip';
        equip.IsActive = true;
        equip.Cost__c = 10;
        equip.Current_Inventory__c = 5;
        equip.Lifespan_Months__c = 10;
        equip.Maintenance_Cycle__c = 15;
        equip.Replacement_Part__c = true;

        insert equip;

        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
        item.Equipment__c = equip.Id;
        item.Maintenance_Request__c = c.Id;
        item.Quantity__c = 1;
        insert item;
    }

    @isTest
    static void testRun(){
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Closed';
        update c;
        List<Case> cases = [SELECT id FROM Case];
        System.assertEquals(2, cases.size(), 'There must be two cases.');
    }
}
