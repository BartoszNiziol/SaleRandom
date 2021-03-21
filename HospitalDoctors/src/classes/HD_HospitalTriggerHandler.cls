/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class HD_HospitalTriggerHandler implements HD_TriggerInterface {

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects) {
        System.debug('in bulk after');
        if(trigger.isInsert) {
            HD_HospitalHandler.upsertHospitalToExternalDB((List<Hospital__c>) newObjects,(List<Hospital__c>) oldObjects);
        } else if(trigger.isUpdate) {
            HD_HospitalHandler.upsertHospitalToExternalDB((List<Hospital__c>) newObjects,(List<Hospital__c>) oldObjects);
        } else if(trigger.isDelete) {
            HD_HospitalHandler.deleteHospitalFromExternalDB((List<Hospital__c>) newObjects,(List<Hospital__c>) oldObjects);
        } else if(trigger.isUndelete) {

        }
    }

}