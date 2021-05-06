@isTest
public class WarehouseCalloutServiceTest {

    @testSetup 
    static void makeData(){
        Product2 equip = new Product2();
        equip.Name = 'UPS 1000 VA';
        equip.IsActive = true;
        equip.Cost__c = 1000;
        equip.Current_Inventory__c = 5;
        equip.Lifespan_Months__c = 48;
        equip.Maintenance_Cycle__c = 180;
        equip.Replacement_Part__c = false;
        equip.ExternalId = '100016';

        insert equip;
    }

    @isTest 
    static void testExec() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        
        // WarehouseCalloutService.execute();
        Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();

        List<Product2> equips = [SELECT Id FROM Product2];
        System.assertEquals(2, equips.size(), 'Expected 2 product');
    }
}