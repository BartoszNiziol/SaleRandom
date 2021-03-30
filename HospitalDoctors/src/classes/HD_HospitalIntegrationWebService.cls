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
                hospital.is_Synchronized__c = true;
                hospitalsToUpsert.add(hospital);
            }
            try {
                HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                upsert hospitalsToUpsert;
            } finally {
                HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
            }
            Integer counter = 0;
            for (Hospital__c hosp : hospitalsToUpsert) {
                RestContext.response.addHeader('addedId' + counter, hosp.Id);
                RestContext.response.addHeader('externalId' + counter, hosp.Hospital_External_Id__c);
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
                        HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        upsert hospitalsWithID;
                    } finally {
                        HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }
                } else {
                    try {
                        Hospital__c failToUpdateHospital = new Hospital__c();
                        failToUpdateHospital.Id = headers.get('failedUpdateID');
                        HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        failToUpdateHospital.is_Synchronized__c = false;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            failToUpdateHospital.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        if (Boolean.valueOf(headers.get('isEdited'))) {
                            failToUpdateHospital.Batch_Counter__c = 0;
                        }
                        update failToUpdateHospital;
                    } finally {
                        HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }

                }
            } else {
                if (headers.get('isSync') == 't') {
                    try {
                        Hospital__c hospitalToUndlete = new Hospital__c();
                        hospitalToUndlete.Id = headers.get('undeID');
                        HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        undelete hospitalToUndlete;
                        hospitalToUndlete.Batch_Counter__c = 0;
                        hospitalToUndlete.is_Synchronized__c = true;
                        update hospitalToUndlete;
                        delete hospitalToUndlete;
                    } finally {
                        HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }

                } else {
                    try {
                        Hospital__c hospitalToUndlete = new Hospital__c();
                        hospitalToUndlete.Id = headers.get('undeID');
                        HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
                        undelete hospitalToUndlete;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            System.debug(Boolean.valueOF(headers.get('isBatch')));
                            hospitalToUndlete.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        hospitalToUndlete.is_Synchronized__c = false;
                        update hospitalToUndlete;
                        delete hospitalToUndlete;
                    } finally {
                        HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
                    }
                }
            }
        } catch (Exception e) {
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