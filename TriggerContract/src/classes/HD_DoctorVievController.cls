/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorVievController {

    public HD_ContractHandler helper;
    public HD_HospitalHandler hospitalSearchHelper;
    public List<Contract__c> availableContracts { get; set; }
    public List<Hospital__c> foundHospitals { get; set; }
    public Hospital__c inputFormHospital { get; set; }
    public Id selectedHospitalId { get; set; }
    public Hospital__c selectedHospital { get; set; }
    public Doctor__c currentDoctor { get; set; }
    public Contract__c contract { get; set; }
    public String contractToDismissId { get; set; }
    public Contract__c newContract { get; set; }
    public Boolean dialogAllowedToClose {get; set;}
    public Id parentId{get;set;}
    public Blob cropperImage{get;set;}
    public Blob uploadedImage{get;set;}
    public Attachment doctorImageAttachment {
        get {
            if (doctorImageAttachment == null)
                doctorImageAttachment = new Attachment();
            return doctorImageAttachment;
        }
        set;
    }

    public HD_DoctorVievController(ApexPages.StandardController standardController) {
        parentId = standardController.getId();
        hospitalSearchHelper = new HD_HospitalHandler();
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
        Contract__c actualContract = [SELECT Doctor__c,Start_Date__c,End_Date__c FROM Contract__c WHERE Id = :contractToDismissId];
        helper.dismissConditionVerification(actualContract);
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
      //  selectedHospitalId = null;
        newContract.Start_Date__c = null;
        newContract.End_Date__c = null;
    }
    public void fullClear() {
        System.debug('poszedl clear');
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
        fullClear();
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
            fullClear();
            dialogAllowedToClose = true;
            System.debug(dialogAllowedToClose);
        }catch (Exception e){
            dialogAllowedToClose = false;
            ApexPages.addMessages(e);
        }
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
        return null;
    }

    public void  upload(){
        System.debug('attechmentbodyBegin--------------'+ doctorImageAttachment.Body);
        doctorImageAttachment.OwnerId = UserInfo.getUserId();
        doctorImageAttachment.ParentId = parentId;
        doctorImageAttachment.Name ='ProfileImage';
        insert doctorImageAttachment;
        System.debug('attachment' + doctorImageAttachment);
        doctorImageAttachment = new Attachment();
    }

//    public Id getImageId(){
//        Id result = null;
//        List<Attachment> images = [SELECT Id FROM Attachment WHERE Name = 'ProfileImage' AND ParentId= :parentId ORDER BY CreatedDate];
//        if(images.size()>0)
//        {
//            result=images[0].Id;
//        }
//        return result;
//    }

//    public void cropp(){
//        System.debug('uploadedImage-----------------'+ uploadedImage);
//        cropperImage = uploadedImage;
//        System.debug('cropperImage-----------------'+ cropperImage);
//    }

//    public void check(){
//        System.debug('cropperImage************'+ cropperImage);
//        System.debug('uploadedIamge***********'+ uploadedImage);
//    }


}