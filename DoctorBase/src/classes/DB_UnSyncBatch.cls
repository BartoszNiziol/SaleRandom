/**
 * Created by BRITENET on 30.03.2021.
 */

public with sharing class DB_UnSyncBatch implements Database.Batchable<Doctor__c>, Database.Stateful, Database.AllowsCallouts {
    List <DB_BatchLogWrapper> logInfos = new List<DB_BatchLogWrapper>();
    String authorization;
    public Iterable<Doctor__c> start(Database.BatchableContext bc) {
        List<Doctor__c> preparedDoctors = new List<Doctor__c>();
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        preparedDoctors = [
                SELECT Id,Doctor_External_Id__c
                FROM Doctor__c
                WHERE is_Synchronized__c = false AND Batch_Counter__c < 3
                ALL ROWS
        ];
        return preparedDoctors;
    }

    public static void execute(Database.BatchableContext bc, List<Doctor__c> records) {

        for (Doctor__c doc : records) {
            List<Doctor__c> doctors = new List<Doctor__c>();
            doctors.add(doc);
            String body = JSON.serialize(doctors);
            DB_DoctorHandler.synchronizationCheckToSecondOrg(body);

            //  logInfos.add(new HD_BatchLogWrapper(log.Created_Record_Id__c, log.Object_type__c, log.Status__c, log.Endpoint__c, log.Response_Status_Code__c, log.Create_Date__c));
        }
    }

    public void finish(Database.BatchableContext bc) {
//        System.debug('at finish');
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
//
//        String body = 'The batch Apex job processed ' + a.TotalJobItems +
//                ' batches with ' + a.NumberOfErrors + ' failures.' + 'HospitalDoctor \n';
//        for (HD_BatchLogWrapper wrap : logInfos) {
//            body += 'For Record: ' + wrap.objectType + ' ' + wrap.recordId + ' Status:  ' + wrap.status + ' ' + wrap.statusCode + ' For: ' + wrap.endpoint + ' Log created at: ' + wrap.logCreationDate + '\n';
//        }
//
//        mail.setPlainTextBody(body);
//        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
//                mail
//        });
//
//        System.debug(body);
    }


}