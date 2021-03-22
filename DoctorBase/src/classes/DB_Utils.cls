/**
 * Created by BRITENET on 12.03.2021.
 */

public with sharing class DB_Utils {


    public static String retrieveAvalibleCountries(){
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

    public static Boolean isTriggerExceptionEnabled(Schema.sObjectType soType){
        String objectName = soType.getDescribe().getName();

        Boolean isEnabled = false;
        try{
            isEnabled = (Boolean) DB_TriggerException__c.getInstance().get(objectName);
        }catch (SObjectException e){
            System.debug(e.getMessage());
        }
        return isEnabled;
    }
    public  static void turnOffTrigger (Schema.sObjectType soType){

        DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
        if (soType  ==  Doctor__c.SObjectType) {
            triggerException.Doctor__c = true;
        }
       else if (soType  ==  Hospital__c.SObjectType) {
            triggerException.Hospital__c = true;
        }
        upsert  triggerException;
    }

    public  static void turnOnTrigger (Schema.sObjectType soType){

        DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
        if (soType  ==  Doctor__c.SObjectType) {
            triggerException.Doctor__c = false;
        }
       else if (soType  ==  Hospital__c.SObjectType) {
            triggerException.Hospital__c = false;
        }
        upsert triggerException;

    }
}