/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class DB_HospitalIntegrationWebService {


    @HttpPost
    global static void upsertHospital() {
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
            String id = (String) params.get('Id');
            String webPage = (String) params.get('Web_Page__c');
            String street = (String) params.get('Street__c');
            String phoneNumber = (String) params.get('Phone_Number__c');
            String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
            Hospital__c hospital = new Hospital__c();
            hospital.Name = name;
            hospital.Email__c = email;
            hospital.Country__c = country;
            hospital.Web_Page__c = webPage;
            hospital.Street__c = street;
            hospital.Phone_Number__c = phoneNumber;
            upsert hospital;

            HospitalResponseWrapper wrapper = new HospitalResponseWrapper(hospital);
        } catch (Exception e) {
            System.debug(e);
        }
    }

    @HttpDelete
    global static HospitalResponseWrapper deleteHospital() {
        try {
            RestRequest req = RestContext.request;
            Map<String, String> requestParams = req.params;
            String id = requestParams.get('id');
            Hospital__c hospital = new Hospital__c();
            hospital.Id = id;
            delete hospital;
            HospitalResponseWrapper wrapper = new HospitalResponseWrapper(hospital);
            return wrapper;
        } catch (Exception e) {
            return errorResponse(e);
        }
    }


    private static HospitalResponseWrapper errorResponse(Exception e) {
        HospitalResponseWrapper wrapper = new HospitalResponseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }

//    private checkNullStringValue(String name, String email, String country, String id, String webPage, String street, String phoneNumber) {
//        if (name == 'null') name = null;
//        if (email == 'null') email = null;
//        if (country == 'null') country = null;
//        if (id == 'null') id = null;
//        if (webPage == 'null') webPage = null;
//        if (street == 'null') street = null;
//        if (phoneNumber == 'null') phoneNumber = null;
//    }


}