/**
 * Created by BRITENET on 17.03.2021.
 */

public with sharing class HD_HospitalTriggerFactory {

    public static void createHandler(Schema.sObjectType soType) {
        HD_HospitalTriggerInterface handler = getHandler(soType);

        if (handler == null) {
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        execute(handler);
    }

    private static void execute(HD_HospitalTriggerInterface handler) {
        if (Trigger.isBefore) {
            handler.bulkBefore();
        } else {
            handler.bulkAfter();
        }
    }

    private static HD_HospitalTriggerInterface getHandler(Schema.sObjectType soType) {

        if (HD_Utils.isContractTriggerEnabled()) {

            if (soType == Contract__c.sObjectType) {
                return new ContractTriggerHandler();
            }

        }
        return null;
    }

}