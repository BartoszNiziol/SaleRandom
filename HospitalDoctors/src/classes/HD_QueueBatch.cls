/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class HD_QueueBatch implements Queueable , Database.AllowsCallouts {
    List<Logger__c> logs {get; set;}
    public  HD_QueueBatch (List<Logger__c> logs){
       this.logs = logs;
    }

    public void execute (QueueableContext context){
        String authorization;
        for (Logger__c log: logs){
            if(log.Batch_Counter__c == null){
                log.Batch_Counter__c = 0;
            }
            if (log.Batch_Counter__c <3) {
                if (log.Object_type__c == 'Doctor__c') {
                    if (log.Method_Type__c == 'Upsert') {

                        if(authorization == null){
                            HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
                            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                                    logHttpResponse.getBody()
                            );
                            String accesToken = (String) params.get('access_token');
                            authorization = 'Bearer ' + accesToken;
                        }
                        String endpointString = HD_Utils.retrieveCredentials('DBDoctorIntegrationEndpoint');
                        HttpRequest upsertRequest = new HttpRequest();
                        upsertRequest.setEndpoint(endpointString);
                        upsertRequest.setMethod('POST');
                        upsertRequest.setHeader('Content-Type', 'application/json');
                        upsertRequest.setHeader('Authorization', authorization);
                        upsertRequest.setBody(log.Request_Body__c);
                        Http upsertHttp = new Http();
                        HttpResponse response = upsertHttp.send(upsertRequest);
                        HD_LoggerHandler.sendLogRequest(log.Object_type__c,log.Endpoint__c,log.Request_Body__c,response,'POST',null,log.Batch_Counter__c);
                        //  ID jobID = System.enqueueJob(new QueueUpsertDoctorToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType()));
                    } else {
                        //         ID jobID = System.enqueueJob(new HD_QueueDeleteDoctorFormExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType()));
                    }
                } else {
                    if (log.Method_Type__c == 'Upsert') {

                        //                    ID jobID = System.enqueueJob(new HD_QueueUpsertHospitalToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType()));
                    } else {

                        //     ID jobID = System.enqueueJob(new HD_QueueDeleteHospitalFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType()));
                    }
                }
            }
        }
    }
    }

