/**
 * Created by BRITENET on 15.03.2021.
 */

public with sharing class DB_HospitalEntityWrapper {

    public String hospitalName {get;set;}
    public String email {get; set;}
    public String country {get;set;}
    public String city {get;set;}
    public String id {get; set;}

    public DB_HospitalEntityWrapper(String hospitalName, String email, String country, String city, String id){
        this.hospitalName = hospitalName;
        this.email = email;
        this.country = country;
        this.city = city;
        this.id = id;
    }

    public DB_HospitalEntityWrapper(){
    }
}