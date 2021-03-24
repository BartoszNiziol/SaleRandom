/**
 * Created by BRITENET on 15.03.2021.
 */

public with sharing class DB_HospitalHandler {


    public static List<HospitalResponseWrapper> queryHospitals(String name, String email, String country) {
        List<HospitalResponseWrapper> responseWrappers= new List<HospitalResponseWrapper>();
        String query = 'SELECT ID,Name,City__c,Email__c,Country__c ' +
                ' FROM Hospital__c ' +
                ' WHERE Name LIKE \'' + dynamicQueryLikeGenerator(name) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' ;

        List<Hospital__c> hospital = Database.query(query);
        for (Hospital__c hos: hospital){
            responseWrappers.add(new HospitalResponseWrapper(hos.Name,hos.Email__c,hos.Country__c,hos.City__c,hos.Id));
        }
        return responseWrappers;
    }

    private static String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '') && (field !='null')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

    public static Hospital__c parseHospitalResponseWrapperTHospital(HospitalResponseWrapper wrapper){
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
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;
        String endpointString = DB_Utils.retrieveCredentials('HDHospitalIntegrationEndpoint');

        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);

        Http upsertHttp = new Http();
        HttpResponse response = upsertHttp.send(upsertRequest);

        List<Hospital__c> idHospital = new List<Hospital__c>();
        Integer counter = 0;

        while (response.getHeaderKeys().contains('addedId'+ counter)){
            Hospital__c hospital = new Hospital__c();
            hospital.Id = response.getHeader('externalId'+counter);
            hospital.Hospital_External_Id__c = response.getHeader('addedId'+counter);
            idHospital.add(hospital);
            counter++;
        }
        try {
            DB_Utils.turnOffTrigger(Hospital__c.getSObjectType());
            upsert idHospital;
        } finally {
            DB_Utils.turnOnTrigger(Hospital__c.getSObjectType());
        }

    }


    public static void deleteHospitalFromExternalDB(String upsertBody,Schema.sObjectType soType) {
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;

        String endpointString = DB_Utils.retrieveCredentials('HDHospitalIntegrationEndpoint');
        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('DELETE');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(upsertBody);
        Http upsertHttp = new Http();
        HttpResponse response = upsertHttp.send(upsertRequest);

    }
}