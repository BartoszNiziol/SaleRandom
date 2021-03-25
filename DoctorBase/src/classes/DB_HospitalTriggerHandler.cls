/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_HospitalTriggerHandler implements DB_TriggerInterface{
    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects,Schema.SObjectType soType) {
        if (trigger.isInsert) {
        } else if (trigger.isUpdate) {
        } else if (trigger.isDelete) {
        } else if (trigger.isUndelete) {
        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects,Schema.SObjectType soType) {
        System.debug('bulk after');
        if (trigger.isInsert) {
            String postBody = JSON.serialize(newObjects);
            ID jobID = System.enqueueJob(new DB_QueueUpsertHospitalToExternal(postBody,soType));
        } else if (trigger.isUpdate) {
            String postBody = JSON.serialize(newObjects);
            ID jobID = System.enqueueJob(new DB_QueueUpsertHospitalToExternal(postBody,soType));
        } else if (trigger.isDelete) {
            String postBody = JSON.serialize(oldObjects);
            ID jobID  = System.enqueueJob(new DB_QueueDeleteHospitalFromExternal(postBody,soType));
        } else if (trigger.isUndelete) {
        }
    }
}