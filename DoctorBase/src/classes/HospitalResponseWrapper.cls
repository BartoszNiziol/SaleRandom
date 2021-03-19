/**
 * Created by BRITENET on 15.03.2021.
 */
global class HospitalResponseWrapper {
    webService String id;
    webService String hospitalName;
    webService String email;
    webService String country;
    webService String city;
    webService String phoneNumber;
    webService String street;
    webService String webPage;
    webService String message;
    webService String hospitalExternalId;
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

    public HospitalResponseWrapper (String hospitalName, String email, String country, String city, String id, String webPage, String street, String phoneNumber,String hospitalExternalId){
        this.id = Id;
        this.hospitalName = hospitalName;
        this.email = email;
        this.country = country;
        this.city = city;
        this.webPage = webPage;
        this.street = street;
        this.phoneNumber = phoneNumber;
        this.hospitalExternalId = hospitalExternalId;
        this.message = 'Succes';
        this.isSuccess = true;
    }

    public HospitalResponseWrapper (Hospital__c hospital){
        this.id = hospital.Id;
        this.hospitalName = hospital.Name;
        this.email = hospital.Email__c;
        this.country = hospital.Country__c;
        this.city = hospital.City__c;
        this.webPage = hospital.Web_Page__c;
        this.street = hospital.Street__c;
        this.phoneNumber = hospital.Phone_Number__c;
        this.hospitalExternalId = hospital.Hospital_External_Id__c;
        this.message = 'Succes';
        this.isSuccess = true;
    }

    public HospitalResponseWrapper(){
        this.message = 'Succes';
        this.isSuccess = true;
    }
}