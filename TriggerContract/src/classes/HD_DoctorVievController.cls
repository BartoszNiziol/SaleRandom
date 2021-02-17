/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorVievController {
    public HD_DoctorViewControllerHelper helper;
    public List<Contract__c> availableContracts { get; set; }
    public Doctor__c currentDoctor{get;set;}
    public Contract__c contract { get; set; }
    public String contractId { get; set; }
    Boolean render { get; set; }


    public HD_DoctorVievController(ApexPages.StandardController standardController) {
        availableContracts = new List<Contract__c>();
        currentDoctor = (Doctor__c) standardController.getRecord();
        helper = new HD_DoctorViewControllerHelper();
        getContracts();
    }

    public void dismiss() {

        Contract__c actualContract = [SELECT Doctor__c,Start_Date__c,End_Date__c FROM Contract__c WHERE Id = :contractId];
        helper.processContract(actualContract);
        getContracts();


    }
    public void getContracts (){
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
    }


}