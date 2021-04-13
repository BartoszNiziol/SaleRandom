/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_MovieResultWrapper {
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
    @AuraEnabled
    public String releaseDate{get;set;}
    @AuraEnabled
    public String linkY{get;set;}


    public MP_MovieResultWrapper(Boolean isAdult, String apiId, String overview, String backdropPath, String releaseYear, String title, Decimal rating){
        this.isAdult = isAdult;
        this.apiId = apiId;
        this.overview = overview;
        this.backdropPath = backdropPath;
        if (releaseYear != null && releaseYear != '') {
            this.releaseYear = releaseYear.split('-').get(0);
        }else this.releaseYear ='';
        this.title = title;
        this.rating = rating;
        this.releaseDate = releaseYear;

    }
    public MP_MovieResultWrapper(Boolean isAdult, String apiId, String overview, String backdropPath, String releaseYear, String title, Decimal rating,String linkY){
        this.isAdult = isAdult;
        this.apiId = apiId;
        this.overview = overview;
        this.backdropPath = backdropPath;
        if (releaseYear != null && releaseYear != '') {
            this.releaseYear = releaseYear.split('-').get(0);
        }else this.releaseYear ='';
        this.title = title;
        this.rating = rating;
        this.releaseDate = releaseYear;
        this.linkY = linkY;

    }
}