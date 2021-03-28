/**
 * Created by BRITENET on 23.03.2021.
 */

public with sharing class HD_LoggerHandler {


    public static String createLog(String sObjectType, String endpoint, String requestBody, String responseBody, String actionType,
            String logID, Decimal statusCode, String status, Decimal batchCounter, Boolean isInBatch, String externalId) {


        Logger__c logger = new Logger__c();
        if(requestBody != null) {
            String id = retrieveAddedId(requestBody);
            logger.Created_Record_Id__c = id;
        }

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
        if (responseBody != null) {
            logger.Response_Body__c = responseBody;
            logger.Response_Status_Code__c = statusCode;
            logger.Status__c = status;
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
        if (logger.Response_Status_Code__c == 200) {
            logger.IsSynchronized__c = true;
        }
        if (logger.Response_Status_Code__c != 200) {
            logger.isSelectedForBatch__c = true;
        }
        if (externalId != null) {
            logger.Created_Record_External_ID__c = externalId;
        }

        if (batchCounter != null) {
            logger.Batch_Counter__c = batchCounter + 1;
        }
        upsert logger;
        return logger.Id;
    }

    public static String sendLogRequest(String sObjectType, String endpoint, String requestBody, String responseBody, String actionType,
            String logID, Decimal statusCode, String status, Decimal batchCounter, Boolean isInBatch, String externalId) {

        String logRequestBody = parseLogInfoToJson(sObjectType, endpoint, requestBody, responseBody, actionType, logId, statusCode, status, batchCounter, isInBatch, externalId);
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

        return (String) logResponse.getHeader('addedId');

    }

    private static String parseLogInfoToJson(String sObjectType, String endpoint, String requestBody, String responseBody, String actionType,
            String logID, Decimal statusCode, String status, Decimal batchCounter, Boolean isInBatch, String externalId) {

        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        if (endpoint != null) {
            generator.writeStringField('endpoint', endpoint);
        }
        if (sObjectType != null) {
            generator.writeStringField('soType', sObjectType);
        }
        if (responseBody != null) {
            generator.writeStringField('request', requestBody);
        }
        if (responseBody != null) {
            generator.writeStringField('response', responseBody);
        }
        if (actionType != null) {
            generator.writeStringField('actionType', actionType);
        }
        if (logID != null) {
            generator.writeStringField('logID', logID);
        }
        if (statusCode != null) {
            generator.writeNumberField('statusCode', statusCode);
        }
        if (status != null) {
            generator.writeStringField('status', status);
        }
        if (batchCounter != null) {
            generator.writeNumberField('batchCounter', batchCounter);
        }
        if (isInBatch != null) {
            generator.writeBooleanField('isInBatch', isInBatch);
        }
        if (externalId != null) {
            generator.writeStringField('externalId', externalId);
        }
        generator.writeEndObject();
        return generator.getAsString();
    }

    private static String retrieveAddedId(String requestBody) {

        List< Object> bodyList = (List < Object>) JSON.deserializeUntyped(
                requestBody
        );
        Map<String, Object> params = new Map<String, Object>();
        params = (Map<string, Object>) bodyList.get(0);
        return (String) params.get('Id');
    }
}