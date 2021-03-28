/**
 * Created by BRITENET on 21.03.2021.
 */
@RestResource(urlMapping = '/DoctorIntegration')
global class HD_DoctorIntegrationWebService {

    @HttpPost
    global static void upsertDoctor() {
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Doctor__c> doctorsToUpsert = new List<Doctor__c>();

            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;

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
                doctorsToUpsert.add(doctor);
            }
            try {
                HD_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                upsert doctorsToUpsert;
            } finally {
                HD_Utils.turnOnTrigger(Doctor__c.getSObjectType());
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
        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            List<Doctor__c> doctorsToDelete = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                Map<String, Object> params = (Map<string, Object>) obj;
                String doctorExternalId = (String) params.get('Doctor_External_Id__c');
                Doctor__c doctor = new Doctor__c();
                doctor.Id = doctorExternalId;
                doctorsToDelete.add(doctor);
            }
            try {
                HD_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                delete doctorsToDelete;
            } finally {
                HD_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    @HttpPut
    global static void updateDoctorExternalId() {
        System.debug('update fire fire');

        try {
            List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString());
            List<Doctor__c> doctorsWithID = new List<Doctor__c>();
            for (Object obj : responseJSON) {
                System.debug('loop :obj');
                System.debug(obj);
                Map<String, Object> params = (Map<string, Object>) obj;
                String doctorExternalId = (String) params.get('Doctor_External_Id__c');
                String isSynchronized = (String) params.get('isSynchronized');
                String doctorId = (String) params.get('Id');
                Doctor__c doctor = new Doctor__c();
                doctor.Id = doctorId;
                doctor.Doctor_External_Id__c = doctorExternalId;

                System.debug('isSynchronized');
                System.debug(isSynchronized);

                if (isSynchronized == 'true') {
                    doctor.is_Synchronized__c = true;
                }else {
                    doctor.is_Synchronized__c = false;
                }

                doctorsWithID.add(doctor);
            }
        try {
            HD_Utils.turnOffTrigger(Doctor__c.getSObjectType());
            System.debug('Trigger off');
            upsert doctorsWithID;
            System.debug(doctorsWithID);
        } finally {
            HD_Utils.turnOnTrigger(Doctor__c.getSObjectType());
        }
    }catch (Exception e){
            System.debug('Exc');
            System.debug(e);
        }
    }
}