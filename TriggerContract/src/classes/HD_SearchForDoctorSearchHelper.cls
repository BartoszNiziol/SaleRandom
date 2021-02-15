

public with sharing class HD_SearchForDoctorSearchHelper {

//    String sortBy ;
//    Boolean firstNameASCFlag;

    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country) {

//        String query ='SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
//                ' FROM Doctor__c ' +
//                ' Where First_Name__c Like '+dynamicQueryLikeGenerator(firstName)+
//                ' AND Name LIKE '+dynamicQueryLikeGenerator(lastName) +
//                ' AND Email__c LIKE '+dynamicQueryLikeGenerator(email)+
//                ' AND Country__c LIKE '+ dynamicQueryLikeGenerator(country)+
//                ' ORDER BY Name';
//
//        List<Doctor__c> docs = Database.query(query);

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

//    private String dynamicQueryLikeGenerator(String field){
//        String fieldLike;
//        if ((field != null) && (field != '')) {
//            fieldLike = field + '\'%';
//        } else {
//            fieldLike = '\'%';
//        }
//        return fieldLike;
//    }


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