/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class HD_Batch implements Database.Batchable<Logger__c>, Database.Stateful, Database.AllowsCallouts {

    String authorization;
    public Iterable<Logger__c> start(Database.BatchableContext bc) {
        List<Logger__c> logs = [SELECT Request_Body__c,Endpoint__c,Method_Type__c,Object_type__c,Batch_Counter__c FROM Logger__c WHERE IsSynchronized__c = false AND isSelectedForBatch__c = true];
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        return logs;
    }
    public void execute(Database.BatchableContext bc, List<Logger__c> records) {
        Boolean done;
        for (Logger__c log : records) {
            System.debug('log.Batch_Counter__c');
            System.debug(log.Batch_Counter__c);
            if (log.Batch_Counter__c < 3) {
                if (log.Object_type__c == 'Doctor__c') {
                    if (log.Method_Type__c == 'Upsert') {
                       done = HD_DoctorHandler.upsertDoctorToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(),log.Batch_Counter__c,false);
                    } else {
                       done =  HD_DoctorHandler.deleteDoctorFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(),log.Batch_Counter__c,false);
                    }
                } else {
                    if (log.Method_Type__c == 'Upsert') {
                      done = HD_HospitalHandler.upsertHospitalToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(),log.Batch_Counter__c,false);
                    } else {
                       done = HD_HospitalHandler.deleteHospitalFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(),log.Batch_Counter__c,false);
                    }
                }
            }
            HD_LoggerHandler.sendLogRequest(null, null, null,null, null,log.Id, null, null,null, !done);
        }
    }

    public void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id = : bc.getJobId()
        ];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
                'bartosz.niziol@britenet.com.pl'
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                ' batches with ' + a.NumberOfErrors + ' failures.'+'KLSMSonBdayBatch');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
        });
    }
}