/**
 * Created by BRITENET on 23.03.2021.
 */

public with sharing class DB_LoggerHandler {
    public static void createLog(SObjectType sObjectType,String endpoint, HttpRequest request, HttpResponse response,String actionType){
        Logger__c logger = new Logger__c();
        if(sObjectType != null){
            logger.Name =  sObjectType.getDescribe().name+ ' '+actionType+' ' +Datetime.Now();
        }else{
            logger.Name = actionType + Datetime.Now();
        }

        logger.Create_Date__c = Datetime.Now();
        logger.Endpoint__c = endpoint;
        logger.Method_Type__c = request.getMethod();
        logger.Request_Body__c = request.getBody();
        logger.Response_Body__c = response.getBody();
        logger.Response_Status_Code__c = response.getStatusCode();
        logger.Status__c =response.getStatus();
        if(sObjectType != null){
            logger.Object_type__c = sObjectType.getDescribe().name;
        }else{
            logger.Object_type__c = null;
        }
        insert logger;
    }

}