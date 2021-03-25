/**
 * Created by BRITENET on 23.03.2021.
 */

public with sharing class HD_LoggerHandler {


    public static String createLog (String sObjectType, String endpoint, String requestBody, HttpResponse response, String actionType, String errorMessage, String logID) {

        String id = retrieveAddedId(requestBody);

        Logger__c logger = new Logger__c();
        logger.Created_Record_Id__c =id;

        if (logID != null) {
            logger.Id = logID;
        }
        if (sObjectType != null) {
            logger.Name = sObjectType + ' ' + actionType + ' ' + Datetime.Now();
        } else {
            logger.Name = actionType + Datetime.Now();
        }
        logger.Create_Date__c = Datetime.Now();
        logger.Endpoint__c = endpoint;
        logger.Method_Type__c = actionType;
        logger.Request_Body__c = requestBody;
        logger.Error_Message__c = errorMessage;
        if (response != null) {
            logger.Response_Body__c = response.getBody();
            logger.Response_Status_Code__c = response.getStatusCode();
            logger.Status__c = response.getStatus();
        } else {
            logger.Response_Body__c = null;
            logger.Response_Status_Code__c = null;
            logger.Status__c = null;
        }
        if (sObjectType != null) {
            logger.Object_type__c = sObjectType;
        } else {
            logger.Object_type__c = null;
        }
        upsert logger;
        System.debug('logger.Id');
        System.debug(logger.Id);
        return logger.Id;
    }

    public static String sendLogRequest(String soTypeName, String endpoint, String requestBody, HttpResponse response, String actionType, String errorMessage){

        String logRequestBody =  parseLogInfoToJson( soTypeName,endpoint,requestBody, actionType);
        String accesToken = UserInfo.getSessionId();
        String authorization = 'Bearer ' + accesToken;
        String endpointString = HD_Utils.retrieveCredentials('LoggerSelfEndpoint');
        HttpRequest upsertRequest = new HttpRequest();
        upsertRequest.setEndpoint(endpointString);
        upsertRequest.setMethod('POST');
        upsertRequest.setHeader('Content-Type', 'application/json');
        upsertRequest.setHeader('Authorization', authorization);
        upsertRequest.setBody(logRequestBody);
        Http upsertHttp = new Http();
        HttpResponse logResponse = upsertHttp.send(upsertRequest);

        System.debug('logResponse.getStatus()');
        System.debug(logResponse.getStatus());
        return (String) logResponse.getHeader('addedId');

    }

    private static String parseLogInfoToJson(String soTypeName,String endpoint,String requestBody,String actionType) {

        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('endpoint', endpoint);
        generator.writeStringField('soType', soTypeName);
        generator.writeStringField('request', requestBody);
        generator.writeStringField('actionType', actionType);
        generator.writeEndObject();
        return generator.getAsString();
    }

    private  static String retrieveAddedId(String requestBody){

       List< Object> bodyList = (List < Object>) JSON.deserializeUntyped(
               requestBody
        );
        Map<String, Object> params = new Map<String, Object>();
        params = (Map<string, Object>) bodyList.get(0);
        return (String) params.get('Id');

    }

}