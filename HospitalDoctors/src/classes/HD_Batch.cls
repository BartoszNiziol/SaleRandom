/**
 * Created by BRITENET on 25.03.2021.
 */

public with sharing class HD_Batch implements Database.Batchable<Logger__c>, Database.Stateful, Database.AllowsCallouts{


    public Iterable<Logger__c> start(Database.BatchableContext bc) {
        List<Logger__c> logs = [SELECT Id,Request_Body__c,Method_Type__c,Object_type__c,Batch_Counter__c FROM Logger__c WHERE Response_Status_Code__c != 200];
        System.debug('logs in start batch');
        System.debug(logs);

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
                            HD_DoctorHandler.upsertDoctorToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Id);
                        } else {
                            HD_DoctorHandler.deleteDoctorFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Id);
                        }
                    } else {
                        if (log.Method_Type__c == 'Upsert') {
                            HD_HospitalHandler.upsertHospitalToExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Id);

                        } else {
                            HD_HospitalHandler.deleteHospitalFromExternalDB(log.Request_Body__c, ((SObject) Type.forName(log.Object_type__c).newInstance()).getSObjectType(), log.Id);
                        }
                    }
                }
                update log;
                if (log.Batch_Counter__c >=3) {
                    delete log;
                }
            }
    }
    public void finish(Database.BatchableContext bc){
          System.debug('Batch Finish');

            }

}