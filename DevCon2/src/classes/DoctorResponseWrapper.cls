/**
 * Created by BRITENET on 05.03.2021.
 */

global class DoctorResponseWrapper {
    webService String firstname;
    webService String lastName;
    webService String email;
    webService String country;
    webService Id id;

    public DoctorResponseWrapper(Doctor__c doctor) {
        this.firstname = doctor.First_Name__c;
        this.lastName = doctor.Name;
        this.email = doctor.Email__c;
        this.country = doctor.Country__c;
        if (doctor.Id != null) {
            this.id = doctor.Id;
        }
    }
}