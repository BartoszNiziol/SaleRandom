/**
 * Created by BRITENET on 24.02.2021.
 */

public with sharing class HD_HospitalViewController {

    public Doctor__c inputFormDoctor {get;set;}
    public Hospital__c currentHospital{get;set;}
    public List<Doctor__c> foundDoctors{get;set;}
    public Id selectedDoctorId{get;set;}
    public List<Id> selectedDoctorsIds {get;set;}
    public List<DoctorSelectWrapper> foundWrappedDoctors {get;set;}
    public List<DoctorSelectWrapper> selectedDoctors {get;set;}
    public List<Contract__c> newContracts {get;set;}
    public HD_DoctorHandler doctorHandler;
    public Id  doctorRemoveId{get;set;}
    public Id templateId {get;set;}


    public HD_HospitalViewController(ApexPages.StandardController standardController){
        doctorHandler = new HD_DoctorHandler();
        currentHospital =(Hospital__c) standardController.getRecord();
        inputFormDoctor = new Doctor__c();
        foundWrappedDoctors = new List<DoctorSelectWrapper>();
        selectedDoctors = new List<DoctorSelectWrapper>();
    }
    public void searchDoctors(){

        foundWrappedDoctors = new List<DoctorSelectWrapper>();

        foundDoctors = doctorHandler.queryDoctorsOR(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c);
        for (Doctor__c doc : foundDoctors){
            DoctorSelectWrapper requestedToAddDoctor= new DoctorSelectWrapper(doc);

            if (selectedDoctors.contains(requestedToAddDoctor)) {
                requestedToAddDoctor.isSelected = true;
            }
            foundWrappedDoctors.add(requestedToAddDoctor);
        }
    }
    public void selectDoctor(){
        for(DoctorSelectWrapper doctor:foundWrappedDoctors){
            if (doctor.doctor.Id == selectedDoctorId) {
                    doctor.isSelected = true;
            }
        }
        Doctor__c selectedDoctor = [SELECT Id,First_Name__c,Name FROM Doctor__c WHERE Id =:selectedDoctorId LIMIT 1];
            selectedDoctors.add(new DoctorSelectWrapper(selectedDoctor,true));
    }
    public void remove(){
            List<Integer> indexesToRemove = new List<Integer>();

        for(DoctorSelectWrapper doctor : foundWrappedDoctors){
            if(doctor.doctor.Id == doctorRemoveId){
                doctor.isSelected = false;
            }
        }
        for(DoctorSelectWrapper doctor : selectedDoctors){
            if(doctor.doctor.Id == doctorRemoveId){
                indexesToRemove.add(selectedDoctors.indexOf(doctor));
            }
        }
        for(Integer i : indexesToRemove){
            selectedDoctors.remove(i);
        }
    }

    public void clear(){
        inputFormDoctor.First_Name__c = null;
        inputFormDoctor.Name = null;
        inputFormDoctor.Email__c = null;
        inputFormDoctor.Country__c = null;
        foundWrappedDoctors = new List<DoctorSelectWrapper>();
    }
    public void template(){


        for (DoctorSelectWrapper doc : selectedDoctors){



        }
    }






}