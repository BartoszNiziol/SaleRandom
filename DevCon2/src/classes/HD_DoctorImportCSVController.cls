/**
 * Created by BRITENET on 01.03.2021.
 */

public with sharing class HD_DoctorImportCSVController {
    public Blob inputCSV { get; set; }
    public Map <Integer,HD_DoctorImportToCSVWrapper> indexToInputDoctorMap { get; set; }
    public Boolean isDoctorsToImportSectionShowed { get; set; }
    public Boolean isImportPossible{get;set;}

    public HD_DoctorImportCSVController(ApexPages.StandardController standardController) {
        indexToInputDoctorMap = new Map<Integer, HD_DoctorImportToCSVWrapper>();
        isDoctorsToImportSectionShowed = false;
    }

    public void takeInputCSV() {
            Integer indexCounter = 0;
        indexToInputDoctorMap = new Map<Integer, HD_DoctorImportToCSVWrapper>();
        isDoctorsToImportSectionShowed = true;
        try {
            String csvAsString;
            List<String> csvFileLines;
            csvAsString = inputCSV.toString();
            csvFileLines = csvAsString.split('\r\n');
            for (Integer i = 1; i < csvFileLines.size(); i++) {
                Doctor__c doctor = new Doctor__c();
                String[] csvRecordData = csvFileLines[i].split(',');
                doctor.First_Name__c = csvRecordData[0].trim() ;
                doctor.Name = csvRecordData[1];
                doctor.Email__c = csvRecordData[2];
                doctor.Birthday_Date__c = Date.parse(csvRecordData[3]);
                HD_DoctorImportToCSVWrapper doctorWrapper = new HD_DoctorImportToCSVWrapper(doctor);
                doctorWrapper.status = 'Waiting';
                doctorWrapper.isSelected = false;
                indexToInputDoctorMap.put(indexCounter,doctorWrapper);
                indexCounter ++;
            }
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while importing data Please make sure that csv input file is correct');
            ApexPages.addMessage(errorMessage);
        }
    }

    public void selectAll() {
        for(Integer id : indexToInputDoctorMap.keySet()){
            indexToInputDoctorMap.get(id).isSelected = true;
        }
    }

    public void selectReverse() {
        for(Integer id : indexToInputDoctorMap.keySet()){
            if(indexToInputDoctorMap.get(id).isSelected == true){
                indexToInputDoctorMap.get(id).isSelected = false;
            }else {
                indexToInputDoctorMap.get(id).isSelected = true;
            }
        }
    }

    public void selectNone() {
        for(Integer id : indexToInputDoctorMap.keySet()){
            indexToInputDoctorMap.get(id).isSelected = false;
        }
    }

    public void importDoctors() {
        List<Doctor__c> doctorsToInsert = new List<Doctor__c>();
        for(Integer id : indexToInputDoctorMap.keySet()){
            if (indexToInputDoctorMap.get(id).status !=  'success' && indexToInputDoctorMap.get(id).isSelected == true) {
                doctorsToInsert.add(indexToInputDoctorMap.get(id).doctor);
                indexToInputDoctorMap.get(id).selectedForImport = true;
            }
        }
        List<Database.SaveResult> saveResults;
        saveResults = Database.insert(doctorsToInsert,false);
        Integer indexResult = 0;
        if(saveResults.size() > 0) {
            for (Integer id : indexToInputDoctorMap.keySet()) {
                if (indexToInputDoctorMap.get(id).selectedForImport == true) {
                    if (saveResults.get(indexResult).success) {
                        indexToInputDoctorMap.get(id).status = 'success';
                        indexToInputDoctorMap.get(id).selectedForImport = false;
                    }
                    else {
                        indexToInputDoctorMap.get(id).status = '';
                        List<Database.Error> errors = saveResults.get(indexResult).errors;
                        for (Database.Error error :errors ){
                            indexToInputDoctorMap.get(id).status += error.message+' | ';
                        }
                        indexToInputDoctorMap.get(id).selectedForImport = false;
                    }
                    indexResult++;
                }
            }
        }
    }
}