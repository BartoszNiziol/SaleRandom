/**
 * Created by BRITENET on 03.03.2021.
 */

public with sharing class HD_Utils {


    public static String retrieveCredentials(String credentialName){
        HD_Setting__c settingItem = HD_Setting__c.getInstance(credentialName);
        if (settingItem == null) {
            return '';
        }
        String credentialValue = settingItem.Value__c;
        return credentialValue;
    }

    public static Boolean isTriggerEnabled(Schema.sObjectType soType){
        HD_TriggerException__c triggerException = HD_TriggerException__c.getInstance();

        if (soType  ==  Contract__c.SObjectType) {
            return !triggerException.Contract__c;
        }
        if (soType  ==  Doctor__c.SObjectType) {
            return !triggerException.Doctor__c;
        }
        if (soType  ==  Hospital__c.SObjectType) {
            return !triggerException.Hospital__c;
        }

       return false;

    }

    public static Boolean isSettingEnabled(String settingName, String valueToCheck) {
        HD_Setting__c settingItem = HD_Setting__c.getInstance(settingName);
        if (settingItem == null) {
            return false;
        }
        String settingItemValue =  settingItem.Value__c;
        List<String> settingItemsValues = settingItemValue.split(',');
        Boolean settingValueExist = false;
        for (String singleValue : settingItemsValues){
            if (singleValue == valueToCheck) {
                settingValueExist = true;
            }
        }
        return  settingValueExist;
    }
    public static Boolean isSettingEnabledFOrCurrentUserCountry(String settingName) {
        return isSettingEnabled(settingName, getCurrentUser().Country);
    }
    public static User getCurrentUser() {
        return getUser(UserInfo.getUserId());
    }
    public static User getUser(String userID){
        List<User> userList = [SELECT Email, Country FROM User WHERE Id =:userID];
        if(userList.isEmpty()){
            return null;
        }
        return userList[0];
    }
}