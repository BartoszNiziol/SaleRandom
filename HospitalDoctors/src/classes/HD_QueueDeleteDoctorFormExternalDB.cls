/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class HD_QueueDeleteDoctorFormExternalDB implements Queueable , Database.AllowsCallouts {
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    String authorization {get;set;}
    public  HD_QueueDeleteDoctorFormExternalDB (String upsertBody, Schema.sObjectType soType){
        this.soType = soType;
        this.upsertBody = upsertBody;
    }
    public void execute (QueueableContext context){
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        HD_DoctorHandler.deleteDoctorFromExternalDB(upsertBody,soType,0,false,authorization);
    }

}