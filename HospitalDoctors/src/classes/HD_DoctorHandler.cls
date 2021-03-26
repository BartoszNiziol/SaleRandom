public with sharing class HD_DoctorHandler {


    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country, String orderBy, String order) {
        String orderByLine = '';
        if (orderBy != null) {
            orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
        }
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
                orderByLine;
        return Database.query(query);
    }

    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'';

        return Database.query(query);
    }
    public List<Doctor__c> queryDoctorsOR(String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGeneratorOR(firstName) + '\'' +
                ' OR Name LIKE \'' + dynamicQueryLikeGeneratorOR(lastName) + '\'' +
                ' OR Email__c LIKE \'' + dynamicQueryLikeGeneratorOR(email) + '\'' +
                ' OR Country__c LIKE \'' + dynamicQueryLikeGeneratorOR(country) + '\'';

        return Database.query(query);
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

    public String queryDoctorsString(String firstName, String lastName, String email, String country, String orderBy, String order) {
        String orderByLine = '';
        if (orderBy != null && orderBy != '') {
            orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
        }
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
                orderByLine;
        return query;
    }

    private String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = +'%' + field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }
    private String dynamicQueryLikeGeneratorOR(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = +'%' + field + '%';
        }
        return fieldLike;
    }
    private static String dynamicQueryLikeGeneratorORStartsWith(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        }
        return fieldLike;
    }

    public static Doctor__c parseDoctorFromResponseWrapper(HD_DoctorResponseWrapper wrapper) {
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

    public static Boolean upsertDoctorToExternalDB(String upsertBody, Schema.SObjectType soType,Decimal batchCounter,Boolean selectedForBatch) {

        System.debug('batchCounter at start uspert');
        System.debug(batchCounter);

        HttpResponse response;
        String authorization;
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBDoctorIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setHeader('Authorization', 'aaa');
        upsertRequest.setBody(upsertBody);

        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Upsert', null, null, null, batchCounter,selectedForBatch);
        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);
        if (response.getStatusCode() != 200){
            selectedForBatch = true;
        }
        List<Doctor__c> idDoctors = new List<Doctor__c>();
        Integer counter = 0;
        HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Upsert', logId, response.getStatusCode(), response.getStatus(), null,selectedForBatch);

        while (response.getHeaderKeys().contains('addedId' + counter)) {
            System.debug('in while');
            Doctor__c doctor = new Doctor__c();
            doctor.Id = response.getHeader('externalId' + counter);
            doctor.Doctor_External_Id__c = response.getHeader('addedId' + counter);
            idDoctors.add(doctor);
            counter++;
        }

        String selfToken = UserInfo.getSessionId();
        String selfAuth = 'Bearer ' + selfToken;
        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint(endpointString);
        updateRequest.setMethod('PUT');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('Authorization', selfAuth);
        updateRequest.setEndpoint(HD_Utils.retrieveCredentials('SelfDoctorEndpoint'));
        updateRequest.setBody(JSON.serialize(idDoctors));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);


        if (response.getStatusCode() == 200) {
            return true;
        } else return false;
    }

    public static Boolean deleteDoctorFromExternalDB(String upsertBody, Schema.SObjectType soType,Decimal batchCounter,Boolean isInBatch) {
        HttpResponse response;
        String authorization;
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBDoctorIntegrationEndpoint');
        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('DELETE');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);
        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Delete', null, null, null, batchCounter,isInBatch);
        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);
        HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Delete', logId, response.getStatusCode(), response.getStatus(), batchCounter,isInBatch);
        if (response.getStatusCode() == 200) {
            return true;
        } else return false;
    }
}