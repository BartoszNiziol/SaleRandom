/**
 * Created by BRITENET on 21.03.2021.
 */

trigger DB_DoctorTrigger on Doctor__c (after insert, after update, after delete, after undelete) {
    DB_TriggerFactory.createHandler(Doctor__c.getSObjectType());
}