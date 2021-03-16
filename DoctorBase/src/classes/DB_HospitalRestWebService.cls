/**
 * Created by BRITENET on 15.03.2021.
 */
@RestResource(urlMapping = '/Hospital')
global class DB_HospitalRestWebService {


    @HttpGet
    global static List<HospitalResponseWrapper> getHospitals() {
        try {
            RestRequest req = RestContext.request;
            Map<String, String> requestParams = req.params;
            System.debug(requestParams);
            String name = requestParams.get('name');
            String email = requestParams.get('email');
            String country = requestParams.get('country');
            if (email != null) {
                email = email.toLowerCase();
            }
            if(email == ''){
                email = null;
            }

            List<HospitalResponseWrapper> result = DB_HospitalHandler.queryHospitals(name, email, country);
            System.debug(result);
            return result;

        } catch (Exception e) {
            List<HospitalResponseWrapper> wrap = new List<HospitalResponseWrapper>();
            wrap.add(errorResponse(e));
            return wrap;
        }
    }

    @HttpPost
    global static HospitalResponseWrapper upsertHospital() {

        try {
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            System.debug(params);
            String name = (String) params.get('name');
            String email = (String) params.get('email');
            String country = (String) params.get('country');
            String id = (String) params.get('id');

            if(name == 'null'){
                name = null;
            }
            if(email == 'null'){
                email = null;
            }
            if(country == 'null'){
                country = null;
            }
            if(id == 'null'){
                id = null;
            }

            Hospital__c hospital = new Hospital__c();
            hospital.Name = name;
            hospital.Email__c = email;
            hospital.Country__c = country;
            hospital.Id = id;
            System.debug(hospital);
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

    @HttpPut
    global static DB_HospitalCountriesResponseWrapper deployCountries() {
        try {
            String[] singleCountries = DB_Utils.retrieveAvalibleCountries().split(',');
            List<String> pickListValuesList = new List<String>();
            for (String country : singleCountries) {
                pickListValuesList.add(country);
            }
            DB_HospitalCountriesResponseWrapper wrapper = new DB_HospitalCountriesResponseWrapper(pickListValuesList);
            return wrapper;
        } catch (Exception e) {
            DB_HospitalCountriesResponseWrapper responseStatus = new DB_HospitalCountriesResponseWrapper();
            responseStatus.status = false;
            responseStatus.message = e.getMessage();
            return responseStatus;
        }
    }

    private static HospitalResponseWrapper errorResponse(Exception e) {
        HospitalResponseWrapper wrapper = new HospitalResponseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }
}