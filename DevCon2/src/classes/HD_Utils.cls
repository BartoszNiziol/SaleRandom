/**
 * Created by BRITENET on 03.03.2021.
 */

public with sharing class HD_Utils {
    public static Boolean isSettingEnabled(String settingName, String valueToCheck) {
        HD_Setting__c settingItem = HD_Setting__c.getInstance(settingName);
        if (settingItem == null) {
            return false;
        }
        return settingItem.Value__c.contains(valueToCheck);
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