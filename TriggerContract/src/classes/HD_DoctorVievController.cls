/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorVievController {

    public HD_DoctorViewControllerHelper helper;
    public List<Contract__c> availableContracts { get; set; }
    public List<Hospital__c> foundHospitals { get; set; }
    public Hospital__c inputFormHospital { get; set; }
    public Id selectedHospitalId { get; set; }
    public Hospital__c selectedHospital { get; set; }
    public Doctor__c currentDoctor { get; set; }
    public Contract__c contract { get; set; }
    public String contractId { get; set; }
    public Contract__c newContract { get; set; }

    public HD_DoctorVievController(ApexPages.StandardController standardController) {
        availableContracts = new List<Contract__c>();
        currentDoctor = (Doctor__c) standardController.getRecord();
        helper = new HD_DoctorViewControllerHelper();
        inputFormHospital = new Hospital__c();
        foundHospitals = new List<Hospital__c>();
        newContract = new Contract__c();
        getContracts();
    }

    public void dismiss() {
        Contract__c actualContract = [SELECT Doctor__c,Start_Date__c,End_Date__c FROM Contract__c WHERE Id = :contractId];
        helper.processContract(actualContract);
        getContracts();
    }
    public void getContracts() {
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
    }
    public void searchHospital() {

        foundHospitals = helper.queryHospitals(inputFormHospital.Name, inputFormHospital.Email__c, inputFormHospital.Country__c);
    }
    public void clear() {
        foundHospitals = new List<Hospital__c>();
        inputFormHospital = new Hospital__c();
        selectedHospital = null;
        selectedHospitalId = null;
    }
    public void selectHospital() {
        selectedHospital = [SELECT Id,Name FROM Hospital__c WHERE Id = :selectedHospitalId];
        System.debug('selectedHospital after query' + selectedHospital);
    }

    public void cancel() {
      selectedHospital = null;
        selectedHospitalId = null;
    }

    public PageReference hire() {
        try {
            Contract__c contract = new Contract__c();
            contract.Doctor__c = currentDoctor.Id;
            contract.Hospital__c = selectedHospital.Id;
            contract.Start_Date__c = newContract.Start_Date__c;
            contract.End_Date__c = newContract.End_Date__c;
            insert contract;
        }catch (Exception e){
            ApexPages.addMessages(e);
        }
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
        return null;
    }


}