/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class DB_HospitalIntegrationWebService {

    @HttpPost
    global static void upsertHospital() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Hospital__c> hospitalsToUpsert = new List<Hospital__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = new Map<String, Object>();
                params = (Map<string, Object>) obj;
                Hospital__c hospital = new Hospital__c();
                hospital.Name = (String) params.get('Name');
                hospital.Email__c = (String) params.get('Email__c');
                hospital.Country__c = (String) params.get('Country__c');
                hospital.City__c = (String) params.get('City__c');
                hospital.Web_Page__c = (String) params.get('Web_Page__c');
                hospital.Street__c = (String) params.get('Street__c');
                hospital.Phone_Number__c = (String) params.get('Phone_Number__c');
                hospital.Hospital_External_Id__c = (String) params.get('Id');
                hospital.Id = (String) params.get('Hospital_External_Id__c');
                hospital.is_Synchronized__c = true;
                hospitalsToUpsert.add(hospital);
            }
            try {
                DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospitalsToUpsert;
            }finally {
                DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
            Integer counter = 0;
            for (Hospital__c hosp: hospitalsToUpsert){
                RestContext.response.addHeader('addedId'+counter, hosp.Id);
                RestContext.response.addHeader('externalId'+counter, hosp.Hospital_External_Id__c);
                counter++;
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }

    @HttpDelete
    global static void deleteHospital() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Hospital__c> hospitalsToDelete = new List<Hospital__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;

                String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
                Hospital__c hospital = new Hospital__c();
                hospital.Id = hospitalExternalId;
                hospitalsToDelete.add(hospital);
            }
            try {
                DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                delete hospitalsToDelete;
            } finally {
                DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug(errorResponse(e));
        }
    }

    private static HospitalResponseWrapper errorResponse(Exception e) {
        HospitalResponseWrapper wrapper = new HospitalResponseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }
}