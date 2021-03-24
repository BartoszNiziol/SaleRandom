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


    public static void upsertHospitalToExternalDB(String upsertBody,Schema.SObjectType soType) {

        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBHospitalIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);

        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Upsert', null);

        Http upsertHttp = new Http();
        HttpResponse response = upsertHttp.send(upsertRequest);

        List<Hospital__c> idHospital = new List<Hospital__c>();
        Integer counter = 0;
        while (response.getHeaderKeys().contains('addedId' + counter)) {
            Hospital__c hospital = new Hospital__c();
            hospital.Id = response.getHeader('externalId' + counter);
            hospital.Hospital_External_Id__c = response.getHeader('addedId' + counter);
            idHospital.add(hospital);
            counter++;
        }
        try {
            HD_Utils.turnOffTrigger(Hospital__c.getSObjectType());
            upsert idHospital;
        } finally {
            HD_Utils.turnOnTrigger(Hospital__c.getSObjectType());
        }
        HD_LoggerHandler.createLog(Hospital__c.SObjectType.getDescribe().name, endpointString, upsertBody, response, 'Upsert', null,null);
    }


    public static void deleteHospitalFromExternalDB(String upsertBody,Schema.SObjectType soType) {
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('DBHospitalIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('DELETE');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);
        String logId = HD_LoggerHandler.sendLogRequest(soType.getDescribe().name, endpointString, upsertBody, null, 'Delete', null);
        Http upsertHttp = new Http();
        HttpResponse response = upsertHttp.send(upsertRequest);

        HD_LoggerHandler.createLog(Hospital__c.SObjectType.getDescribe().name, endpointString, upsertBody, response, 'Delete', null,null);
    }
}