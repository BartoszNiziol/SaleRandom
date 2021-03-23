/**
 * Created by BRITENET on 19.03.2021.
 */

trigger HD_DoctorTrigger on Doctor__c (after insert, after update, after delete, after undelete) {
    HD_TriggerFactory.createHandler(Doctor__c.getSObjectType());
}