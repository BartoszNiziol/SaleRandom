

public with sharing class BNSearchController {

    public Doctor__c doctor{get;set;}
    public List<Doctor__c> foundDoctors{get;set;}
    BNSearchHelper searchHelper = new BNSearchHelper();


    public BNSearchController(){
        doctor = new Doctor__c();
    }

    public void search(){
        System.debug(doctor.First_Name__c);
        System.debug(doctor.Name);
        System.debug(doctor.Email__c);
        System.debug(doctor.Country__c);

        foundDoctors= searchHelper.queryDoctors(doctor.First_Name__c,doctor.Name,doctor.Email__c,doctor.Country__c);

    }
    public void clear(){
        foundDoctors = new List<Doctor__c>();
        doctor = new Doctor__c();

    }


}