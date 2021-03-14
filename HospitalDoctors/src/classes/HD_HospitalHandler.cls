/**
 * Created by BRITENET on 18.02.2021.
 */

public with sharing class HD_HospitalHandler {

    public static List<Hospital__c> queryHospitals(String name, String email, String country) {

        String query = 'SELECT ID,Name,Email__c,Country__c ' +
                ' FROM Hospital__c ' +
                ' WHERE Name LIKE \'' + dynamicQueryLikeGenerator(name) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' ;
        return Database.query(query);
    }

    private static String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

}