/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorVievController {

    public HD_ContractHandler helper;
    public HD_HospitalSearchHandler hospitalSearchHelper;
    public List<Contract__c> availableContracts { get; set; }
    public List<Hospital__c> foundHospitals { get; set; }
    public Hospital__c inputFormHospital { get; set; }
    public Id selectedHospitalId { get; set; }
    public Hospital__c selectedHospital { get; set; }
    public Doctor__c currentDoctor { get; set; }
    public Contract__c contract { get; set; }
    public String contractId { get; set; }
    public Contract__c newContract { get; set; }
    public Boolean dialogAllowedToClose {get; set;}

    public HD_DoctorVievController(ApexPages.StandardController standardController) {
        hospitalSearchHelper = new HD_HospitalSearchHandler();
        availableContracts = new List<Contract__c>();
        currentDoctor = (Doctor__c) standardController.getRecord();
        helper = new HD_ContractHandler();
        inputFormHospital = new Hospital__c();
        foundHospitals = new List<Hospital__c>();
        newContract = new Contract__c();
        getContracts();
        dialogAllowedToClose = false;
    }

    public void dismiss() {
        Contract__c actualContract = [SELECT Doctor__c,Start_Date__c,End_Date__c FROM Contract__c WHERE Id = :contractId];
        helper.updateContractsByDate(actualContract);
        getContracts();
    }
    public void getContracts() {
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
    }
    public void searchHospital() {

        foundHospitals = hospitalSearchHelper.queryHospitals(inputFormHospital.Name, inputFormHospital.Email__c, inputFormHospital.Country__c);
    }
    public void clear() {
        foundHospitals = new List<Hospital__c>();
        inputFormHospital = new Hospital__c();
        selectedHospital = null;
        selectedHospitalId = null;
        newContract.Start_Date__c = null;
        newContract.End_Date__c = null;
    }
    public void selectHospital() {
        selectedHospital = [SELECT Id,Name FROM Hospital__c WHERE Id = :selectedHospitalId];
        System.debug('selectedHospital after query' + selectedHospital);
    }

    public void cancel() {
        clear();
        dialogAllowedToClose = false;

    }
    public PageReference hire() {
        try {
            dialogAllowedToClose = false;
            Contract__c contract = new Contract__c();
            contract.Doctor__c = currentDoctor.Id;
            contract.Hospital__c = selectedHospital.Id;
            contract.Start_Date__c = newContract.Start_Date__c;
            contract.End_Date__c = newContract.End_Date__c;
            insert contract;
            clear();
            dialogAllowedToClose = true;
            System.debug(dialogAllowedToClose);
        }catch (Exception e){
            dialogAllowedToClose = false;
            ApexPages.addMessages(e);

        }
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];

        return null;
    }


}