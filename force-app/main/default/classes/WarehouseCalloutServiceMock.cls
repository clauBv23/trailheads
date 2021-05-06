@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf74e","replacement":false,"quantity":10,"name":"UPS 1000 VA","maintenanceperiod":180,"lifespan":48,"cost":1000,"sku":"100016"}]');
        response.setStatusCode(200);
        return response; 
    }
}
