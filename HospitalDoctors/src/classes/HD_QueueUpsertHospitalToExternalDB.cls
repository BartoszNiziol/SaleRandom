/**
 * Created by BRITENET on 24.03.2021.
 */

public with sharing class HD_QueueUpsertHospitalToExternalDB implements Queueable , Database.AllowsCallouts{
    String upsertBody {get; set;}
    Schema.sObjectType soType{get;set;}
    public  HD_QueueUpsertHospitalToExternalDB (String upsertBody, Schema.sObjectType soType){
        this.soType = soType;
        this.upsertBody = upsertBody;
    }

    public void execute (QueueableContext context){
        HD_HospitalHandler.upsertHospitalToExternalDB(upsertBody,soType);
    }

}