/**
 * Created by BRITENET on 01.03.2021.
 */

public with sharing class HD_DoctorImportCSVController {
    public Doctor__c currentDoctor { get; set; }
    public Blob inputCSV { get; set; }
    public List <HD_DoctorImportToCSVWrapper> inputDoctorsList { get; set; }
    public Boolean isDoctorsToImportSectionShowed { get; set; }
    public Boolean isImportPossible{get;set;}

    public HD_DoctorImportCSVController(ApexPages.StandardController standardController) {
        inputDoctorsList = new List<HD_DoctorImportToCSVWrapper>();
        isDoctorsToImportSectionShowed = false;
    }

    public void takeInputCSV() {

        inputDoctorsList = new List<HD_DoctorImportToCSVWrapper>();
        isDoctorsToImportSectionShowed = true;
        try {
            String csvAsString;
            List<String> csvFileLines;
            csvAsString = inputCSV.toString();
            csvFileLines = csvAsString.split('\r\n');
            for (Integer i = 0; i < csvFileLines.size(); i++) {
                Doctor__c doctor = new Doctor__c();
                String[] csvRecordData = csvFileLines[i].split(',');
                doctor.First_Name__c = csvRecordData[0].trim() ;
                doctor.Name = csvRecordData[1];
                doctor.Email__c = csvRecordData[2];
                doctor.Birthday_Date__c = Date.parse(csvRecordData[3]);
                HD_DoctorImportToCSVWrapper doctorWrapper = new HD_DoctorImportToCSVWrapper(doctor);
                doctorWrapper.status = 'Waiting';
                doctorWrapper.isSelected = false;
                inputDoctorsList.add(doctorWrapper);
            }
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
    }

    public void selectAll() {
        for(HD_DoctorImportToCSVWrapper wrapper :inputDoctorsList){
               wrapper.isSelected = true;
        }
    }
    public void selectReverse() {
        for(HD_DoctorImportToCSVWrapper wrapper :inputDoctorsList){
            if(wrapper.isSelected == true){
                wrapper.isSelected = false;
            }else {
                wrapper.isSelected = true;
            }

        }

    }
    public void selectNone() {
        for(HD_DoctorImportToCSVWrapper wrapper :inputDoctorsList){
            wrapper.isSelected = false;
        }
    }
    public void importDoctors() {
        List<Doctor__c> doctorsToInsert = new List<Doctor__c>();
        for(HD_DoctorImportToCSVWrapper wrapper: inputDoctorsList){
            if (wrapper.status !=  'success' && wrapper.isSelected == true) {
                doctorsToInsert.add(wrapper.doctor);
            }
        }

        List<Database.SaveResult> saveResults;
        Savepoint sp = Database.setSavepoint();
        saveResults = Database.insert(doctorsToInsert,false);
        System.debug('saveResults: ' + saveResults);
        Database.rollback(sp);

        Integer index = 0;
        if (saveResults.size() > 0) {
            for (Database.SaveResult result: saveResults){
                if (result.success) {

                }
                index ++;
            }
        }
    }

    public void isNoneSelectedCheck(){
        isImportPossible = false;
        for(HD_DoctorImportToCSVWrapper wrapper :inputDoctorsList){
            if(wrapper.isSelected == true){
                isImportPossible = true;
            }

        }
    }

}