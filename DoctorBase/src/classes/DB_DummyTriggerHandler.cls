/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_DummyTriggerHandler implements DB_TriggerInterface{

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

    public void bulkAfter(List<sObject> newObjects, List<sObject> oldObjects) {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

}