/**
 * Created by BRITENET on 12.03.2021.
 */

public with sharing class DB_Utils {


    public static String retrieveAvalibleCountries() {
        DB_Setting__c settingItem = DB_Setting__c.getInstance('AvalibleCountries');
        if (settingItem == null) {
            return '';
        }
        String credentialValue = settingItem.Value__c;
        return credentialValue;
    }

    public static String retrieveCredentials(String credentialName) {
        DB_Setting__c settingItem = DB_Setting__c.getInstance(credentialName);
        if (settingItem == null) {
            return '';
        }
        String credentialValue = settingItem.Value__c;
        return credentialValue;
    }

    public static Boolean isTriggerExceptionEnabled(Schema.sObjectType soType) {
        String objectName = soType.getDescribe().getName();

        try {
            return (Boolean) DB_TriggerException__c.getInstance().get(objectName);
        } catch (SObjectException e) {
            return false;
        }

    }
//    public  static void turnOffTrigger (Schema.sObjectType soType){
//    try {
//        DB_TriggerException__c triggerException = DB_TriggerException__c.getOrgDefaults();
//        triggerException.put(soType.getDescribe().getName(),
//                true);
//        if (soType  ==  Doctor__c.SObjectType) {
//            triggerException.Doctor__c = true;
//        }
//        if (soType  ==  Hospital__c.SObjectType) {
//            triggerException.Hospital__c = true;
//        }
//        upsert triggerException;
//    }catch (Exception e){
//
//    }
//    }
//    public  static void turnOnTrigger (Schema.sObjectType soType){
//
//        DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
//        if (soType  ==  Doctor__c.SObjectType) {
//            triggerException.Doctor__c = false;
//        }
//        if (soType  ==  Hospital__c.SObjectType) {
//            triggerException.Hospital__c = false;
//        }
//        upsert triggerException;
//
//    }

    public static void toggleTrigger(Schema.sObjectType soType) {
        try {
            DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
            String objectName = soType.getDescribe().getName();
            triggerException.put(objectName,
                    !(Boolean) triggerException.get((String) DB_TriggerException__c.getInstance().get(objectName)));
            upsert triggerException;
        } catch (Exception e) {

        }
    }
}