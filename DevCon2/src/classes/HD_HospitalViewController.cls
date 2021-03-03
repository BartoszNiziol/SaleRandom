/**
 * Created by BRITENET on 24.02.2021.
 */

public with sharing class HD_HospitalViewController {

    public Doctor__c inputFormDoctor { get; set; }
    public Hospital__c currentHospital { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public Id selectedDoctorId { get; set; }
    public List<HD_DoctorSelectWrapper> foundWrappedDoctors { get; set; }
    public List<HD_DoctorSelectWrapper> selectedDoctors { get; set; }
    public HD_DoctorHandler doctorHandler;
    public Id doctorRemoveId { get; set; }
    public Id templateId { get; set; }
    public Map<Id, HD_ContractWrapper> selectedDoctorIdToContractWrapper { get; set; }
    public Id currentEditedId { get; set; }
    public Contract__c inputFormContract { get; set; }
    public Boolean isReadyToHire { get; set; }
    public Boolean hireDialogAllowedToClose { get; set; }
    public Boolean inEditMode { get; set; }
    public List<Contract__c> currentContracts { get; set; }

    public HD_HospitalViewController(ApexPages.StandardController standardController) {
        doctorHandler = new HD_DoctorHandler();
        currentHospital = (Hospital__c) standardController.getRecord();
        currentContracts = currentHospital.Contracts__r;
        inputFormDoctor = new Doctor__c();
        foundWrappedDoctors = new List<HD_DoctorSelectWrapper>();
        selectedDoctors = new List<HD_DoctorSelectWrapper>();
        selectedDoctorIdToContractWrapper = new Map<Id, HD_ContractWrapper>();
        inputFormContract = new Contract__c();
        isReadyToHire = false;
        hireDialogAllowedToClose = false;
        foundDoctors = new List<Doctor__c>();
        inEditMode = false;
    }

    public void searchDoctors() {
        foundWrappedDoctors = new List<HD_DoctorSelectWrapper>();
        foundDoctors = doctorHandler.queryDoctorsOR(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c);
        for (Doctor__c doc : foundDoctors) {
            HD_DoctorSelectWrapper requestedToAddDoctor = new HD_DoctorSelectWrapper(doc);
            if (selectedDoctors.contains(requestedToAddDoctor)) {
                requestedToAddDoctor.isSelected = true;
            }
            foundWrappedDoctors.add(requestedToAddDoctor);
        }
    }

    public void selectDoctor() {
        for (HD_DoctorSelectWrapper doctor : foundWrappedDoctors) {
            if (doctor.doctor.Id == selectedDoctorId) {
                doctor.isSelected = true;
            }
        }
        Doctor__c selectedDoctor = [SELECT Id,First_Name__c,Name FROM Doctor__c WHERE Id = :selectedDoctorId LIMIT 1];
        selectedDoctors.add(new HD_DoctorSelectWrapper(selectedDoctor, true));
        Contract__c freshContract = new Contract__c();
        freshContract.Doctor__r = selectedDoctor;
        freshContract.Hospital__r = currentHospital;
        freshContract.Hospital__c = currentHospital.Id;
        freshContract.Doctor__c = selectedDoctor.Id;
        HD_ContractWrapper contractWrapper = new HD_ContractWrapper(freshContract);
        selectedDoctorIdToContractWrapper.put(selectedDoctorId, contractWrapper);
        isReadyToHire = false;
        setHireButtonReady ();
    }

    public void remove() {
        List<Integer> indexesToRemove = new List<Integer>();
        for (HD_DoctorSelectWrapper doctor : foundWrappedDoctors) {
            if (doctor.doctor.Id == doctorRemoveId) {
                doctor.isSelected = false;
            }
        }
        for (HD_DoctorSelectWrapper doctor : selectedDoctors) {
            if (doctor.doctor.Id == doctorRemoveId) {
                indexesToRemove.add(selectedDoctors.indexOf(doctor));
            }
        }
        for (Integer i : indexesToRemove) {
            selectedDoctors.remove(i);
        }
        selectedDoctorIdToContractWrapper.remove(doctorRemoveId);
        isReadyToHire = true;
        setHireButtonReady ();
    }

    public void clear() {
        inputFormDoctor.First_Name__c = null;
        inputFormDoctor.Name = null;
        inputFormDoctor.Email__c = null;
        inputFormDoctor.Country__c = null;
        foundWrappedDoctors = new List<HD_DoctorSelectWrapper>();
    }

    public void template() {
        HD_ContractWrapper tempContract = selectedDoctorIdToContractWrapper.get(templateId);
        Set<Id> selectedDoctorIdToContractWrapperKeySet = selectedDoctorIdToContractWrapper.keySet();
        for (Id id : selectedDoctorIdToContractWrapperKeySet) {
            selectedDoctorIdToContractWrapper.get(id).contract.Start_Date__c = tempContract.contract.Start_Date__c;
            selectedDoctorIdToContractWrapper.get(id).contract.End_Date__c = tempContract.contract.End_Date__c;
        }
        isReadyToHire = true;
        setHireButtonReady ();
    }

    public PageReference cancelDialog() {
        PageReference tempPage = ApexPages.currentPage();
        Id id = tempPage.getParameters().get('id');
        tempPage.getParameters().clear();
        tempPage.getParameters().put('id', id);
        tempPage.setRedirect(true);
        return tempPage;
    }

    public PageReference hire() {
        List<Contract__c> contractsToInsert = new List<Contract__c>();
        Set<Id> selectedDoctorsKeySet = selectedDoctorIdToContractWrapper.keySet();
        for (Id id : selectedDoctorsKeySet) {
            Contract__c contract = selectedDoctorIdToContractWrapper.get(id).contract;
            if (!(selectedDoctorIdToContractWrapper.get(id).status == 'success')) {
                contractsToInsert.add(contract);
            }
        }
        List<Database.SaveResult> saveResults;
        saveResults = Database.insert(contractsToInsert, false);
        Integer count = 0;
        if (selectedDoctorsKeySet.size() > 0 && saveResults.size() > 0) {
            for (Id id : selectedDoctorsKeySet) {
                if (selectedDoctorIdToContractWrapper.get(id).status != 'Success') {

                    if (saveResults.get(count).success) {
                        selectedDoctorIdToContractWrapper.get(id).status = 'Success';
                    } else {
                        selectedDoctorIdToContractWrapper.get(id).status = saveResults.get(count).errors.get(0).message;
                    }
                    count++;
                }
            }
        }
        Integer errorCounter = 0 ;
        if (saveResults.size() > 0) {
            for (Database.SaveResult result : saveResults) {
                if (result.getErrors().size() > 0) {
                    errorCounter++;
                    break;
                }
            }
        }
        if (errorCounter == 0) {
            PageReference tempPage = ApexPages.currentPage();
            Id id = tempPage.getParameters().get('id');
            tempPage.getParameters().clear();
            tempPage.getParameters().put('id', id);
            tempPage.setRedirect(true);
            return tempPage;
        }
        return null;
    }

    public void editContract() {
        selectedDoctorIdToContractWrapper.get(currentEditedId).isOpenForEdit = true;
        isReadyToHire = false;
        selectedDoctorIdToContractWrapper.get(currentEditedId).status = 'In Edit';
        inputFormContract.End_Date__c = selectedDoctorIdToContractWrapper.get(currentEditedId).contract.End_Date__c;
        inputFormContract.Start_Date__c = selectedDoctorIdToContractWrapper.get(currentEditedId).contract.Start_Date__c;
        setHireButtonReady ();
    }

    public void clearDialog() {
        inputFormDoctor = new Doctor__c();
        inputFormContract = new Contract__c();
        selectedDoctors = new List<HD_DoctorSelectWrapper>();
        foundWrappedDoctors = new List<HD_DoctorSelectWrapper>();
        selectedDoctorIdToContractWrapper.clear();
        for (HD_DoctorSelectWrapper doctor : foundWrappedDoctors) {
            if (doctor.doctor.Id == doctorRemoveId) {
                doctor.isSelected = false;
            }
        }
        currentEditedId = null;
        isReadyToHire = null;
    }

    public void saveEditedContract() {
        try {
            if (inputFormContract.End_Date__c < System.today()) {
                throw new DateException('End Date in past');
            }
            if (inputFormContract.Start_Date__c > inputFormContract.End_Date__c) {
                throw new DateException('End Date Before Start Date');
            }
            selectedDoctorIdToContractWrapper.get(currentEditedId).contract.Start_Date__c = inputFormContract.Start_Date__c;
            selectedDoctorIdToContractWrapper.get(currentEditedId).contract.End_Date__c = inputFormContract.End_Date__c;
            selectedDoctorIdToContractWrapper.get(currentEditedId).isOpenForEdit = false;
            selectedDoctorIdToContractWrapper.get(currentEditedId).status = 'Waiting';
            isReadyToHire = true;
            currentEditedId = null;
            inputFormContract = new Contract__c();
        } catch (DateException e) {
            ApexPages.addMessages(e);
        }
        setHireButtonReady ();
    }

    private void setHireButtonReady(){
        Set<Id> selectedDoctorIdToContractWrapperKeySet = selectedDoctorIdToContractWrapper.keySet();
        for (Id key : selectedDoctorIdToContractWrapperKeySet) {
            HD_ContractWrapper wrapedContract = selectedDoctorIdToContractWrapper.get(key);
            if (wrapedContract.contract.Start_Date__c == null || selectedDoctorIdToContractWrapperKeySet.size() == 0) {
                isReadyToHire = false;
            }
        }
    }


}