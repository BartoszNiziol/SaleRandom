/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/DoctorIntegration')
global class HD_DoctorIntegrationWebService {

    @HttpPost
    global static void upsertDoctor() {
        try {
            Map<String, Object> params;
            List <Object> responseJ = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            System.debug(responseJ);
            for (Object obj : responseJ) {
                params = (Map<string, Object>) obj;
            }
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
            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                upsert doctor;
            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
            RestContext.response.addHeader('addedId', doctor.Id);
            RestContext.response.addHeader('externalId', doctor.Doctor_External_Id__c);
        } catch (Exception e) {
            System.debug('upsertDoctorService');
            System.debug(e);
        }
    }
    @HttpDelete
    global static void deleteDoctor() {
        try {
            Map<String, Object> params;
            List <Object> responseJ = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            System.debug(responseJ);
            for (Object obj : responseJ) {
                params = (Map<string, Object>) obj;
            }
            String doctorExternalId = (String) params.get('Doctor_External_Id__c');
            Doctor__c doctor = new Doctor__c();
            doctor.Id = doctorExternalId;
            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                delete doctor;

            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug('deleteDoctorService');
            System.debug(e);
        }
    }


}