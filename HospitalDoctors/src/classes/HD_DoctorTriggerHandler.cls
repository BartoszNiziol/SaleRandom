/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class HD_DoctorTriggerHandler implements HD_TriggerInterface {



    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects,Schema.sObjectType soType) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects,Schema.sObjectType soType) {

        if (trigger.isInsert) {
            String postBody = JSON.serialize(newObjects);
            ID jobID = System.enqueueJob(new QueueUpsertDoctorToExternalDB(postBody,soType));
        } else if (trigger.isUpdate) {
            String postBody = JSON.serialize(newObjects);
            ID jobID = System.enqueueJob(new QueueUpsertDoctorToExternalDB(postBody,soType));
        } else if (trigger.isDelete) {
            String postBody = JSON.serialize(oldObjects);
            ID jobID  = System.enqueueJob(new HD_QueueDeleteDoctorFormExternalDB(postBody,soType));
        } else if (trigger.isUndelete) {

        }
    }

}