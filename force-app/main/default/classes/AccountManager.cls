@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String[] urlSplitted = request.requestURI.split('/');
        System.debug(urlSplitted);

        String accId  = urlSplitted[urlSplitted.size()-2];
        System.debug(accId);
        Account result =  [SELECT Id, Name, (SELECT Id, Name FROM Contacts WHERE AccountId = :accId )
                            FROM Account
                            WHERE Id = :accId];
        return result;
    }

}
