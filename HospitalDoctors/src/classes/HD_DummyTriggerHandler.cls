/**
 * Created by BRITENET on 18.03.2021.
 */

public with sharing class HD_DummyTriggerHandler implements HD_TriggerInterface{

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects, Schema.SObjectType soType) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects, Schema.SObjectType soType) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

}