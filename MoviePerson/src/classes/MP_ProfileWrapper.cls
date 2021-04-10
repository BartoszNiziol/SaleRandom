/**
 * Created by BRITENET on 08.04.2021.
 */

public with sharing class MP_ProfileWrapper {

    @auraenabled
    public String externalId {get;set;}
    @auraenabled
    public Boolean isAdult {get;set;}
    @auraenabled
    public String name {get;set;}
    @auraenabled
    public String bio {get;set;}
    @auraenabled
    public String birthDate {get;set;}
    @auraenabled
    public String deathDate {get;set;}
    @auraenabled
    public String department {get;set;}
    @auraenabled
    public String birthPlace {get;set;}
    @auraenabled
    public String profilePath {get;set;}
    @auraenabled
    public String age {get;set;}
    @auraenabled
    public String role {get;set;}

    public MP_ProfileWrapper(String externalId,Boolean isAdult, String name,String bio, String birthdayDate, String deathDate, String department, String birthPlace, String profilePath,String role){
        this.externalId = externalId;
        this.isAdult = isAdult;
        this.name = name;
        this.bio = bio;
        this.birthDate = birthdayDate;
        this.deathDate = deathDate;
        this.department = department;
        this.birthPlace = birthPlace;
        this.profilePath = profilePath;
        this.role = role;

        if(birthDate != null) {
            this.age = String.valueOf(Date.today().year() - Integer.valueOf(birthDate.split('-').get(0)));
        }

    }
    public MP_ProfileWrapper(String externalId,Boolean isAdult, String name,String bio, String birthdayDate, String deathDate, String department, String birthPlace, String profilePath){
        this.externalId = externalId;
        this.isAdult = isAdult;
        this.name = name;
        this.bio = bio;
        this.birthDate = birthdayDate;
        this.deathDate = deathDate;
        this.department = department;
        this.birthPlace = birthPlace;
        this.profilePath = profilePath;


        if(birthDate != null) {
            this.age = String.valueOf(Date.today().year() - Integer.valueOf(birthDate.split('-').get(0)));
        }

    }



}