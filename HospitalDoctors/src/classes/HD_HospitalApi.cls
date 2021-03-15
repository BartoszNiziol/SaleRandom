/**
 * Created by BRITENET on 12.03.2021.
 */
@RestResource(urlMapping='/Hospital/')
global with sharing class HD_HospitalApi {

    @HttpGet
    global static List<HD_HospitalResonseWrapper> getHospitals() {
        try {
            RestRequest req = RestContext.request;
            Map<String,String> requestParams = req.params;
            String id = requestParams.get('id');
            String name = requestParams.get('name');
            String email = requestParams.get('email');
            String country = requestParams.get('country');

            if(email != null){
                email = email.toLowerCase();
            }

            System.debug(name);
            System.debug(email);
            System.debug(country);


            List<Hospital__c> result = HD_HospitalHandler.queryHospitals(name,email,country);
            System.debug(result);
            List<HD_HospitalResonseWrapper> hospitalResponseWrappers = new List<HD_HospitalResonseWrapper>();

            for (Hospital__c hospital: result){
                HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
                wrapper.email = hospital.Email__c;
                wrapper.country = hospital.Country__c;
                wrapper.hospitalName = hospital.Name;
                wrapper.id = hospital.Id;
                hospitalResponseWrappers.add(wrapper);
            }
            return hospitalResponseWrappers;
        } catch (Exception e) {
            List<HD_HospitalResonseWrapper> hospitalResponseWrappers = new List<HD_HospitalResonseWrapper>();
            hospitalResponseWrappers.add(errorResponse(e));
            return  hospitalResponseWrappers;
        }
    }

    @HttpPost
    global static HD_HospitalResonseWrapper upsertHospital() {

        try {

            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            String name = (String)params.get('name');
            String email = (String)params.get('email');
            String country =(String) params.get('country');
            String id =(String) params.get('id');

            Hospital__c hospital = new Hospital__c();
            hospital.Name = name;
            hospital.Email__c = email;
            hospital.Country__c = country;

            hospital.Id = id;
            System.debug(hospital.id);
            upsert hospital;
            HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper(hospital);
            System.debug(wrapper);
            return wrapper;
        } catch (Exception e) {
            return errorResponse(e);
        }
    }

    @HttpDelete
    global static HD_HospitalResonseWrapper deleteHospital() {
        try {

            RestRequest req = RestContext.request;
            Map<String,String> requestParams = req.params;
            String id = requestParams.get('id');
            Hospital__c hospital = new Hospital__c();
            hospital.Id = id;
            delete hospital;
            HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper(hospital);
            return wrapper;

        } catch (Exception e) {
            return errorResponse(e);
        }
    }

        private static HD_HospitalResonseWrapper errorResponse(Exception e) {
            HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
            wrapper.isSuccess = false;
            wrapper.message = e.getMessage();
            return wrapper;
        }


}