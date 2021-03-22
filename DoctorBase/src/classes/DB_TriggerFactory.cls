/**
 * Created by BRITENET on 21.03.2021.
 */

public with sharing class DB_TriggerFactory {
    public static final Schema.sObjectType DOCTOR_API_NAME = Doctor__c.SObjectType;
    public static final Schema.sObjectType HOSPITAL_API_NAME = Hospital__c.SObjectType;


    public static void createHandler(Schema.sObjectType soType) {
        DB_TriggerInterface handler = getHandler(soType);
        if (handler == null) {
            throw new DB_TriggerException('No Trigger Handler registered for Object Type: ' + soType);
        }
        execute(handler);
    }

    private static void execute(DB_TriggerInterface handler) {
        if (Trigger.isBefore) {
            handler.bulkBefore(Trigger.new, Trigger.old);
        } else {
            handler.bulkAfter(Trigger.new, Trigger.old);
        }
    }

    private static DB_TriggerInterface getHandler(Schema.sObjectType soType) {

        if (!DB_Utils.isTriggerExceptionEnabled(soType)) {
            if (soType === DOCTOR_API_NAME) {
                return new DB_DoctorTriggerHandler();
            } else if (soType === HOSPITAL_API_NAME) {
                return new DB_HospitalTriggerHandler();
            }
        }
        return new DB_DummyTriggerHandler();

    }

}