/**
 * Created by BRITENET on 19.03.2021.
 */

trigger HD_HospitalTrigger on Hospital__c (after insert, after update, after delete, after undelete) {
    System.debug('Trigger start');
    HD_TriggerFactory.createHandler(Hospital__c.getSObjectType());
}