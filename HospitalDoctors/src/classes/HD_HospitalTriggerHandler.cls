/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class HD_HospitalTriggerHandler implements HD_TriggerInterface {

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects,Schema.SObjectType soType) {
        if (trigger.isInsert) {

        } else if (trigger.isUpdate) {

        } else if (trigger.isDelete) {

        } else if (trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects,Schema.SObjectType soType) {
        if (trigger.isInsert) {
            String postBody = JSON.serialize(newObjects);
            HD_HospitalHandler.upsertHospitalToExternalDB(postBody,soType);
        } else if (trigger.isUpdate) {
            String postBody = JSON.serialize(newObjects);
            HD_HospitalHandler.upsertHospitalToExternalDB(postBody,soType);
        } else if (trigger.isDelete) {
            String postBody = JSON.serialize(oldObjects);
            HD_HospitalHandler.deleteHospitalFromExternalDB(postBody,soType);
        } else if (trigger.isUndelete) {

        }

    }

}