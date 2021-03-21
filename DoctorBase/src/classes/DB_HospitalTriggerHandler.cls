/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_HospitalTriggerHandler implements DB_TriggerInterface{
    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects) {
        if (trigger.isInsert) {

        } else if (trigger.isUpdate) {

        } else if (trigger.isDelete) {

        } else if (trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects) {
        System.debug('bulk after');
        if (trigger.isInsert) {
            String postBody = JSON.serialize(newObjects);
            System.debug(postBody);
            DB_HospitalHandler.upsertHospitalToExternalDB(postBody);
        } else if (trigger.isUpdate) {
            String postBody = JSON.serialize(newObjects);
            DB_HospitalHandler.upsertHospitalToExternalDB(postBody);
        } else if (trigger.isDelete) {
            DB_HospitalHandler.deleteHospitalFromExternalDB((List<Hospital__c>) newObjects, (List<Hospital__c>) oldObjects);
        } else if (trigger.isUndelete) {

        }

    }

}