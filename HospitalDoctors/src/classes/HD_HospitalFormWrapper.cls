/**
 * Created by BRITENET on 15.03.2021.
 */

public with sharing class HD_HospitalFormWrapper {

    public String name {get; set;}
    public String email {get; set;}
    public String country {get; set;}
    public String city {get; set;}
    public String id {get;set;}

   public HD_HospitalFormWrapper(String id,String name, String email, String country, String city){
        this.name = name;
        this.email = email;
        this.country = country;
        this.city = city;
        this.id = id;
    }
    public HD_HospitalFormWrapper( Map<String, Object> parsedHospital){
        this.name = (String) parsedHospital.get('hospitalName');
        this.email = (String) parsedHospital.get('email');
        this.country = (String) parsedHospital.get('country');
        this.city = (String) parsedHospital.get('city');
        this.id = (String) parsedHospital.get('id');
    }

   public HD_HospitalFormWrapper(){

    }
}