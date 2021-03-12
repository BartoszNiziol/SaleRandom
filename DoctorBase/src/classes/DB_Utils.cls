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

}