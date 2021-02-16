/**
 * Created by BRITENET on 15.02.2021.
 */

public with sharing class HD_ExportCsvSearchForDoctorController {

    String firstName = System.currentPageReference().getParameters().get('firstName');
    String surname = System.currentPageReference().getParameters().get('Name');
    String email = System.currentPageReference().getParameters().get('email');
    String country = System.currentPageReference().getParameters().get('country');



    public List<Doctor__c> foundDoctors { get; set; }
    HD_SearchForDoctorSearchHelper searchHelper = new HD_SearchForDoctorSearchHelper();
    public String header ='FullName,Email,Country';

    public HD_ExportCsvSearchForDoctorController(ApexPages.StandardController standardController) {

        foundDoctors = new List<Doctor__c>();

    }

    public void setCsv(){
        System.debug('First Name : ' + firstName);
        System.debug('Surname : ' + surname);
        System.debug('Email : ' + email);
        System.debug('Country : ' + country);
        foundDoctors = searchHelper.queryDoctorsWithoutOrder(firstName, surname, email, country);
        System.debug(foundDoctors);
    }





}