/**
 * Created by BRITENET on 21.03.2021.
 */

trigger DB_HospitalTrigger on Hospital__c (after insert, after update, after delete, after undelete) {
    DB_TriggerFactory.createHandler(Hospital__c.getSObjectType());
}