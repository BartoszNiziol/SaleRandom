
public with sharing class HD_DoctorSearchExportToCSVController {

    String firstName = System.currentPageReference().getParameters().get('firstName');
    String surname = System.currentPageReference().getParameters().get('Name');
    String email = System.currentPageReference().getParameters().get('email');
    String country = System.currentPageReference().getParameters().get('country');

    public List<Doctor__c> foundDoctors { get; set; }
    HD_SearchForDoctorSearchHelper searchHelper = new HD_SearchForDoctorSearchHelper();
    public String header ='FullName,Email,Country';

    public HD_DoctorSearchExportToCSVController(ApexPages.StandardController standardController) {
        foundDoctors = new List<Doctor__c>();

    }

    public void setCsv(){
        foundDoctors = searchHelper.queryDoctorsWithoutOrder(firstName, surname, email, country);

    }





}