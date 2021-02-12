

public with sharing class BNSearchHelper {

    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country) {

        String firstNameLike;
        String lastNameLike;
        String emailLike;
        String countryLike;

        if((firstName != null) && (firstName != '')){
             firstNameLike = '%' + firstName + '%';
        }
        else {
            firstNameLike = '%';
        }
        if ((lastName != null)&&(lastName != '')) {
            lastNameLike = '%' + lastName + '%';
        }
        else {
            lastNameLike = '%';
        }
        if ((email != null)&&(email != '')){
            emailLike = '%' + email + '%';
        }
        else {
            emailLike = '%';
        }
        if ((country != null)&&(country != '')){
            countryLike = '%' + country + '%';
        }
        else {
            countryLike = '%';
        }
        List<Doctor__c> queredDoctors = [
                SELECT Id,First_Name__c,Name,Email__c,Country__c
                FROM Doctor__c
                WHERE First_Name__c LIKE :firstNameLike
                AND Name LIKE :lastNameLike
                AND Email__c LIKE :emailLike
                AND Country__c LIKE :countryLike
        ];
        return queredDoctors;
    }
}