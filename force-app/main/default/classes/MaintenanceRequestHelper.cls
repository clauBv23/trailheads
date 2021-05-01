public class MaintenanceRequestHelper{
    public static void run(Map<Id,Case> oldMap, Map<Id, Case> newMap ) {
        List<Equipment_Maintenance_Item__c> equipmentsList = [SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c, Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN:newMap.keySet()];
        
        List<Equipment_Maintenance_Item__c> equipsToInsert = new List<Equipment_Maintenance_Item__c>();
        List<Case> caseToInsert = new List<Case>();

        for( Integer i = 0; i< newMap.values().size(); i++ ){
            Case c = newMap.values()[i];
            if(c.Type == 'Repair'|| c.Type == 'Routine Maintenance'){
                System.debug('Type  '+ c.Type);
                // the stats change to closed
                if(c.Status == 'Closed' && oldMap.get(c.Id).Status != 'Closed'){
                    System.debug('CLosed  ' + c.Status + ' old Status' + oldMap.get(c.Id).Status);

                    Case newCase = new Case();
                    newCase.Vehicle__c = c.Vehicle__c;
                    newCase.ProductId = c.ProductId;
                    newCase.Type = 'Routine Maintenance';
                    newCase.Subject = 'Created from ' + c.Id + ' with Subject: ' + c.Subject;
                    newCase.Date_Reported__c = Date.today();
                    List<Equipment_Maintenance_Item__c> equipments = equipmentsList;
                    Decimal minDays = equipments[0].Equipment__r.Maintenance_Cycle__c;
                    for(Equipment_Maintenance_Item__c e : equipments){
                        
                        minDays = e.Equipment__r.Maintenance_Cycle__c < minDays ? e.Equipment__r.Maintenance_Cycle__c: minDays;
                    }
                    newCase.Date_Due__c = Date.today().addDays((Integer)minDays);

                    caseToInsert.add(newCase);
                    System.debug('new Case id   '+ newCase.Id);
                }
            }
        }
        insert caseToInsert;

        // add equipments
        for( Integer i = 0; i< newMap.values().size(); i++ ){
            for (Equipment_Maintenance_Item__c equi: equipmentsList){
                if(equi.Maintenance_Request__c == newMap.values()[i].Id)
                {
                    Equipment_Maintenance_Item__c tmp = new Equipment_Maintenance_Item__c();
                    tmp.Quantity__c = equi.Quantity__c;
                    tmp.Equipment__c = equi.Equipment__c;
                    tmp.Maintenance_Request__c = caseToInsert[i].Id;
                    equipsToInsert.add(tmp);
                }
            }    
        }
        insert equipsToInsert;
    }
}