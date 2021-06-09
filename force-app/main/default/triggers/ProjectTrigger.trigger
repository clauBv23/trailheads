trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    BillingCalloutService.callBillingService(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

}