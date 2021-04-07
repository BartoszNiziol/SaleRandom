/**
 * Created by BRITENET on 30.03.2021.
 */

public with sharing class AccountProcessor {
    @future
    public static void countContacts(List<id> setId)
    {
        List<Account> lstAccount = [select id,Number_of_Contacts__c , (select id from contacts ) from account where id in :setId ];
        for( Account acc : lstAccount )
        {
            List<Contact> lstCont = acc.contacts ;

            acc.Number_of_Contacts__c = lstCont.size();
        }
        update lstAccount;
    }

}