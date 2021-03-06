/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_DoctorTriggerHandler implements DB_TriggerInterface{

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects) {
        if(trigger.isInsert) {
        } else if(trigger.isUpdate) {
        } else if(trigger.isDelete) {
        } else if(trigger.isUndelete) {
        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects) {
        if (trigger.isInsert) {
            System.debug('insert in doctrighand');
            String postBody = JSON.serialize(newObjects);
            DB_DoctorHandler.upsertDoctorToExternalDB(postBody);
        } else if (trigger.isUpdate) {
            System.debug('update in doctrighand');
            String postBody = JSON.serialize(newObjects);
            DB_DoctorHandler.upsertDoctorToExternalDB(postBody);
        } else if (trigger.isDelete) {
            String postBody = JSON.serialize(oldObjects);
            DB_DoctorHandler.deleteDoctorFromExternalDB(postBody);
        } else if (trigger.isUndelete) {
        }
    }
}