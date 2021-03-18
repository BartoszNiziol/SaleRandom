/**
 * Created by BRITENET on 18.03.2021.
 */

public with sharing class HD_TriggerFactory {
    public static void createHandler(Schema.sObjectType soType) {
        HD_TriggerInterface handler = getHandler(soType);

        if (handler == null) {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        execute(handler);
    }

    private static void execute(HD_TriggerInterface handler) {
        if (Trigger.isBefore) {
            handler.bulkBefore();
        } else {
            handler.bulkAfter();
        }
    }

    private static HD_TriggerInterface getHandler(Schema.sObjectType soType) {

        if (soType == Contract__c.sObjectType ) {
            if (HD_Utils.isContractTriggerEnabled()) {
                return new HD_ContractTriggerHandler();
            }
        }
        return null;
    }
}