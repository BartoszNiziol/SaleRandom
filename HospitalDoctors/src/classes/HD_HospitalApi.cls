/**
 * Created by BRITENET on 12.03.2021.
 */
@RestResource(urlMapping='/Hospital/')
global  with sharing class HD_HospitalApi {

        @HttpGet
        global static HD_HospitalResonseWrapper getHospitals (){
            try {
                RestRequest req = RestContext.request;
                String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                Hospital__c result = [SELECT Name,City__c,Email__c,Country__c FROM Hospital__c WHERE Id=: id];
                HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
                wrapper.city = result.City__c;
                wrapper.email = result.Email__c;
                wrapper.country =result.Country__c;
                wrapper.hospitalName = result.Name;
                return wrapper;

            }catch (Exception e){
               return   errorResponse(e);
            }

        }

        @HttpPost
        global static HD_HospitalResonseWrapper createHospital (String hospitalName, String email, String country, String city){
            try{
                RestRequest req = RestContext.request;
                HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
                Hospital__c hospital = new Hospital__c();
                hospital.Name = hospitalName;
                hospital.Email__c = email;
                hospital.Country__c = country;
                hospital.City__c = city;
                insert hospital;
                return wrapper;
            }catch (Exception e){
                return   errorResponse(e);
            }

        }

        @HttpPatch
        global static HD_HospitalResonseWrapper updateHospital (String hospitalName, String email, String country, String city ){
            try{
                RestRequest req = RestContext.request;
                String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
                Hospital__c hospital = new Hospital__c();
                hospital.Name = hospitalName;
                hospital.Email__c = email;
                hospital.Country__c = country;
                hospital.City__c = city;
                hospital.Id = id;
                update hospital;
                return wrapper;
            }catch (Exception e){
                return   errorResponse(e);
            }
        }

        @HttpDelete
        global static HD_HospitalResonseWrapper deleteHospital (){
            try{
                RestRequest req = RestContext.request;
                String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
                Hospital__c hospital = new Hospital__c();
                delete hospital;
                return wrapper;

            }catch (Exception e){
                return   errorResponse(e);
            }
        }

        private static HD_HospitalResonseWrapper errorResponse(Exception e){
            HD_HospitalResonseWrapper wrapper = new HD_HospitalResonseWrapper();
            wrapper.isSuccess = false;
            wrapper.message = e.getMessage();
            return wrapper;
        }
}