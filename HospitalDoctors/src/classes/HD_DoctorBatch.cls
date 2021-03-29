/**
 * Created by BRITENET on 29.03.2021.
 */

public with sharing class HD_DoctorBatch implements Database.Batchable<Doctor__c>, Database.Stateful, Database.AllowsCallouts {
    List <HD_BatchLogWrapper> logInfos = new List<HD_BatchLogWrapper>();
    String authorization;
    public Iterable<Doctor__c> start(Database.BatchableContext bc) {
        List<Doctor__c> preparedDoctors = new List<Doctor__c>();
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        preparedDoctors = [
                SELECT Id,Country__c,IsDeleted,Name,City__c,is_Synchronized__c,Street__c,Email__c,License_Number__c
                        ,Birthday_Date__c,Batch_Counter__c,First_Name__c,Doctor_External_Id__c
                FROM Doctor__c
                WHERE is_Synchronized__c = false AND Batch_Counter__c < 3
                ALL ROWS
        ];
        System.debug('preparedDoctors in starrt');
        System.debug(preparedDoctors);
        return preparedDoctors;
    }

    public void execute(Database.BatchableContext bc, List<Doctor__c> records) {

        System.debug(records);
        System.debug('records');

        for (Doctor__c doc : records) {
            List<Doctor__c> doctors = new List<Doctor__c>();
            doctors.add(doc);
            String body = JSON.serialize(doctors);
            if (doc.isDeleted == false) {
                HD_DoctorHandler.upsertDoctorToExternalDB(body, Doctor__c.getSObjectType(), doc.Batch_Counter__c, true);
            } else {
                HD_DoctorHandler.deleteDoctorFromExternalDB(body, Doctor__c.getSObjectType(), doc.Batch_Counter__c, true);
            }

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