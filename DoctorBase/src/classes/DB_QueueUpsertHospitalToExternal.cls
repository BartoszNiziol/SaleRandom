/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class DB_QueueUpsertHospitalToExternal  implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    Boolean isEdited {get; set;}
    String authorization {get;set;}
    public  DB_QueueUpsertHospitalToExternal (String upsertBody, Schema.sObjectType soType){
        this.soType = soType;
        this.upsertBody = upsertBody;
        this.isEdited = isEdited;
    }
    public void execute (QueueableContext context){
        HttpResponse logHttpResponse = DB_IntegrationLoiginHandler.loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                logHttpResponse.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
        DB_HospitalHandler.upsertHospitalToExternalDB(upsertBody,soType,0,false,isEdited,authorization);
    }

}