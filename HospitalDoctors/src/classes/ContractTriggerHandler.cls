/**
 * Created by BRITENET on 17.03.2021.
 */

public with sharing class ContractTriggerHandler implements HD_HospitalTriggerInterface{

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