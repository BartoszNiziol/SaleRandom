/**
 * Created by BRITENET on 15.03.2021.
 */
global class HospitalResponseWrapper {
    webService String id;
    webService String hospitalName;
    webService String email;
    webService String country;
    webService String city;
    webService String message;
    webService Boolean isSuccess;

    public HospitalResponseWrapper (String hospitalName, String email, String country, String city, String id){
        this.id = Id;
        this.hospitalName = hospitalName;
        this.email = email;
        this.country = country;
        this.city = city;
        this.message = 'Succes';
        this.isSuccess = true;
    }

    public HospitalResponseWrapper (Hospital__c hospital){
        this.id = hospital.Id;
        this.hospitalName = hospital.Name;
        this.email = hospital.Email__c;
        this.country = hospital.Country__c;
        this.city = hospital.City__c;
        this.message = 'Succes';
        this.isSuccess = true;
    }



    public HospitalResponseWrapper(){
        this.message = 'Succes';
        this.isSuccess = true;
    }
}