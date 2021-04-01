/**
 * Created by BRITENET on 31.03.2021.
 */

global class ProjectCalloutService {

    @InvocableMethod
    public static void  PostOpportunityToPMS(List <Id> opportunitiesIds) {


       List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE Id  in :opportunitiesIds];

        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        for (Opportunity opp : opportunities) {

            List<Account> accounts =  [SELECT Name FROM Account WHERE Id =: opp.AccountId];

            generator.writeStartObject();
            generator.writeStringField('opportunityId', opp.Id);
            generator.writeStringField('opportunityName', opp.Name);
            generator.writeStringField('accountName', accounts.get(0).Name);
            generator.writeStringField('closeDate', String.valueOf(opp.CloseDate));
            generator.writeNumberField('amount', opp.Amount);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        String generatedJSON = generator.getAsString();

        String token =ServiceTokens__c.getValues('ProjectServiceToken').Token__c;

        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint('callout:ProjectService');
        updateRequest.setMethod('POST');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('token', token);
        updateRequest.setBody(JSON.serialize(generatedJSON));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);

    }

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{
        List<Id> opportunityIds {get;set;}
        public QueueablePMSCall(List<Id> opportunityIds){
            this.opportunityIds = opportunityIds;
        }
        public void execute(System.QueueableContext context){
            PostOpportunityToPMS(opportunityIds);
        }

    }

}