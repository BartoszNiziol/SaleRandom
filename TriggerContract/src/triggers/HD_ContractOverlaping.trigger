/**
 * Created by BRITENET on 10.02.2021.
 */

trigger HD_ContractOverlaping on Contract__c (before insert, before update) {

    Map<String, List<Contract__c>> doctorsHospitalsIdToContracts = new Map<String, List< Contract__c>>();
    List<Id> doctorsIdList = new List<Id>();
    List<Id> hospitalsIdList = new List<Id>();

    for (Contract__c contractToAdd : Trigger.new) {
        doctorsIdList.add(contractToAdd.Doctor__c);
        hospitalsIdList.add(contractToAdd.Hospital__c);
    }

    List<Contract__c> pairingContracts = [
            SELECT Id,Start_Date__c,End_Date__c,Doctor__r.First_Name__c,Doctor__r.Name,Hospital__r.Name
            FROM Contract__c
            WHERE Doctor__c IN :doctorsIdList AND Hospital__c IN :hospitalsIdList
    ];

    for (Contract__c matchingContract : pairingContracts) {
        if (doctorsHospitalsIdToContracts.containsKey(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c))) {
            doctorsHospitalsIdToContracts.get(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c))
                    .add(matchingContract);
        } else {
            doctorsHospitalsIdToContracts.put(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c), new List<Contract__c>{
                    matchingContract
            });
        }
    }
    for (Contract__c contractsToAdd : Trigger.new) {
        String errorMessage = System.Label.Overlapping_Error;
        Set<String> doctorsHospitalsIdToContractsKeySet = doctorsHospitalsIdToContracts.keySet();

        for (String combinedDoctorHospitalId : doctorsHospitalsIdToContractsKeySet) {

            if (combinedDoctorHospitalId.equals(String.valueOf(contractsToAdd.Doctor__c) + String.valueOf(contractsToAdd.Hospital__c))) {

                for (Contract__c oldContract : doctorsHospitalsIdToContracts.get(combinedDoctorHospitalId)) {
                    if (isOverlapped(oldContract, contractsToAdd)) {

                        Date startDate = oldContract.Start_Date__c;
                        Date endDate = oldContract.End_Date__c;
                        String dateDisplayString = startDate.day()
                                + '/' + startDate.month()
                                + '/' + startDate.year()
                                + '-'
                                + endDate.day()
                                + '/'
                                + endDate.month()
                                + '/'
                                + endDate.year();

                        errorMessage += oldContract.Doctor__r.First_Name__c
                                + ' ' + oldContract.Doctor__r.Name
                                + ' in ' + oldContract.Hospital__r.Name
                                + ' on ' + dateDisplayString + ' | ';
                    }
                }
            }
        }
        contractsToAdd.addError(errorMessage);
    }


    private Boolean isOverlapped(Contract__c oldContract, Contract__c newContract) {
        if (oldContract.End_Date__c == null) {
            if (oldContract.Start_Date__c < newContract.End_Date__c || oldContract.Start_Date__c < newContract.Start_Date__c) {
                return true;
            }
        }
        if (newContract.End_Date__c == null) {

            if (oldContract.End_Date__c > newContract.Start_Date__c) {
                return true;
            }
        }
        if ((oldContract.Start_Date__c > newContract.Start_Date__c) && (oldContract.Start_Date__c < newContract.End_Date__c)
                || (oldContract.End_Date__c > newContract.Start_Date__c && oldContract.End_Date__c < newContract.End_Date__c)
                || (oldContract.Start_Date__c < newContract.Start_Date__c && oldContract.End_Date__c > newContract.End_Date__c)
                || (oldContract.Start_Date__c > newContract.Start_Date__c && oldContract.End_Date__c < newContract.End_Date__c)) {
            return true;
        }
        return false;
    }


}