/**
 * Created by BRITENET on 28.02.2021.
 */

trigger HD_ContractOverlaping on Contract__c (before insert, before update) {
    HD_TriggerFactory.createHandler(Contract__c.getSObjectType());

}