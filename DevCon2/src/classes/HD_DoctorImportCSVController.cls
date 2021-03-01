/**
 * Created by BRITENET on 01.03.2021.
 */

public with sharing class HD_DoctorImportCSVController {
    public Doctor__c currentDoctor{get;set;}

    public HD_DoctorImportCSVController(ApexPages.StandardController standardController){
        currentDoctor = (Doctor__c) standardController.getRecord();


    }

}