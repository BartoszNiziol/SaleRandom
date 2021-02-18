/**
 * Created by BRITENET on 17.02.2021.
 */

public without sharing class HD_PlygroundController {

    public Doctor__c doctor { get; set; }
    public Hospital__c inputFormHospital {get; set;}
    public List<Hospital__c> foundHospitals {get; set;}
    public HD_HospitalSearchHelper helper;


   public HD_PlygroundController(ApexPages.StandardController standardController) {
        doctor = new Doctor__c();
        helper = new HD_HospitalSearchHelper();
       foundHospitals = new List<Hospital__c>();
        inputFormHospital = new Hospital__c();

    }

    public void searchHospital() {
        System.debug(inputFormHospital);
         foundHospitals = helper.queryHospitals(inputFormHospital.Name, inputFormHospital.Email__c, inputFormHospital.Country__c);

//        setController = new ApexPages.StandardSetController(foundDoctors);
//        setController.setPageSize(pageSize);
//        foundDoctors = (List<Doctor__c>) setController.getRecords();
    }

    public void clear() {
        foundHospitals = new List<Hospital__c>();
        inputFormHospital = new Hospital__c();
    }

}


