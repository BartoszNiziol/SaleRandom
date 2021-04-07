/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_Utils {

    public static String retrieveCredentials(String credentialName) {
        MP_Setting__c settingItem = MP_Setting__c.getInstance(credentialName);
        if (settingItem == null) {
            return '';
        }
        String credentialValue = settingItem.Value__c;
        return credentialValue;
    }

}