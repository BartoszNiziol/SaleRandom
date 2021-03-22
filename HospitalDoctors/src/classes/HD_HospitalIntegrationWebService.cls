/**
 * Created by BRITENET on 21.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class HD_HospitalIntegrationWebService {

    @HttpPost
    global static void upsertHospital() {
        System.debug('enter upsert');
        try {
            Map<String, Object> params;
            List <Object> responseJ = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            for (Object obj : responseJ) {
                params = (Map<string, Object>) obj;
            }
            String name = (String) params.get('Name');
            String email = (String) params.get('Email__c');
            String country = (String) params.get('Country__c');
            String city = (String) params.get('City__c');
            String id = (String) params.get('Id');
            String webPage = (String) params.get('Web_Page__c');
            String street = (String) params.get('Street__c');
            String phoneNumber = (String) params.get('Phone_Number__c');
            String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
            Hospital__c hospital = new Hospital__c();
            hospital.Name = name;
            hospital.Email__c = email;
            hospital.Country__c = country;
            hospital.City__c = city;
            hospital.Web_Page__c = webPage;
            hospital.Street__c = street;
            hospital.Phone_Number__c = phoneNumber;
            hospital.Hospital_External_Id__c = id;
            hospital.Id = hospitalExternalId;
            try {
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospital;
            } finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
            RestContext.response.addHeader('addedId',hospital.Id);
            RestContext.response.addHeader('externalId',hospital.Hospital_External_Id__c);

        } catch (Exception e) {
            System.debug(e);
        }
    }

    @HttpDelete
    global static void deleteHospital() {
        try {
            Map<String, Object> params;
            List <Object> responseJ = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            for (Object obj : responseJ) {
                params = (Map<string, Object>) obj;
            }
            String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
            Hospital__c hospital = new Hospital__c();
            hospital.Id = hospitalExternalId;

            try {
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                delete hospital;
            } finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }

        } catch (Exception e) {
            System.debug( errorResponse(e));
        }
    }

    private static HD_HospitalResonseWrapper errorResponse(Exception e) {
        HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }

}