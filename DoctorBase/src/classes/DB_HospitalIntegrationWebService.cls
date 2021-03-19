/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/Integration/Hospital')
global class DB_HospitalIntegrationWebService {


    @HttpPost
    global static List<HospitalResponseWrapper> upsertHospital() {
        try {
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            for ()
            String name = (String) params.get('name');
            String email = (String) params.get('email');
            String country = (String) params.get('country');
            String id = (String) params.get('id');
            String webPage = (String) params.get('webPage');
            String street = (String) params.get('street');
            String phoneNumber = (String) params.get('phoneNumber');
            String doctorExternalId = (String) params.get('doctorExternalId');
            if (name == 'null') name = null;
            if (email == 'null') email = null;
            if (country == 'null') country = null;
            if (id == 'null') id = null;
            if (webPage == 'null') webPage = null;
            if (street == 'null') street = null;
            if (phoneNumber == 'null') phoneNumber = null;
            Hospital__c hospital = new Hospital__c();
            hospital.Name = name;
            hospital.Email__c = email;
            hospital.Country__c = country;
            hospital.Id = id;
            hospital.Web_Page__c = webPage;
            hospital.Street__c = street;
            hospital.Phone_Number__c = phoneNumber;

            upsert hospital;
            HospitalResponseWrapper wrapper = new HospitalResponseWrapper(hospital);
            return wrapper;
        } catch (Exception e) {
            return errorResponse(e);
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