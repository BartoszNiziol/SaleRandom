/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class DB_QueueDeleteDoctorFromExternal implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    public  DB_QueueDeleteDoctorFromExternal (String upsertBody, Schema.sObjectType soType){
        this.soType = soType;
        this.upsertBody = upsertBody;
    }
    public void execute (QueueableContext context){
        DB_DoctorHandler.deleteDoctorFromExternalDB(upsertBody,soType);
    }
}