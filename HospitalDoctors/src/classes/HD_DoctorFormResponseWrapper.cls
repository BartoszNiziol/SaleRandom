/**
 * Created by BRITENET on 11.03.2021.
 */

public with sharing class HD_DoctorFormResponseWrapper {

    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String country { get; set; }
    public String id { get; set; }

    public HD_DoctorFormResponseWrapper(String firstName, String lastName, String email, String country, String id) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.country = country;
        this.id = id;
    }

    public HD_DoctorFormResponseWrapper() {
    }
}