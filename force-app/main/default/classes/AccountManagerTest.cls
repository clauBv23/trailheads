@isTest
private class AccountManagerTest {
    @testSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'Acc Name';
        insert acc;

        Contact cont1 = new Contact();
        // cont1.Name = 'Cont 1 Name';
        cont1.AccountId = acc.Id;

        Contact cont2 = new Contact();
        // cont2.Name = 'Cont 2 Name';
        cont2.AccountId = acc.Id;

    }
    @isTest static void testGet() {
        Id recordId = [SELECT Id From Account LIMIT 1].Id;
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.salesforce.com/services/apexrest/Accounts/'
            + recordId + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account getAccount = AccountManager.getAccount();
        // Verify results
        System.assert(getAccount != null);
        System.assertEquals('Acc Name', getAccount.Name);
    }
}
