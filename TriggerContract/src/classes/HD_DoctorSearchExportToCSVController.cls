
public with sharing class HD_DoctorSearchExportToCSVController {

    String firstName = System.currentPageReference().getParameters().get('firstName');
    String surname = System.currentPageReference().getParameters().get('Name');
    String email = System.currentPageReference().getParameters().get('email');
    String country = System.currentPageReference().getParameters().get('country');
    String nowDT = String.valueOf(System.now());

    public List<Doctor__c> foundDoctors { get; set; }
    HD_DoctrSearchHelper searchHelper = new HD_DoctrSearchHelper();
    public String header ='FullName,Email,Country';

    public HD_DoctorSearchExportToCSVController(ApexPages.StandardController standardController) {
        foundDoctors = new List<Doctor__c>();

    }

    public void setCsv(){
        foundDoctors = searchHelper.queryDoctors(firstName, surname, email, country, null ,null );

    }





}