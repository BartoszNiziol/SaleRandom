global class DB_DoctorResponseWrapper {
    webService String firstName;
    webService String lastName;
    webService String email;
    webService String country;
    webService String id;
    webService String message;
    webService Boolean isSuccess;

    public DB_DoctorResponseWrapper(Doctor__c doctor) {
        this.firstname = doctor.First_Name__c;
        this.lastName = doctor.Name;
        this.email = doctor.Email__c;
        this.country = doctor.Country__c;
        if (doctor.Id != null) {
            this.id = doctor.Id;
        }
        isSuccess = true;
    }

    public DB_DoctorResponseWrapper(){

    }
}