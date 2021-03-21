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
        System.debug(handler);
        System.debug('Execute');
        if (Trigger.isBefore) {
            handler.bulkBefore(Trigger.new, Trigger.old);
        } else {
            handler.bulkAfter(Trigger.new, Trigger.old);
        }
    }

    private static HD_TriggerInterface getHandler(Schema.sObjectType soType) {

        if (!HD_Utils.isTriggerExceptionEnabled(soType)) {
            if (soType == Contract__c.sObjectType) {
                return new HD_ContractTriggerHandler();
            } else if (soType == Doctor__c.sObjectType) {
                return new HD_DoctorTriggerHandler();
            } else if (soType == Hospital__c.sObjectType) {
                return new HD_HospitalTriggerHandler();
            }
            else return new HD_DummyTriggerHandler();
        }
        else return new HD_DummyTriggerHandler();

    }
}