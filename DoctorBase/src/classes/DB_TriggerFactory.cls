/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_TriggerFactory {
    public static void createHandler(Schema.sObjectType soType) {
        DB_TriggerInterface handler = getHandler(soType);

        if (handler == null) {
            throw new DB_TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        execute(handler);
    }

    private static void execute(DB_TriggerInterface handler) {
        System.debug(handler);
        System.debug('Execute');
        if (Trigger.isBefore) {
            handler.bulkBefore(Trigger.new, Trigger.old);
        } else {
            handler.bulkAfter(Trigger.new, Trigger.old);
        }
    }

    private static DB_TriggerInterface getHandler(Schema.sObjectType soType) {

        if (!DB_Utils.isTriggerExceptionEnabled(soType)) {
            if (soType == Doctor__c.sObjectType) {
                return new DB_DoctorTriggerHandler();
            } else if (soType == Hospital__c.sObjectType) {
                return new DB_HospitalTriggerHandler();
            }
            else return new DB_DummyTriggerHandler();
        }
        else return new DB_DummyTriggerHandler();

    }

}