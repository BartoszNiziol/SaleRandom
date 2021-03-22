/**
 * Created by BRITENET on 21.03.2021.
 */
@RestResource(urlMapping = '/DoctorIntegration')
global class HD_DoctorIntegrationWebService {

    @HttpPost
    global static void upsertDoctor() {
        try {
            Map<String, Object> params;
            List <Object> responseJ = (List <Object>) JSON.deserializeUntyped(
                    RestContext.request.requestBody.toString()
            );
            System.debug(responseJ);
            for (Object obj : responseJ) {
                params = (Map<string, Object>) obj;
            }
            String surname = (String) params.get('Name');
            String firstName = (String) params.get('First_Name__c');
            String email = (String) params.get('Email__c');
            String country = (String) params.get('Country__c');
            String city = (String) params.get ('City__c');
            Integer licenseNumber = (Integer) params.get('License_Number__c');
            String id = (String) params.get('Id');
            String birthDayDate = (String) params.get('Birthday_Date__c');
            String street = (String) params.get('Street__c');
            String phoneNumber = (String) params.get('Phone_Number__c');
            String doctorExternalId = (String) params.get('Doctor_External_Id__c');
            Doctor__c doctor = new Doctor__c();
            doctor.Name = surname;
            doctor.First_Name__c = firstName;
            doctor.Email__c = email;
            doctor.Country__c = country;
            doctor.City__c = city;
            if (licenseNumber != null) {
                doctor.License_Number__c = Decimal.valueOf(licenseNumber);
            }
            if (birthDayDate != null) {
                doctor.Birthday_Date__c = Date.valueOf(birthDayDate);
            }
            doctor.Street__c = street;
            doctor.Phone_Number__c = phoneNumber;
            doctor.Doctor_External_Id__c = Id;
            doctor.Id = doctorExternalId;
            HD_Utils.turnOffTrigger(Doctor__c.getSObjectType());
            upsert doctor;
            HD_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            RestContext.response.addHeader('addedId', doctor.Id);
            RestContext.response.addHeader('externalId', doctor.Doctor_External_Id__c);

        } catch (Exception e) {
            System.debug(e);
        }
    }

}