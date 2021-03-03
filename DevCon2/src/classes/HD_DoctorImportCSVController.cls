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
        isDoctorsToImportSectionShowed = false;
            Integer indexCounter = 0;
        indexToInputDoctorMap = new Map<Integer, HD_DoctorImportToCSVWrapper>();

        try {

            List<Doctor__c> doctorsToWrap;
            String csvAsString;
            List<String> csvFileLines;
            csvAsString = inputCSV.toString();
            csvFileLines = csvAsString.split('\r\n');

            if(!((csvFileLines[0].trim() == Label.CSV_title_with_singleQuotes)|
            (csvFileLines[0].trim() == Label.CSV_title_with_doubleQuotes)|
            (csvFileLines[0].trim() == Label.CSV_title_without_quotes))) {
                throw new DateException('');
            }
            doctorsToWrap = parseWithDifferentQuotes(csvFileLines);

            for (Doctor__c doctor : doctorsToWrap) {
                HD_DoctorImportToCSVWrapper doctorWrapper = new HD_DoctorImportToCSVWrapper(doctor);
                doctorWrapper.status = Label.Waiting_Label;
                doctorWrapper.isSelected = false;
                indexToInputDoctorMap.put(indexCounter, doctorWrapper);
                indexCounter++;
            }
            isDoctorsToImportSectionShowed = true;
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSV_Input_Error_Label);
            ApexPages.addMessage(errorMessage);
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

    private String removeSingleQuotes(String str){
        if ((str.startsWith('\'') && str.endsWith('\'')) || str.startsWith('\"') && str.endsWith('\"') ) {
                String clearedString = str.mid(1,str.length()-2);
            return clearedString;
        }
       return str;
    }

    private List<Doctor__c> parseWithDifferentQuotes (List<String> csvFileLines){
        List<Doctor__c> doctors = new List<Doctor__c>();
        Integer count = 0;
        for (Integer i = 1; i < csvFileLines.size(); i++) {
            System.debug('count: ' + count);
            Doctor__c doctor = new Doctor__c();
            if (csvFileLines.get(i).startsWith('\"')) {
                String[] csvRecordData = csvFileLines[i].split('\"');
                doctor.First_Name__c = removeSingleQuotes(csvRecordData[1]) ;
                doctor.Name = removeSingleQuotes(csvRecordData[3]);
                doctor.Email__c = removeSingleQuotes(csvRecordData[5]);
                doctor.Birthday_Date__c = Date.parse(removeSingleQuotes(csvRecordData[7]));
                doctors.add(doctor);
            }
            else if(csvFileLines.get(i).startsWith('\'')) {
                System.debug('weszlo ?');
                String[] csvRecordData = csvFileLines[i].split('\'');
                doctor.First_Name__c = removeSingleQuotes(csvRecordData[1]) ;
                doctor.Name = removeSingleQuotes(csvRecordData[3]);
                doctor.Email__c = removeSingleQuotes(csvRecordData[5]);

                doctor.Birthday_Date__c = Date.parse(removeSingleQuotes(csvRecordData[7]));
                doctors.add(doctor);
            }else {
                String[] csvRecordData = csvFileLines[i].split(',');
                doctor.First_Name__c = removeSingleQuotes(csvRecordData[0]) ;
                doctor.Name = removeSingleQuotes(csvRecordData[1]);
                doctor.Email__c = removeSingleQuotes(csvRecordData[2]);
                doctor.Birthday_Date__c = Date.parse(removeSingleQuotes(csvRecordData[3]));
                doctors.add(doctor);
            }
            count++;
        }
        return doctors;
    }
}