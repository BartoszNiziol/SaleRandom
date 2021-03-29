/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class HD_Batch implements Database.Batchable<Logger__c>, Database.Stateful, Database.AllowsCallouts {
    List <HD_BatchLogWrapper> logInfos = new List<HD_BatchLogWrapper>();
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
        for (String mapKey : recordIdToLoggerMap.keySet()) {
            preparedLoggers.add(recordIdToLoggerMap.get(mapKey));
        }
        return preparedLoggers;
    }

    public void execute(Database.BatchableContext bc, List<Logger__c> records) {

        for (Logger__c log : records) {
            if (log.Batch_Counter__c <= 3) {
                if (log.Object_type__c == 'Doctor__c') {
                    if (log.Method_Type__c == 'Upsert') {
                        HD_DoctorHandler.upsertDoctorToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    } else {
                        HD_DoctorHandler.deleteDoctorFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    }
                } else {
                    if (log.Method_Type__c == 'Upsert') {
                        HD_HospitalHandler.upsertHospitalToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    } else {
                        HD_HospitalHandler.deleteHospitalFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Batch_Counter__c, false);
                    }
                }
            }
            logInfos.add(new HD_BatchLogWrapper(log.Created_Record_Id__c,log.Object_type__c,log.Status__c,log.Endpoint__c,log.Response_Status_Code__c,log.Create_Date__c));
        }
    }

    public void finish(Database.BatchableContext bc) {
//        AsyncApexJob a = [
//                SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
//                        TotalJobItems, CreatedBy.Email
//                FROM AsyncApexJob
//                WHERE Id = :bc.getJobId()
//        ];
//        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
//        String[] toAddresses = new String[]{
//                'bartosz.niziol@britenet.com.pl'
//        };
//        mail.setToAddresses(toAddresses);
//        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
//        String body = 'The batch Apex job processed ' + a.TotalJobItems +
//                ' batches with ' + a.NumberOfErrors + ' failures.' + 'HospitalDoctor \n';
//        for (HD_BatchLogWrapper wrap: logInfos){
//            body+= 'For Record: '+ wrap.objectType+ ' '+ wrap.recordId + ' Status:  '+wrap.status +' '+wrap.statusCode +' For: '+ wrap.endpoint+' Log created at: ' + wrap.logCreationDate+'\n';
//        }
//
//        mail.setPlainTextBody(body);
//        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
//                mail
//        });
    }
}