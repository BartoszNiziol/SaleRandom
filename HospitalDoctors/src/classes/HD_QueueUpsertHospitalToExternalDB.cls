/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class HD_QueueUpsertHospitalToExternalDB implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    Boolean isEdited {get; set;}
    String authorization{get;set;}
    public  HD_QueueUpsertHospitalToExternalDB (String upsertBody, Schema.sObjectType soType,Boolean isEdited){
        this.soType = soType;
        this.upsertBody = upsertBody;
        this.isEdited = isEdited;
    }

    public void execute (QueueableContext context){
        HttpResponse logHttpResponse = HD_IntegrationLoginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        HD_HospitalHandler.upsertHospitalToExternalDB(upsertBody,soType,0,false,isEdited,authorization);
    }

}