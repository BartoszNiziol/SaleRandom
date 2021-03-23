public with sharing class DB_DoctorHandler {
    public DB_DoctorHandler() {

    }
    public static List<Doctor__c> queryDoctorsORStartsWith(String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(firstName) + '\'' +
                ' OR Name LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(lastName) + '\'' +
                ' OR Email__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(email) + '\'' +
                ' OR Country__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(country) + '\'';
        return Database.query(query);
    }

    private static String dynamicQueryLikeGeneratorORStartsWith(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        }
        return fieldLike;
    }

    public static Doctor__c parseDoctorFromRespnseWrapper(DB_DoctorResponseWrapper wrapper) {
        Doctor__c doctor = new Doctor__c();
        doctor.Id = wrapper.id;
        doctor.Name = wrapper.lastName;
        doctor.Birthday_Date__c = wrapper.birthdayDate;
        doctor.City__c = wrapper.city;
        doctor.Country__c = wrapper.country;
        doctor.Doctor_External_Id__c = wrapper.doctorExternalId;
        doctor.Email__c = wrapper.email;
        doctor.First_Name__c = wrapper.firstName;
        doctor.License_Number__c = wrapper.licenseNumber;
        doctor.Phone_Number__c = wrapper.phoneNumber;
        doctor.Street__c = wrapper.street;
        return doctor;
    }

    @Future(callout = true)
    public static void upsertDoctorToExternalDB(String upsertBody) {
        try {
            HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                    logHttpResponse.getBody()
            );
            String accesToken = (String) params.get('access_token');
            String authorization = 'Bearer ' + accesToken;
            String endpointString = DB_Utils.retrieveCredentials('HDDoctorIntegrationEndpoint');

            HttpRequest upsertRequest = new HttpRequest();
            upsertRequest.setEndpoint(endpointString);
            upsertRequest.setMethod('POST');
            upsertRequest.setHeader('Content-Type', 'application/json');
            upsertRequest.setHeader('Authorization', authorization);
            upsertRequest.setBody(upsertBody);

            Http upsertHttp = new Http();
            HttpResponse response = upsertHttp.send(upsertRequest);

            List<Doctor__c> idDoctors = new List<Doctor__c>();
            Integer counter = 0;
            while (response.getHeaderKeys().contains('addedId'+ counter)){
                Doctor__c doctor = new Doctor__c();
                doctor.Id = response.getHeader('externalId' + counter);
                doctor.Doctor_External_Id__c = response.getHeader('addedId' + counter);
                idDoctors.add(doctor);
                counter++;
            }
            try {
                DB_Utils.turnOffTrigger(Doctor__c.getSObjectType());
                upsert idDoctors;
            } finally {
                DB_Utils.turnOnTrigger(Doctor__c.getSObjectType());
            }

        } catch (Exception e) {
        }
    }

    @Future(callout = true)
    public static void deleteDoctorFromExternalDB(String upsertBody) {
        try {
            HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                    logHttpResponse.getBody()
            );
            String accesToken = (String) params.get('access_token');
            String authorization = 'Bearer ' + accesToken;
            String endpointString = DB_Utils.retrieveCredentials('HDDoctorIntegrationEndpoint');
            HttpRequest upsertRequest = new HttpRequest();
            upsertRequest.setEndpoint(endpointString);
            upsertRequest.setMethod('DELETE');
            upsertRequest.setHeader('Content-Type', 'application/json');
            upsertRequest.setHeader('Authorization', authorization);
            upsertRequest.setBody(upsertBody);
            Http upsertHttp = new Http();
            HttpResponse response = upsertHttp.send(upsertRequest);
        } catch (Exception e) {
            System.debug('deleteDoctorcallout');
            System.debug(e);
        }
    }
}