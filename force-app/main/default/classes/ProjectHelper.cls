public with sharing class ProjectHelper {
    public static void run(Map<Id,Project__c> oldMap, Map<Id, Project__c> newMap ) {
        for (Project__c proj : oldMap.values()) {
            if(proj.Status__c != newMap.get(proj.Id).Status__c){
                //callout
                BillingCalloutService.callBillingService(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
            }
        }
        
    }
}
