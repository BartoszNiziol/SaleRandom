/**
 * Created by BRITENET on 18.03.2021.
 */
@RestResource(urlMapping = '/DoctorIntegration')
global class HD_DoctorIntegrationWebService {

    @HttpPost
    global static void upsertDoctor() {
        System.debug('ups');

        Boolean isDoctorDeleted;
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Doctor__c> doctorsToUpsert = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = new Map<String, Object>();
                params = (Map<string, Object>) obj;
                Doctor__c doctor = new Doctor__c();
                doctor.Name = (String) params.get('Name');
                doctor.First_Name__c = (String) params.get('First_Name__c');
                doctor.Email__c = (String) params.get('Email__c');
                doctor.Country__c = (String) params.get('Country__c');
                doctor.City__c = (String) params.get ('City__c');
                if ((Integer) params.get('License_Number__c') != null) {
                    doctor.License_Number__c = Decimal.valueOf((Integer) params.get('License_Number__c'));
                }
                if ((String) params.get('Birthday_Date__c') != null) {
                    doctor.Birthday_Date__c = Date.valueOf((String) params.get('Birthday_Date__c'));
                }
                doctor.Street__c = (String) params.get('Street__c');
                doctor.Phone_Number__c = (String) params.get('Phone_Number__c');
                doctor.Doctor_External_Id__c = (String) params.get('Id');
                doctor.Id = (String) params.get('Doctor_External_Id__c');
                doctor.is_Synchronized__c = true;
                isDoctorDeleted = isDoctorDeleted(doctor.Id);
                doctorsToUpsert.add(doctor);
                System.debug('isDoctorDeleted in loop');
                System.debug(isDoctorDeleted);

            }
            if(isDoctorDeleted){
                undelete doctorsToUpsert;
                try {
                    DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                update doctorsToUpsert;
                } finally {
                    DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                }

            }else {
                try {
                    DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                    upsert doctorsToUpsert;
                } finally {
                    DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                }
            }

            Integer counter = 0;
            for (Doctor__c doc : doctorsToUpsert) {
                RestContext.response.addHeader('addedId' + counter, doc.Id);
                RestContext.response.addHeader('externalId' + counter, doc.Doctor_External_Id__c);
                counter++ ;
            }
        } catch (Exception e) {
            System.debug('upsertDoctorService');
            System.debug(e);
        }
    }
    @HttpDelete
    global static void deleteDoctor() {
        Boolean isDoctorDeleted;
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Doctor__c> doctorsToDelete = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                Doctor__c doctor = new Doctor__c();
                Map<String, Object> params = (Map<string, Object>) obj;
                doctor.Name = (String) params.get('Name');
                doctor.First_Name__c = (String) params.get('First_Name__c');
                doctor.Email__c = (String) params.get('Email__c');
                doctor.Country__c = (String) params.get('Country__c');
                doctor.City__c = (String) params.get ('City__c');
                if ((Integer) params.get('License_Number__c') != null) {
                    doctor.License_Number__c = Decimal.valueOf((Integer) params.get('License_Number__c'));
                }
                if ((String) params.get('Birthday_Date__c') != null) {
                    doctor.Birthday_Date__c = Date.valueOf((String) params.get('Birthday_Date__c'));
                }
                doctor.Street__c = (String) params.get('Street__c');
                doctor.Phone_Number__c = (String) params.get('Phone_Number__c');
                String doctorExternalId = (String) params.get('Doctor_External_Id__c');
                doctor.Id = doctorExternalId;
                isDoctorDeleted = isDoctorDeleted(doctor.Id);
                doctorsToDelete.add(doctor);
            }
            if(isDoctorDeleted){

                undelete doctorsToDelete;
                try {
                    DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                    update doctorsToDelete;
                } finally {
                    DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                }
                try {
                    DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                    delete doctorsToDelete;
                } finally {
                    DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                }

            }

            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                delete doctorsToDelete;
            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
            Integer counter = 0;
            for (Doctor__c doc : doctorsToDelete) {
                RestContext.response.addHeader('addedId' + counter, doc.Id);
                RestContext.response.addHeader('externalId' + counter, doc.Doctor_External_Id__c);
                counter++ ;
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    @HttpPut
    global static void updateDoctorExternalId() {
        System.debug('moje update sam start');
        try {
            System.debug('try');
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString());
            Map<String, String> headers = RestContext.request.headers;
            List<Doctor__c> doctorsWithID = new List<Doctor__c>();
            System.debug(headers.get('undeID'));

            if (headers.get('actionType') == 'upsert') {
                if (headers.get('isSync') == 't') {
                    System.debug('t');
                    for (Object obj : responseJSON) {
                        Map<String, Object> params = (Map<string, Object>) obj;
                        String doctorExternalId = (String) params.get('Doctor_External_Id__c');
                        String doctorId = (String) params.get('Id');
                        Doctor__c doctor = new Doctor__c();
                        doctor.Id = doctorId;
                        doctor.Doctor_External_Id__c = doctorExternalId;
                        doctor.is_Synchronized__c = true;
                        doctor.Batch_Counter__c = 0;
                        doctorsWithID.add(doctor);
                    }
                    try {
                        DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                        upsert doctorsWithID;
                    } finally {
                        DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                    }
                } else {
                    try {
                        System.debug('f');
                        Doctor__c failToUpdateDoctor = new Doctor__c();
                        failToUpdateDoctor.Id = headers.get('failedUpdateID');
                        System.debug(failToUpdateDoctor.Id);
                        DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                        failToUpdateDoctor.is_Synchronized__c = false;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            System.debug(Boolean.valueOF(headers.get('isBatch')));
                            failToUpdateDoctor.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        update failToUpdateDoctor;
                    } finally {
                        DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                    }
                }
            } else {
                System.debug('update els na delete');
                if (headers.get('isSync') == 't') {
                    try {
                        Doctor__c doctorToUndlete = new Doctor__c();
                        doctorToUndlete.Id = headers.get('undeID');
                        DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                        undelete doctorToUndlete;
                        doctorToUndlete.Batch_Counter__c = 0;
                        doctorToUndlete.is_Synchronized__c = true;
                        update doctorToUndlete;
                        delete doctorToUndlete;
                    } finally {
                        DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                    }
                } else {
                    try {
                        Doctor__c doctorToUndlete = new Doctor__c();
                        doctorToUndlete.Id = headers.get('undeID');
                        DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                        undelete doctorToUndlete;
                        if (Boolean.valueOF(headers.get('isBatch'))) {
                            System.debug(Boolean.valueOF(headers.get('isBatch')));
                            doctorToUndlete.Batch_Counter__c = Decimal.valueOf(headers.get('counter')) + 1;
                        }
                        doctorToUndlete.is_Synchronized__c = false;
                        update doctorToUndlete;
                        delete doctorToUndlete;
                    } finally {
                        DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
                    }
                    System.debug('ud');
                }
            }
        } catch (Exception e) {
            System.debug('e');
            System.debug(e);
        }
    }
    private static Boolean isDoctorDeleted(String id) {
       List <Doctor__c> doctor = [SELECT Id,IsDeleted FROM Doctor__c WHERE Id = :id ALL ROWS];
        if (doctor.size() == 0) {
            return false;
        }
        return doctor.get(0).IsDeleted;

    }


}