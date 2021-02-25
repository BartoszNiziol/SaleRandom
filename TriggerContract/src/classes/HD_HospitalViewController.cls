/**
 * Created by BRITENET on 24.02.2021.
 */

public with sharing class HD_HospitalViewController {

    public Doctor__c inputFormDoctor { get; set; }
    public Hospital__c currentHospital { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public Id selectedDoctorId { get; set; }
    public List<Id> selectedDoctorsIds { get; set; }
    public List<HD_DoctorSelectWrapper> foundWrappedDoctors { get; set; }
    public List<HD_DoctorSelectWrapper> selectedDoctors { get; set; }
    public List<Contract__c> newContracts { get; set; }
    public HD_DoctorHandler doctorHandler;
    public Id doctorRemoveId { get; set; }
    public Id templateId { get; set; }
    public Map<Id, HD_ContractWrapper> selectedDoctorIdToContractWrapper { get; set; }
    public Id currentEditedId {get;set;}
    public Contract__c inputFormContract{get;set;}


    public HD_HospitalViewController(ApexPages.StandardController standardController) {
        doctorHandler = new HD_DoctorHandler();
        currentHospital = (Hospital__c) standardController.getRecord();
        inputFormDoctor = new Doctor__c();
        foundWrappedDoctors = new List<HD_DoctorSelectWrapper>();
        selectedDoctors = new List<HD_DoctorSelectWrapper>();
        selectedDoctorIdToContractWrapper = new Map<Id, HD_ContractWrapper>();
        inputFormContract = new Contract__c();
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
        HD_ContractWrapper contractWrapper = new HD_ContractWrapper(freshContract);

        selectedDoctorIdToContractWrapper.put(selectedDoctorId, contractWrapper);
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
        Integer beforeClearMapSize = selectedDoctorIdToContractWrapper.size();
        selectedDoctorIdToContractWrapper.clear();
        for(Integer i =0; i<beforeClearMapSize; i++){
            selectedDoctorIdToContractWrapper.put(templateId,tempContract);
        }
    }
    public void cancelDialog(){

    }
    public void hire(){


    }

    public void editContract(){

        selectedDoctorIdToContractWrapper.get(currentEditedId).isOpenForEdit = true;

    }

    public void saveEditedContract(){

        try {
            if (inputFormContract.End_Date__c<System.today()) {
                throw new DateException('End Date in past');
            }
            if (inputFormContract.Start_Date__c > inputFormContract.End_Date__c) {
                throw new DateException('End Date Before Start Date');
            }


            selectedDoctorIdToContractWrapper.get(currentEditedId).contract.Start_Date__c = inputFormContract.Start_Date__c;
            selectedDoctorIdToContractWrapper.get(currentEditedId).contract.End_Date__c = inputFormContract.End_Date__c;
            selectedDoctorIdToContractWrapper.get(currentEditedId).isOpenForEdit = false;

        }catch (DateException e){
            ApexPages.addMessages(e);

        }

    }

    public void debug (){
            System.debug('selectedDoctorIdToContract');
            System.debug(selectedDoctorIdToContractWrapper);
    }


}