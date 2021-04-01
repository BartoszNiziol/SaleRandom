/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class DB_QueueDeleteDoctorFromExternal implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    String authorization {get; set;}
    public  DB_QueueDeleteDoctorFromExternal (String upsertBody, Schema.sObjectType soType){
        this.soType = soType;
        this.upsertBody = upsertBody;
    }
    public void execute (QueueableContext context){
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        DB_DoctorHandler.deleteDoctorFromExternalDB(upsertBody,soType,0,false, authorization);
    }
}