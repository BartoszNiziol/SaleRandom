/**
 * Created by BRITENET on 18.02.2021.
 */

public with sharing class HD_HospitalHandler {

    public static List<Hospital__c> queryHospitals(String name, String email, String country) {
        String query = 'SELECT ID,Name,Email__c,Country__c ' +
                ' FROM Hospital__c ' +
                ' WHERE Name LIKE \'' + dynamicQueryLikeGenerator(name) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' ;
        return Database.query(query);
    }

    private static String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

    public static Hospital__c parseHospitalFromResponseWrapper(HD_HospitalResonseWrapper wrapper) {
        Hospital__c hospital = new Hospital__c();
        hospital.Id = wrapper.id;
        hospital.Name = wrapper.hospitalName;
        hospital.City__c = wrapper.city;
        hospital.Country__c = wrapper.country;
        hospital.Email__c = wrapper.email;
        hospital.Hospital_External_Id__c = wrapper.hospitalExternalId;
        hospital.Phone_Number__c = wrapper.phoneNumber;
        hospital.Street__c = wrapper.street;
        hospital.Web_Page__c = wrapper.webPage;
        return hospital;
    }

    public static Boolean upsertHospitalToExternalDB(String upsertBody, Schema.SObjectType soType, Decimal batchCounter, Boolean isInBatch,Boolean isEdited) {

        HttpResponse response;
        String authorization;

        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBHospitalIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setHeader('Authorization', 'block');
        upsertRequest.setBody(upsertBody);

        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Upsert', null, null, null, batchCounter, isInBatch,null);

        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);

        List<Hospital__c> idHospital = new List<Hospital__c>();
        Integer counter = 0;

        while (response.getHeaderKeys().contains('addedId' + counter)) {
            Hospital__c hospital = new Hospital__c();
            hospital.Id = response.getHeader('externalId' + counter);
            hospital.Hospital_External_Id__c = response.getHeader('addedId' + counter);
            idHospital.add(hospital);
            counter++;
        }


        HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Upsert', logId, response.getStatusCode(), response.getStatus(), batchCounter, isInBatch,response.getHeader('addedId' + 0));

        String isSync = 'f';
        if (response.getStatusCode() == 200) {
            isSync = 't';
        }
        String batchHospitalCount = receiveBatchCounter(upsertBody);
        String isEditedS = String.valueOf(isEdited);
        String failedUpdateID = receiveId(upsertBody);
        String selfToken = UserInfo.getSessionId();
        String selfAuth = 'Bearer ' + selfToken;
        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint(endpointString);
        updateRequest.setMethod('PUT');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('Authorization', selfAuth);
        updateRequest.setHeader('isSync', isSync);
        updateRequest.setHeader('isBatch',String.valueOf(isInBatch));
        updateRequest.setHeader('counter',batchHospitalCount);
        updateRequest.setHeader('isEdited',isEditedS);
        updateRequest.setHeader('actionType', 'upsert');
        updateRequest.setHeader('failedUpdateID',failedUpdateID);
        updateRequest.setEndpoint(HD_Utils.retrieveCredentials('SelfHospitalEndpoint'));
        updateRequest.setBody(JSON.serialize(idHospital));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);
        if (response.getStatusCode() == 200) {
            return true;
        } else return false;
    }

    public static Boolean deleteHospitalFromExternalDB(String upsertBody, Schema.SObjectType soType, Decimal batchCounter, Boolean isInBatch) {
        HttpResponse response;
        String authorization;

        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBHospitalIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('DELETE');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setHeader('Authorization', 'block');
        upsertRequest.setBody(upsertBody);
        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Upsert', null, null, null, batchCounter, isInBatch,receiveExternalId(upsertBody));
        Http upsertHttp = new Http();
        response = upsertHttp.send(upsertRequest);

        List<Hospital__c> idHospitals = new List<Hospital__c>();
        Integer counter = 0;

        while (response.getHeaderKeys().contains('addedId' + counter)) {
            Hospital__c hospital = new Hospital__c();
            hospital.Id = response.getHeader('externalId' + counter);
            hospital.Hospital_External_Id__c = response.getHeader('addedId' + counter);
            idHospitals.add(hospital);
            counter++;
        }

        HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, response.getBody(), 'Delete', logId, response.getStatusCode(), response.getStatus(), batchCounter, isInBatch,receiveExternalId(upsertBody));

        String isSync = 'f';
        if (response.getStatusCode() == 200) {
            isSync = 't';
        }

        String toDeleteHospitalId = receiveId(upsertBody);
        String batchHospitalCount = receiveBatchCounter(upsertBody);

        String selfToken = UserInfo.getSessionId();
        String selfAuth = 'Bearer ' + selfToken;
        HttpRequest updateRequest = new HttpRequest();
        updateRequest.setEndpoint(endpointString);
        updateRequest.setMethod('PUT');
        updateRequest.setHeader('Content-Type', 'application/json');
        updateRequest.setHeader('Authorization', selfAuth);
        updateRequest.setHeader('isSync', isSync);
        updateRequest.setHeader('isBatch',String.valueOf(isInBatch));
        updateRequest.setHeader('counter',batchHospitalCount);
        updateRequest.setHeader('actionType', 'delete');
        updateRequest.setHeader('undeID',toDeleteHospitalId);
        updateRequest.setEndpoint(HD_Utils.retrieveCredentials('SelfHospitalEndpoint'));
        updateRequest.setBody(JSON.serialize(idHospitals));
        Http updateHttp = new Http();
        HttpResponse updateResponse = updateHttp.send(updateRequest);

        if (response.getStatusCode() == 200) {
            return true;
        } else return false;
    }

    private static String receiveExternalId(String requestBody){
        List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                requestBody
        );
        String hospitalExternalId;
        for (Object obj : responseJSON) {
            Map<String, Object> params = (Map<string, Object>) obj;
            hospitalExternalId = (String) params.get('Hospital_External_Id__c');
        }
        return hospitalExternalId;
    }
    private static String receiveId(String requestBody) {
        List <Object> responseJSON = (List <Object>) JSON.deserializeUntyped(
                requestBody
        );
        String hospitalId;
        for (Object obj : responseJSON) {
            Map<String, Object> params = (Map<string, Object>) obj;
            hospitalId = (String) params.get('Id');
        }
        return hospitalId;
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