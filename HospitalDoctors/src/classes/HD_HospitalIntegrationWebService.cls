/**
 * Created by BRITENET on 21.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class HD_HospitalIntegrationWebService {

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
                hospitalsToUpsert.add(hospital);
            }
            try {
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospitalsToUpsert;
            }finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
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
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                delete hospitalsToDelete;
            } finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug(errorResponse(e));
        }
    }
    @HttpPut
    global static void updateHospitalExternalId() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString());
            List<Hospital__c> hospitalsWithID = new List<Hospital__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;
                String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
                String hospitalId = (String) params.get('Id');
                Hospital__c hospital = new Hospital__c();
                hospital.Id = hospitalId;
                hospital.Hospital_External_Id__c = hospitalExternalId;

                Map<String,String> headers= RestContext.request.headers;
                if (headers.get('isSync') == 't') {
                    hospital.is_Synchronized__c = true;
                }else {
                    hospital.is_Synchronized__c = false;
                }
                hospitalsWithID.add(hospital);
            }
            try {
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospitalsWithID;
            } finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
        }catch (Exception e){

            System.debug(e);
        }
    }

    private static HD_HospitalResonseWrapper errorResponse(Exception e) {
        HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }

}