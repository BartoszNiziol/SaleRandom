/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class QueueUpsertDoctorToExternalDB implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    Boolean isEdited {get; set;}
    public  QueueUpsertDoctorToExternalDB (String upsertBody, Schema.sObjectType soType,Boolean isEdited){
        this.soType = soType;
        this.upsertBody = upsertBody;
        this.isEdited = isEdited;
    }
    public void execute (QueueableContext context){
       HD_DoctorHandler.upsertDoctorToExternalDB(upsertBody,soType,0,false,isEdited);
    }
}