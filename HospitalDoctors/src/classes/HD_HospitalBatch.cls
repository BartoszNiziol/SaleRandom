/**
 * Created by BRITENET on 30.03.2021.
 */

public with sharing class HD_HospitalBatch  implements Database.Batchable<Hospital__c>, Database.Stateful, Database.AllowsCallouts {
    List <Hospital__c> logInfos = new List<Hospital__c>();
    String authorization;
    public Iterable<Hospital__c> start(Database.BatchableContext bc) {
        List<Hospital__c> preparedHospitals = new List<Hospital__c>();
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        preparedHospitals = [
                SELECT Id,Country__c,IsDeleted,Name,City__c,is_Synchronized__c,Street__c,Email__c,Phone_Number__c,Web_Page__c,
                       Batch_Counter__c,Hospital_External_Id__c
                FROM Hospital__c
                WHERE is_Synchronized__c = false AND Batch_Counter__c < 3
                ALL ROWS
        ];
        return preparedHospitals;
    }

    public void execute(Database.BatchableContext bc, List<Hospital__c> records) {


        for (Hospital__c hosp : records) {
            List<Hospital__c> hospitals = new List<Hospital__c>();
            hospitals.add(hosp);
            String body = JSON.serialize(hospitals);
            if (hosp.isDeleted == false) {
                HD_HospitalHandler.upsertHospitalToExternalDB(body, Doctor__c.getSObjectType(), hosp.Batch_Counter__c, true,false);
            } else {
                HD_HospitalHandler.deleteHospitalFromExternalDB(body, Doctor__c.getSObjectType(), hosp.Batch_Counter__c, true);
            }
            logInfos.add(hosp);
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('at finish');
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
        for (Hospital__c hosp : logInfos) {
            body += 'For record: ' + hosp.Id +' '+ hosp.Name+ ' Synchronization : '+ hosp.is_Synchronized__c +' Batch try:  '+hosp.Batch_Counter__c;
        }

        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                mail
        });

        System.debug(body);
    }


}