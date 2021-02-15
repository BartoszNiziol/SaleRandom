

public with sharing class HD_SearchForDoctorController {

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    HD_SearchForDoctorSearchHelper searchHelper = new HD_SearchForDoctorSearchHelper();


    public HD_SearchForDoctorController(ApexPages.StandardController standardController) {
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();
        foundDoctors = new List<Doctor__c>();
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c);
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }

   public void sortFullName(){

   }
}