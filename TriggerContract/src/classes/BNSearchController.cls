

public with sharing class BNSearchController {

    public Doctor__c doctor{get;set;}
    public List<Doctor__c> foundDoctors{get;set;}
    BNSearchHelper searchHelper = new BNSearchHelper();

    public BNSearchController(){
        doctor = new Doctor__c();
        foundDoctors = new List<Doctor__c>();
    }

    public void search(){
        foundDoctors= searchHelper.queryDoctors(doctor.First_Name__c,doctor.Name,doctor.Email__c,doctor.Country__c);
    }

    public void clear(){
        foundDoctors = new List<Doctor__c>();
        doctor = new Doctor__c();
    }
}