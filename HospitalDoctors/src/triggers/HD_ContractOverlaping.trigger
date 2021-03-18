/**
 * Created by BRITENET on 28.02.2021.
 */

trigger HD_ContractOverlaping on Contract__c (before insert, before update) {

    Map<String, List<Contract__c>> oldDoctorsHospitalsIdToContracts = new Map<String, List< Contract__c>>();
    List<Id> doctorsToAddIdList = new List<Id>();
    List<Id> hospitalsToAddIdList = new List<Id>();
    Map<Contract__c,String> contractsWithError = new Map<Contract__c,String>();

    for (Contract__c contractToAdd : Trigger.new) {
        doctorsToAddIdList.add(contractToAdd.Doctor__c);
        hospitalsToAddIdList.add(contractToAdd.Hospital__c);
    }

    for(Contract__c contractToAdd :Trigger.new){
        if(contractToAdd.End_Date__c != null){
            if(contractToAdd.End_Date__c<contractToAdd.Start_Date__c || contractToAdd.End_Date__c < System.today() ){
                contractsWithError.put(contractToAdd,'Contract Error, Check End Date');
            }
        }

    }

    List<Contract__c> matchingToNewContracts = [
            SELECT Id,Start_Date__c,End_Date__c,Doctor__r.First_Name__c,Doctor__r.Name,Hospital__r.Name
            FROM Contract__c
            WHERE Doctor__c IN :doctorsToAddIdList AND Hospital__c IN :hospitalsToAddIdList
    ];

    for (Contract__c matchingContract : matchingToNewContracts) {
        if (oldDoctorsHospitalsIdToContracts.containsKey(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c))) {
            oldDoctorsHospitalsIdToContracts.get(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c))
                    .add(matchingContract);
        } else {
            oldDoctorsHospitalsIdToContracts.put(String.valueOf(matchingContract.Doctor__c) + String.valueOf(matchingContract.Hospital__c), new List<Contract__c>{
                    matchingContract
            });
        }
    }

    String errorMessage = Label.Overlapping_Error;
    for (Contract__c contractsToAdd : Trigger.new) {

        String doctorHospitalToAddIds = String.valueOf(contractsToAdd.Doctor__c) + String.valueOf(contractsToAdd.Hospital__c);

        List<Contract__c> contactsWithSameDoctorANDHospitalASContractsToAdd =
                oldDoctorsHospitalsIdToContracts.get(doctorHospitalToAddIds);

        if (contactsWithSameDoctorANDHospitalASContractsToAdd != null) {

            for (Contract__c oldContract : contactsWithSameDoctorANDHospitalASContractsToAdd) {
                errorMessage = Label.Overlapping_Error;
                if (isOverlapped(oldContract, contractsToAdd)) {
                    if(oldContract.End_Date__c != null) {
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

                        contractsWithError.put(contractsToAdd, errorMessage);
                    }else {
                        Date startDate = oldContract.Start_Date__c;
                        String dateDisplayString = startDate.day()
                                + '/' + startDate.month()
                                + '/' + startDate.year()
                                + '- ...';

                        errorMessage += oldContract.Doctor__r.First_Name__c
                                + ' ' + oldContract.Doctor__r.Name
                                + ' in ' + oldContract.Hospital__r.Name
                                + ' on ' + dateDisplayString + ' | ';

                        contractsWithError.put(contractsToAdd, errorMessage);
                    }
                }
            }
        }
    }

    for(Contract__c contractToAdd :Trigger.new){
        if(contractToAdd.End_Date__c != null){
            if(contractToAdd.End_Date__c<contractToAdd.Start_Date__c || contractToAdd.End_Date__c < System.today() ){

                contractsWithError.put(contractToAdd,'Contract Error, Check End Date');
            }
        }
    }

    for (Contract__c contract : contractsWithError.keySet()){

        contract.addError(contractsWithError.get(contract)+ '\n' );
    }

    private Boolean isOverlapped(Contract__c oldContract, Contract__c newContract) {
        if(oldContract.Id.equals(newContract.Id)){
            return false;
        }
        if(newContract.End_Date__c == null && oldContract.End_Date__c == null){
            return true;
        }
        if (oldContract.End_Date__c == null) {
            if (oldContract.Start_Date__c <= newContract.End_Date__c || oldContract.Start_Date__c <= newContract.Start_Date__c) {
                return true;
            }
        }
        if (newContract.End_Date__c == null) {

            if (oldContract.End_Date__c >= newContract.Start_Date__c) {
                return true;
            }
        }
        if ((oldContract.Start_Date__c >= newContract.Start_Date__c) && (oldContract.Start_Date__c <= newContract.End_Date__c)
                || (oldContract.End_Date__c >= newContract.Start_Date__c && oldContract.End_Date__c <= newContract.End_Date__c)
                || (oldContract.Start_Date__c <= newContract.Start_Date__c && oldContract.End_Date__c >= newContract.End_Date__c)
                || (oldContract.Start_Date__c >= newContract.Start_Date__c && oldContract.End_Date__c <= newContract.End_Date__c)) {
            return true;
        }
        return false;
    }
}