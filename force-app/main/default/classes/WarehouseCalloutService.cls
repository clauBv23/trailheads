public class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    private class Product{
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Integer cost;
        String sku;
    }

    public void execute(QueueableContext context) {
        System.debug('excec');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.142830517.1245583649.1619798612-1941109483.1610589604');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            System.debug(response.getBody());
            List<Product> result = (List<Product>)JSON.deserialize(response.getBody(), List<Product>.class);

            System.debug(result);
            Map<String,Product2> equipmentToUpsert = new Map<String,Product2>();
            List<String> extIds = new List<String>();
            for (Product e : result) {
                Product2 tmp = new Product2();
                tmp.Replacement_Part__c =true;
                tmp.Cost__c = e.cost;
                tmp.Current_Inventory__c = e.quantity;
                tmp.Lifespan_Months__c = e.lifespan;
                tmp.Maintenance_Cycle__c = e.maintenanceperiod;
                tmp.Name = e.name;
                tmp.ExternalId = e.sku;
                extIds.add(e.sku);
                equipmentToUpsert.put(e.sku,tmp);
                System.debug(tmp);
            }
            List<Product2> existingProducts = [SELECT Id, ExternalId FROM Product2 WHERE ExternalId IN :extIds];
            for (Product2 p : existingProducts) {
                equipmentToUpsert.get(p.ExternalId).Id = p.Id;
                System.debug(p);
            }
            upsert equipmentToUpsert.values();
        }
        // return retResponse;
    }
}
