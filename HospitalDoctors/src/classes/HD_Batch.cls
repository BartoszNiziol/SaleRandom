/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class HD_Batch implements Database.Batchable<Logger__c>, Database.Stateful, Database.AllowsCallouts {

    String authorization;
    public Iterable<Logger__c> start(Database.BatchableContext bc) {
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;

        List<Logger__c> logs = [
                SELECT Id,Created_Record_Id__c,Batch_Counter__c,Create_Date__c,IsSynchronized__c,Status__c,Response_Status_Code__c,Created_Record_External_ID__c, Request_Body__c,Response_Body__c,Endpoint__c,Method_Type__c,Object_type__c
                FROM Logger__c
                ORDER BY Create_Date__c DESC
        ];

        Map<String, Logger__c> recordIdToLoggerMap = new Map<String, Logger__c>();

        for (Logger__c log : logs) {
            if (!recordIdToLoggerMap.containsKey(log.Created_Record_Id__c)) {
                recordIdToLoggerMap.put(log.Created_Record_Id__c, log);
            }
        }

        List<String> idToRemove = new List<String>();
        for (String mapKey : recordIdToLoggerMap.keySet()) {
            if (recordIdToLoggerMap.get(mapKey).IsSynchronized__c) {
                idToRemove.add(mapKey);
            }
        }
        for (String id : idToRemove) {
            recordIdToLoggerMap.remove(id);
        }

        List<Logger__c> preparedLoggers = new List<Logger__c>();
        for (String mapKey : recordIdToLoggerMap.keySet() ){
            preparedLoggers.add(recordIdToLoggerMap.get(mapKey));
        }

        return preparedLoggers;
    }

    public void execute(Database.BatchableContext bc, List<Logger__c> records) {
        Boolean done = false;
        for (Logger__c log : records) {
            if (log.Batch_Counter__c < 3) {
                if (log.Object_type__c == 'Doctor__c') {
                    if (log.Method_Type__c == 'Upsert') {
                        done = HD_DoctorHandler.upsertDoctorToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    } else {
                        done = HD_DoctorHandler.deleteDoctorFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    }
                } else {
                    if (log.Method_Type__c == 'Upsert') {
                        done = HD_HospitalHandler.upsertHospitalToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    } else {
                        done = HD_HospitalHandler.deleteHospitalFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [
                SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                        TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id = :bc.getJobId()
        ];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{
                'bartosz.niziol@britenet.com.pl'
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                ' batches with ' + a.NumberOfErrors + ' failures.' + 'HospitalDoctor');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                mail
        });
    }
}