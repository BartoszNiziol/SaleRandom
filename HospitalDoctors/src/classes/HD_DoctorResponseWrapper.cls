/**
 * Created by BRITENET on 19.03.2021.
 */

global class HD_DoctorResponseWrapper {
    webService String firstName;
    webService String lastName;
    webService String email;
    webService String country;
    webService String id;
    webService Date birthdayDate;
    webService String city;
    webService String doctorExternalId;
    webService Decimal licenseNumber;
    webService String phoneNumber;
    webService String street;
    webService String message;
    webService Boolean isSuccess;

    public HD_DoctorResponseWrapper(String id,String lastName, String firstName, String email, String country,Date birthdayDate, String city, String doctorExternalId,Decimal licenseNumber, String phoneNumber, String street){
        this.id = id;
        this.lastName = lastName;
        this.firstName = firstName;
        this.email = email;
        this.country = country;
        this.birthdayDate = birthdayDate;
        this.city = city;
        this.doctorExternalId = doctorExternalId;
        this.licenseNumber = licenseNumber;
        this.phoneNumber = phoneNumber;
        this.street = street;
        isSuccess = true;
        message ='Success';
    }

    public HD_DoctorResponseWrapper(Doctor__c doctor) {
        this.firstname = doctor.First_Name__c;
        this.lastName = doctor.Name;
        this.email = doctor.Email__c;
        this.country = doctor.Country__c;
        if (doctor.Id != null) {
            this.id = doctor.Id;
        }
        this.birthdayDate = doctor.Birthday_Date__c;
        this.city = doctor.City__c;
        this.doctorExternalId = doctor.Doctor_External_Id__c;
        this.licenseNumber = doctor.License_Number__c;
        this.phoneNumber = doctor.Phone_Number__c;
        this.street = doctor.Street__c;
        message ='Success';
        isSuccess = true;
    }

    public HD_DoctorResponseWrapper(){
        isSuccess = true;
        message ='Success';
    }

}