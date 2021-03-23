/**
 * Created by BRITENET on 18.03.2021.
 */

public with sharing class HD_ContractTriggerHandler implements HD_TriggerInterface{

    public void bulkBefore(List<sObject> newObjects, List<sObject> oldObjects) {
        if(trigger.isInsert) {
            HD_ContractHandler.overlapTriggerCheck( (List<Contract__c>) newObjects,(List<Contract__c>) oldObjects);
        } else if(trigger.isUpdate) {
            HD_ContractHandler.overlapTriggerCheck( (List<Contract__c>) newObjects,(List<Contract__c>) oldObjects);
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