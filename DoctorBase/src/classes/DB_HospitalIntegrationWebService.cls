/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class DB_HospitalIntegrationWebService {

    @HttpPost
    global static void upsertHospital() {
        try {
            Map<String, Object> params;
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            for (Object obj : responseJSON) {
                params = (Map<string, Object>) obj;
            }
            Hospital__c hospital = new Hospital__c();
            hospital.Name = (String) params.get('Name');
            hospital.Email__c = (String) params.get('Email__c');
            hospital.Country__c = (String) params.get('Country__c');
            hospital.City__c = (String) params.get('City__c');
            hospital.Web_Page__c = (String) params.get('Web_Page__c');
            hospital.Street__c = (String) params.get('Street__c');
            hospital.Phone_Number__c =(String) params.get('Phone_Number__c');
            hospital.Hospital_External_Id__c = (String) params.get('Id');
            hospital.Id = (String) params.get('Hospital_External_Id__c');
            try {
                DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospital;
            }finally {
                DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
            RestContext.response.addHeader('addedId', hospital.Id);
            RestContext.response.addHeader('externalId', hospital.Hospital_External_Id__c);

        } catch (Exception e) {
            System.debug(e);
        }
    }

    @HttpDelete
    global static void deleteHospital() {
        try {
            Map<String, Object> params;
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            for (Object obj : responseJSON) {
                params = (Map<string, Object>) obj;
            }
            String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
            Hospital__c hospital = new Hospital__c();
            hospital.Id = hospitalExternalId;
            try {
                DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                delete hospital;
            }finally {
                DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug( errorResponse(e));
        }
    }

    private static HospitalResponseWrapper errorResponse(Exception e) {
        HospitalResponseWrapper wrapper = new HospitalResponseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }
}