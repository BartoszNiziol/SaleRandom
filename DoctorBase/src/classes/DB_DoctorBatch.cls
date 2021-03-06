/**
 * Created by BRITENET on 30.03.2021.
 */

public with sharing class DB_DoctorBatch implements Database.Batchable<Doctor__c>, Database.Stateful, Database.AllowsCallouts {
    List <Doctor__c> logInfos = new List<Doctor__c>();
    Boolean success;
    String authorization;

    public Iterable<Doctor__c> start(Database.BatchableContext bc) {
                HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;

        List<Doctor__c> preparedDoctors = new List<Doctor__c>();
        preparedDoctors = [
                SELECT Id,Country__c,IsDeleted,Name,City__c,is_Synchronized__c,Street__c,Email__c,License_Number__c
                        ,Birthday_Date__c,Batch_Counter__c,First_Name__c,Doctor_External_Id__c
                FROM Doctor__c
                WHERE is_Synchronized__c = false AND Batch_Counter__c < 3
                ALL ROWS
        ];

        return preparedDoctors;
    }
    public void execute(Database.BatchableContext bc, List<Doctor__c> records) {

        for (Doctor__c doc : records) {
            List<Doctor__c> doctors = new List<Doctor__c>();
            doctors.add(doc);
            String body = JSON.serialize(doctors);
            if (doc.isDeleted == false) {
                success = DB_DoctorHandler.upsertDoctorToExternalDB(body, Doctor__c.getSObjectType(), doc.Batch_Counter__c, true,authorization);
            } else {
                success = DB_DoctorHandler.deleteDoctorFromExternalDB(body, Doctor__c.getSObjectType(), doc.Batch_Counter__c, true,authorization);
            }

            logInfos.add(doc);
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

        String body = 'The batch Apex job processed ' + a.TotalJobItems +
                ' batches with ' + a.NumberOfErrors + ' failures.' + 'HospitalDoctor \n';
        for (Doctor__c doc : logInfos) {
            body += 'For record: ' + doc.Id + ' ' + doc.First_Name__c + ' ' + doc.Name + ' Synchronization : ' + success + '\n';
        }

        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                mail
        });

    }

}