/**
 * Created by BRITENET on 02.03.2021.
 */

public with sharing class HD_DoctorImportToCSVWrapper {

    public Doctor__c doctor {get;set;}
    public Boolean isSelected {get;set;}
    public String status {get;set;}
    public Integer index {get;set;}
    public Boolean selectedForImport{get;set;}
    public HD_DoctorImportToCSVWrapper (Doctor__c doctor){
        this.doctor = doctor;
    }

}