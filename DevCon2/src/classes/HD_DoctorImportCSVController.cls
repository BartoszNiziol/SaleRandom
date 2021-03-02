/**
 * Created by BRITENET on 01.03.2021.
 */

public with sharing class HD_DoctorImportCSVController {
    public Doctor__c currentDoctor { get; set; }
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
                indexToInputDoctorMap.put(indexCounter,doctorWrapper);
                indexCounter ++;
            }
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while importin data Please make sure input csv file is correct');
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
        Savepoint sp = Database.setSavepoint();
        saveResults = Database.insert(doctorsToInsert,false);
        System.debug('saveResults: ' + saveResults);
        Database.rollback(sp);

       Integer indexResult = 0;
        for(Integer id: indexToInputDoctorMap.keySet()){
            if (indexToInputDoctorMap.get(id).selectedForImport == true) {
                if(saveResults.get(indexResult).success){
                    indexToInputDoctorMap.get(id).status ='success';
                }
                    indexResult++;
            }


        }


    }
    private void deactivateSelectedForImport(){
        for(Integer id : indexToInputDoctorMap.keySet()){
                indexToInputDoctorMap.get(id).selectedForImport = false;
            }
        }



//    public void isNoneSelectedCheck(){
//        isImportPossible = false;
//        for(HD_DoctorImportToCSVWrapper wrapper :inputDoctorsList){
//            if(wrapper.isSelected == true){
//                isImportPossible = true;
//            }
//
//        }
//    }

}