/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorVievController {
    public String croppedImageAsString{get;set;}
    public HD_ContractHandler contractHandler;
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
    public Boolean hireDialogAllowedToClose {get; set;}
    public Id AttachmentParentId {get;set;}
    public Blob cropperImage{get;set;}
   // public Blob uploadedImage{get;set;}
    public Attachment doctorImageAttachment {
        get {
            if (doctorImageAttachment == null)
                doctorImageAttachment = new Attachment();
            return doctorImageAttachment;
        }
        set;
    }

    public HD_DoctorVievController(ApexPages.StandardController standardController) {
        AttachmentParentId = standardController.getId();
        hospitalSearchHelper = new HD_HospitalHandler();
        availableContracts = new List<Contract__c>();
        currentDoctor = (Doctor__c) standardController.getRecord();
        contractHandler = new HD_ContractHandler();
        inputFormHospital = new Hospital__c();
        foundHospitals = new List<Hospital__c>();
        newContract = new Contract__c();
        getContracts();
        hireDialogAllowedToClose = false;
    }

    public void dismiss() {
        Contract__c actualContract = [SELECT Doctor__c,Start_Date__c,End_Date__c FROM Contract__c WHERE Id = :contractToDismissId];
        contractHandler.dismissConditionVerification(actualContract);
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
        newContract.Start_Date__c = null;
        newContract.End_Date__c = null;
    }
    public void fullClear() {
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

    public void cancelHire() {
        fullClear();
        hireDialogAllowedToClose = false;
    }

    public PageReference hire() {
        try {
            hireDialogAllowedToClose = false;
            Contract__c contract = new Contract__c();
            contract.Doctor__c = currentDoctor.Id;
            contract.Hospital__c = selectedHospital.Id;
            contract.Start_Date__c = newContract.Start_Date__c;
            contract.End_Date__c = newContract.End_Date__c;
            insert contract;
            fullClear();
            hireDialogAllowedToClose = true;
            System.debug(hireDialogAllowedToClose);
        }catch (Exception e){
            hireDialogAllowedToClose = false;
            ApexPages.addMessages(e);
        }
        availableContracts = [SELECT Doctor__c,Start_Date__c,End_Date__c,Hospital__r.Name FROM Contract__c WHERE Doctor__c = :currentDoctor.Id];
        return null;
    }

    public void uploadAttachment(){

        doctorImageAttachment.Body = cropperImage;
        doctorImageAttachment.OwnerId = UserInfo.getUserId();
        doctorImageAttachment.ParentId = AttachmentParentId;
        doctorImageAttachment.Name ='ProfileImage';
        List<Attachment> images = [SELECT Id FROM Attachment WHERE Name = 'ProfileImage' AND ParentId= :AttachmentParentId];
        delete images;
        insert doctorImageAttachment;
        doctorImageAttachment = new Attachment();
    }

    public void deletePhoto(){
        List<Attachment> images = [SELECT Id FROM Attachment WHERE Name = 'ProfileImage' AND ParentId= :AttachmentParentId];
        delete images;
    }

    public void blobFromCropping(){
        cropp();
        uploadAttachment();
    }

    public Id getImageId(){
        Id result = null;
        List<Attachment> images = [SELECT Id FROM Attachment WHERE Name = 'ProfileImage' AND ParentId= :AttachmentParentId ORDER BY CreatedDate DESC ];
        System.debug('all attachments-------------' + images);
        if(images.size()>0)
        {
            result=images[0].Id;
        }
        return result;
    }

    public void cropp(){
        String[] parts = croppedImageAsString.split(',');
        cropperImage = EncodingUtil.base64Decode(parts[1]);
    }

    public void empty(){

    }

    public void invokeSizeError(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Image size over 1MB');
        ApexPages.addMessage(myMsg);
    }
    public void invokeFileTypeError(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Wrong type of file');
        ApexPages.addMessage(myMsg);
    }




}