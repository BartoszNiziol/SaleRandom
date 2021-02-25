/**
 * Created by BRITENET on 24.02.2021.
 */

public with sharing class HD_HospitalViewController {

    public Doctor__c inputFormDoctor {get;set;}
    public Hospital__c currentHospital{get;set;}
    public List<Doctor__c> foundDoctors{get;set;}
    public Id selectedDoctorId{get;set;}
    public List<Id> selectedDoctorsIds {get;set;}
    public List<Doctor__c> selectedDoctors{get;set;}
    public List<Contract__c> newContracts {get;set;}
    public HD_DoctorHandler doctorHandler;


    public HD_HospitalViewController(ApexPages.StandardController standardController){
        doctorHandler = new HD_DoctorHandler();
        currentHospital =(Hospital__c) standardController.getRecord();
        inputFormDoctor = new Doctor__c();
        selectedDoctors = new List<Doctor__c>();
    }
    public void searchDoctors(){

        foundDoctors = doctorHandler.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c);
    }
    public void clear(){

    }
    public void selectDoctor(){

        Doctor__c selectedDoctor = [SELECT Id,First_Name__c,Name FROM Doctor__c WHERE Id =:selectedDoctorId LIMIT 1];
        if(!selectedDoctors.contains(selectedDoctor)){
            selectedDoctors.add(selectedDoctor);

         //   selectedDoctorsIds.add(selectedDoctorId);
        }

    }
    public Boolean isInSelectedDoctorsList(Id doctorId){

        if(selectedDoctorsIds.contains(doctorId)){
            return true;
        }
       return false;
    }





}