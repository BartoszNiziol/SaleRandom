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


    public static Boolean upsertDoctorToExternalDB(String upsertBody, Schema.sObjectType soType,Decimal batchCounter,Boolean selectedForBatch) {
        HttpResponse response;
        String authorization;
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = DB_Utils.retrieveCredentials('HDDoctorIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);

        String logId = DB_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Upsert', null, null, null, batchCounter,selectedForBatch,null);

        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);

        List<Doctor__c> idDoctors = new List<Doctor__c>();

        Integer counter = 0;
        while (response.getHeaderKeys().contains('addedId' + counter)) {
            Doctor__c doctor = new Doctor__c();
            doctor.Id = response.getHeader('externalId' + counter);
            doctor.Doctor_External_Id__c = response.getHeader('addedId' + counter);
            idDoctors.add(doctor);
            counter++;
        }
        DB_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Upsert', logId, response.getStatusCode(), response.getStatus(), null,selectedForBatch,response.getHeader('addedId' + 0));

        String isSync = 'f';
        if (response.getStatusCode() == 200) {
            isSync = 't';
        }
        String batchDoctorCount = receiveBatchCounter(upsertBody);

        String failedUpdateID = receiveId(upsertBody);

        String selfToken = UserInfo.getSessionId();
        String selfAuth = 'Bearer ' + selfToken;
        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint(endpointString);
        updateRequest.setMethod('PUT');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('Authorization', selfAuth);
        updateRequest.setHeader('isSync', isSync);
        updateRequest.setHeader('isBatch',String.valueOf(selectedForBatch));
        updateRequest.setHeader('counter',batchDoctorCount);
        updateRequest.setHeader('actionType', 'upsert');
        updateRequest.setHeader('failedUpdateID',failedUpdateID);
        updateRequest.setEndpoint(DB_Utils.retrieveCredentials('SelfDoctorEndpoint'));
        updateRequest.setBody(JSON.serialize(idDoctors));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);
        if (response.getStatusCode() == 200) {
            return true;
        } else return false;

    }

    public static Boolean deleteDoctorFromExternalDB(String upsertBody, Schema.sObjectType soType,Decimal batchCounter,Boolean isInBatch) {
        HttpResponse response;
        String authorization;
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = DB_Utils.retrieveCredentials('HDDoctorIntegrationEndpoint');
        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('DELETE');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);
        String logId = DB_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Delete', null, null, null, batchCounter,isInBatch,receiveExternalId(upsertBody));
        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);

        List<Doctor__c> idDoctors = new List<Doctor__c>();
        Integer counter = 0;

        while (response.getHeaderKeys().contains('addedId' + counter)) {
            Doctor__c doctor = new Doctor__c();
            doctor.Id = response.getHeader('externalId' + counter);
            doctor.Doctor_External_Id__c = response.getHeader('addedId' + counter);
            idDoctors.add(doctor);
            counter++;
        }

        DB_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Delete', logId, response.getStatusCode(), response.getStatus(), batchCounter,isInBatch,receiveExternalId(upsertBody));

        String isSync = 'f';
        if (response.getStatusCode() == 200) {
            isSync = 't';
        }

        String toDeleteDoctorId = receiveId(upsertBody);
        String batchDoctorCount = receiveBatchCounter(upsertBody);

        String selfToken = UserInfo.getSessionId();
        String selfAuth = 'Bearer ' + selfToken;
        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint(endpointString);
        updateRequest.setMethod('PUT');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('Authorization', selfAuth);
        updateRequest.setHeader('isSync', isSync);
        updateRequest.setHeader('isBatch',String.valueOf(isInBatch));
        updateRequest.setHeader('counter',batchDoctorCount);
        updateRequest.setHeader('actionType', 'delete');
        updateRequest.setHeader('undeID',toDeleteDoctorId);
        updateRequest.setEndpoint(DB_Utils.retrieveCredentials('SelfDoctorEndpoint'));
        updateRequest.setBody(JSON.serialize(idDoctors));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);

        if(response.getStatusCode() == 200){
            return true;
        }else return false;

    }
    private static String receiveExternalId(String requestBody){
        List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                requestBody
        );
        String doctorExternalId;
        for (Object obj : responseJSON) {
            Map<String, Object> params = (Map<string, Object>) obj;
            doctorExternalId = (String) params.get('Doctor_External_Id__c');
        }
        return doctorExternalId;
    }
    private static String receiveId(String requestBody) {
        List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                requestBody
        );
        String doctorId;
        for (Object obj : responseJSON) {
            Map<String, Object> params = (Map<string, Object>) obj;
            doctorId = (String) params.get('Id');
        }
        return doctorId;
    }

    private static String receiveBatchCounter(String requestBody){
        List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                requestBody
        );
        String batchCounter;
        for (Object obj : responseJSON) {
            Map<String, Object> params = (Map<string, Object>) obj;
            Integer count =(Integer) params.get('Batch_Counter__c');
            batchCounter = String.valueOf(count);
        }
        return batchCounter;
    }
}