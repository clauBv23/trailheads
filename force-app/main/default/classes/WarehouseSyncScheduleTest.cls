@isTest
public with sharing class WarehouseSyncScheduleTest {
    @isTest
    static void testExec(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 

        Test.startTest();
        WarehouseSyncSchedule schedule = new WarehouseSyncSchedule();
        String sch = '0 0 1 1/1 * ? * ';
        String jobID = System.schedule('Test job', sch, schedule);
        Test.stopTest();

        List<Product2> equips = [SELECT Id FROM Product2];
        System.assertEquals(0, equips.size(), 'Expected 0 product');
    }
}
