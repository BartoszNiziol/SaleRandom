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
        try {
            DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
            String objectName = soType.getDescribe().getName();
            triggerException.put(objectName,true);
            upsert triggerException;
        } catch (Exception e) {
            System.debug('toggle exc');
            System.debug(e);
        }
    }

    public  static void turnOnTrigger (Schema.sObjectType soType){
        try {
            DB_TriggerException__c triggerException = DB_TriggerException__c.getInstance();
            String objectName = soType.getDescribe().getName();
            triggerException.put(objectName,false);
            upsert triggerException;
        } catch (Exception e) {
            System.debug('toggle exc');
            System.debug(e);
        }
    }
}