/**
 * Created by BRITENET on 18.03.2021.
 */

public with sharing class HD_ContractTriggerHandler implements HD_TriggerInterface{
    public void bulkBefore() {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }

    public void bulkAfter() {
        if(trigger.isInsert) {

        } else if(trigger.isUpdate) {

        } else if(trigger.isDelete) {

        } else if(trigger.isUndelete) {

        }
    }
}