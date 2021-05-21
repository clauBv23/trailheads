public class ProjectCalloutService {
    //Complete the implementation for business and callout logic

    private class Request{
        Id opportunityId;
        String opportunityName;
        String accountName;
        DateTime closeDate;
        Decimal amount;
    }

    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppList) {
        List<Opportunity> opps = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id IN :oppList];

        for( Opportunity o : opps){
            //create request
            Request reqBody = new Request();
            reqBody.opportunityId = o.Id;
            reqBody.opportunityName = o.Name;
            reqBody.accountName = o.Account.Name;
            reqBody.closeDate = o.CloseDate;
            reqBody.amount = o.Amount;

             String body = JSON.serialize(reqBody);
             System.debug('body ' + body);

             System.enqueueJob(new QueueablePMSCall(body, o));
        }
    }    
   

    private class QueueablePMSCall implements Queueable, Database.AllowsCallouts{
        String jsonBody; 
        Opportunity opp;

        public QueueablePMSCall(String body, Opportunity opp){
            this.jsonBody = body;
            this.opp = opp;
        }

        public void execute(QueueableContext context) {
        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            ServiceTokens__c token= ServiceTokens__c.getValues('ProjectServiceToken');
            System.debug(token.Token__c);
    
            request.setEndpoint('callout:ProjectService/' + token.Token__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    
            request.setBody(this.jsonBody);
            HttpResponse response = http.send(request);
    
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                this.opp.StageName = 'Resubmit Project';

                System.debug('Fail');

            } else {
                this.opp.StageName = 'Submitted Project';

                System.debug('Successfully');
            }
            update this.opp;
        }
    }
}