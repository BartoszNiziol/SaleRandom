/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/DoctorIntegration')
global class HD_DoctorIntegrationWebService {

    @HttpPost
    global static void upsertDoctor() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Doctor__c> doctorsToUpsert = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = new Map<String, Object>();
                params = (Map<string, Object>) obj;
                Doctor__c doctor = new Doctor__c();
                doctor.Name = (String) params.get('Name');
                doctor.First_Name__c = (String) params.get('First_Name__c');
                doctor.Email__c = (String) params.get('Email__c');
                doctor.Country__c = (String) params.get('Country__c');
                doctor.City__c = (String) params.get ('City__c');
                if ((Integer) params.get('License_Number__c') != null) {
                    doctor.License_Number__c = Decimal.valueOf((Integer) params.get('License_Number__c'));
                }
                if ((String) params.get('Birthday_Date__c') != null) {
                    doctor.Birthday_Date__c = Date.valueOf((String) params.get('Birthday_Date__c'));
                }
                doctor.Street__c = (String) params.get('Street__c');
                doctor.Phone_Number__c = (String) params.get('Phone_Number__c');
                doctor.Doctor_External_Id__c = (String) params.get('Id');
                doctor.Id = (String) params.get('Doctor_External_Id__c');
                doctorsToUpsert.add(doctor);
            }
            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                upsert doctorsToUpsert;
            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
            System.debug('doctorsToUpsert');
            System.debug(doctorsToUpsert);
            Integer counter = 0;
            for (Doctor__c doc : doctorsToUpsert) {
                RestContext.response.addHeader('addedId' + counter, doc.Id);
                RestContext.response.addHeader('externalId' + counter, doc.Doctor_External_Id__c);
                counter ++ ;
            }
        } catch (Exception e) {
            System.debug('upsertDoctorService');
            System.debug(e);
        }
    }
    @HttpDelete
    global static void deleteDoctor() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );

            List<Doctor__c> doctorsToDelete = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;
                String doctorExternalId = (String) params.get('Doctor_External_Id__c');
                Doctor__c doctor = new Doctor__c();
                doctor.Id = doctorExternalId;
                doctorsToDelete.add(doctor);
                if((String) params.get('Doctor_External_Id__c') == null){
                    throw new IntegrationException('External Id expected');
                }
            }
            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                delete doctorsToDelete;
            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    @Put
    global static void updateDoctorExternalId(){

            }


}