/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class DB_Batch implements Database.Batchable<Logger__c>, Database.Stateful, Database.AllowsCallouts{
    String authorization;
    public Iterable<Logger__c> start(Database.BatchableContext bc) {
        List<Logger__c> logs = [SELECT Request_Body__c,Endpoint__c,Method_Type__c,Object_type__c,Batch_Counter__c FROM Logger__c WHERE IsSynchronized__c = false];

        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;

        return logs;
    }
    public void execute(Database.BatchableContext bc, List<Logger__c> records){

        for (Logger__c log: records){
            if(log.Batch_Counter__c == null){
                log.Batch_Counter__c = 0;
            }
            if (log.Batch_Counter__c <3) {
                if (log.Object_type__c == 'Doctor__c') {
                    if (log.Method_Type__c == 'Upsert') {
                        log.IsSynchronized__c = DB_DoctorHandler.upsertDoctorToExternalDB(log.Request_Body__c,((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType());
                        log.Batch_Counter__c++;
                    } else {
                        log.IsSynchronized__c = DB_DoctorHandler.deleteDoctorFromExternalDB(log.Request_Body__c,((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType());
                        log.Batch_Counter__c++;
                    }
                } else {
                    if (log.Method_Type__c == 'Upsert') {
                        log.IsSynchronized__c = DB_HospitalHandler.upsertHospitalToExternalDB(log.Request_Body__c,((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType());
                        log.Batch_Counter__c++;
                    } else {
                        log.IsSynchronized__c = DB_HospitalHandler.deleteHospitalFromExternalDB(log.Request_Body__c,((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType());
                        log.Batch_Counter__c++;

                    }
                }
            }
            update log;
        }


    }
    public void finish(Database.BatchableContext bc){
      AsyncApexJob job =  [SELECT JobType FROM AsyncApexJob WHERE Id =: bc.getJobId()];
        System.debug('job');
        System.debug(job);

    }

}