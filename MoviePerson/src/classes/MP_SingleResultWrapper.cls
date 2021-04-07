/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_SingleResultWrapper {

    @AuraEnabled
    public Boolean isAdult{get;set;}
    @AuraEnabled
    public String apiId{get;set;}
    @AuraEnabled
    public String overview{get;set;}
    @AuraEnabled
    public String backdropPath{get;set;}
    @AuraEnabled
    public String releaseYear{get;set;}
    @AuraEnabled
    public String title{get;set;}
    @AuraEnabled
    public Decimal rating{get;set;}

    public MP_SingleResultWrapper(Boolean isAdult, String apiId, String overview, String backdropPath, String releaseYear, String title, Decimal rating){
        this.isAdult = isAdult;
        this.apiId = apiId;
        this.overview = overview;
        this.backdropPath = backdropPath;
        this.releaseYear = releaseYear;
        this.title = title;
        this.rating = rating;
    }

}