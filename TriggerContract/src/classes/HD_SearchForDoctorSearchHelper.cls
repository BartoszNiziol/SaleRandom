

public with sharing class HD_SearchForDoctorSearchHelper {

    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country) {
        List<Doctor__c> queredDoctors = [
                SELECT Id,First_Name__c,Name,Email__c,Country__c
                FROM Doctor__c
                WHERE First_Name__c LIKE :queryLikeGenerator(firstName)
                AND Name LIKE :queryLikeGenerator(lastName)
                AND Email__c LIKE :queryLikeGenerator(email)
                AND Country__c LIKE :queryLikeGenerator(country)
                ORDER BY Name
        ];
        return queredDoctors;
    }

    private String queryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }
}