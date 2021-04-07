/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class DB_HospitalIntegrationWebService {

    @HttpPost
    global static void upsertHospital() {
        Boolean isHospitalDeleted;
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
                isHospitalDeleted = isHospitalDeleted(hospital.Id);
                hospitalsToUpsert.add(hospital);
            }
            if(isHospitalDeleted){
                undelete  hospitalsToUpsert;
                try {
                    DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                    update hospitalsToUpsert;
                } finally {
                    DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                }
            } else {
                try {
                    DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                    upsert hospitalsToUpsert;
                } finally {
                    DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                }
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
        Boolean isHospitalDeleted;
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Hospital__c> hospitalsToDelete = new List<Hospital__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;
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
                isHospitalDeleted(hospital.Id);
                hospitalsToDelete.add(hospital);
            }
            if(isHospitalDeleted){
                undelete hospitalsToDelete;
                try {
                    DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                    update hospitalsToDelete;
                } finally {
                    DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                }
                try {
                    DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                    delete hospitalsToDelete;
                } finally {
                    DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                }
            }
            try {
                DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                delete hospitalsToDelete;
            } finally {
                DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
            Integer counter = 0;
            for (Hospital__c hosp : hospitalsToDelete) {
                RestContext.response.addHeader('addedId' + counter, hosp.Id);
                RestContext.response.addHeader('externalId' + counter, hosp.Hospital_External_Id__c);
                counter++ ;
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
            Map<String, String> headers = RestContext.request.headers;
            List<Hospital__c> hospitalsWithID = new List<Hospital__c>();

            if (headers.get('actionType') == 'upsert') {
                if (headers.get('isSync') == 't') {
                    for (Object obj : responseJSON) {
                        Map<String, Object> params = (Map<string, Object>) obj;
                        String hospitalExternalId = (String) params.get('Hospital_External_Id__c');
                        String hospitalId = (String) params.get('Id');
                        Hospital__c hospital = new Hospital__c();
                        hospital.Id = hospitalExternalId;
                        hospital.Hospital_External_Id__c = hospitalExternalId;
                        hospital.is_Synchronized__c = true;
                        hospital.Batch_Counter__c = 0;
                        hospitalsWithID.add(hospital);
                    }
                    try {
                        DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        upsert hospitalsWithID;
                    } finally {
                        DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }
                } else {
                    try {
                        Hospital__c failToUpdateHospital = new Hospital__c();
                        failToUpdateHospital.Id = headers.get('failedUpdateID');
                        DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        failToUpdateHospital.is_Synchronized__c = false;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            failToUpdateHospital.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        if (Boolean.valueOf(headers.get('isEdited'))) {
                            failToUpdateHospital.Batch_Counter__c = 0;
                        }
                        update failToUpdateHospital;
                    } finally {
                        DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }

                }
            } else {
                if (headers.get('isSync') == 't') {
                    try {
                        Hospital__c hospitalToUndlete = new Hospital__c();
                        hospitalToUndlete.Id = headers.get('undeID');
                        DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        undelete hospitalToUndlete;
                        hospitalToUndlete.Batch_Counter__c = 0;
                        hospitalToUndlete.is_Synchronized__c = true;
                        update hospitalToUndlete;
                        delete hospitalToUndlete;
                    } finally {
                        DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }

                } else {
                    try {
                        Hospital__c hospitalToUndlete = new Hospital__c();
                        hospitalToUndlete.Id = headers.get('undeID');
                        DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        undelete hospitalToUndlete;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            System.debug(Boolean.valueOF(headers.get('isBatch')));
                            hospitalToUndlete.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        hospitalToUndlete.is_Synchronized__c = false;
                        update hospitalToUndlete;
                        delete hospitalToUndlete;
                    } finally {
                        DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }
                }
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }

    private static HospitalResponseWrapper errorResponse(Exception e) {
        HospitalResponseWrapper wrapper = new HospitalResponseWrapper();
        wrapper.isSuccess = false;
        wrapper.message = e.getMessage();
        return wrapper;
    }
    private static Boolean isHospitalDeleted(String id) {
        List <Hospital__c> hospitals = [SELECT Id,IsDeleted FROM Hospital__c WHERE Id = :id ALL ROWS];
        if (hospitals.size() == 0) {
            return false;
        }
        return hospitals.get(0).IsDeleted;
    }
}