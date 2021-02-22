/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_ContractHandler {

    public void updateContractsByDate(Contract__c actualContract) {
        if (actualContract.End_Date__c != null) {
            if (actualContract.Start_Date__c < System.today() && actualContract.End_Date__c <= System.today()) {

            } else if (actualContract.Start_Date__c <= System.today() && (actualContract.End_Date__c > System.today())) {
                actualContract.End_Date__c = System.today();
                update actualContract;
            } else if (actualContract.Start_Date__c > System.today() && actualContract.End_Date__c > System.today()) {
                delete actualContract;
            }
        } else {
            if (actualContract.Start_Date__c <= System.today()) {
                actualContract.End_Date__c = System.today();
                update actualContract;
            } else {
                delete actualContract;
            }
        }
    }
}