/**
 * Created by BRITENET on 03.03.2021.
 */

public with sharing class HD_Utils {

    public static String retrieveCredentials(String credentialName) {
        HD_Setting__c settingItem = HD_Setting__c.getInstance(credentialName);
        if (settingItem == null) {
            return '';
        }
        String credentialValue = settingItem.Value__c;
        return credentialValue;
    }

    public static Boolean isTriggerExceptionEnabled(Schema.sObjectType soType) {
        String objectName = soType.getDescribe().getName();
        Boolean isEnabled = false;
        try {
            isEnabled = (Boolean) HD_TriggerException__c.getInstance().get(objectName);
        } catch (SObjectException e) {
            System.debug(e.getMessage());
        }
        return isEnabled;
    }

    public static void turnOffTrigger(Schema.sObjectType soType) {
        try {
            HD_TriggerException__c triggerException = HD_TriggerException__c.getInstance();
            String objectName = soType.getDescribe().getName();
            triggerException.put(objectName, true);
            upsert triggerException;
        } catch (Exception e) {
            System.debug('toggle exc');
            System.debug(e);
        }
    }

    public static void turnOnTrigger(Schema.sObjectType soType) {
        try {
            HD_TriggerException__c triggerException = HD_TriggerException__c.getInstance();
            String objectName = soType.getDescribe().getName();
            triggerException.put(objectName, false);
            upsert triggerException;
        } catch (Exception e) {
            System.debug('toggle exc');
            System.debug(e);
        }
    }

    public static Boolean isSettingEnabled(String settingName, String valueToCheck) {
        HD_Setting__c settingItem = HD_Setting__c.getInstance(settingName);
        if (settingItem == null) {
            return false;
        }
        String settingItemValue = settingItem.Value__c;
        List<String> settingItemsValues = settingItemValue.split(',');
        Boolean settingValueExist = false;
        for (String singleValue : settingItemsValues) {
            if (singleValue == valueToCheck) {
                settingValueExist = true;
            }
        }
        return settingValueExist;
    }

    public static Boolean isSettingEnabledFOrCurrentUserCountry(String settingName) {
        return isSettingEnabled(settingName, getCurrentUser().Country);
    }

    public static User getCurrentUser() {
        return getUser(UserInfo.getUserId());
    }

    public static User getUser(String userID) {
        List<User> userList = [SELECT Email, Country FROM User WHERE Id = :userID];
        if (userList.isEmpty()) {
            return null;
        }
        return userList[0];
    }
}