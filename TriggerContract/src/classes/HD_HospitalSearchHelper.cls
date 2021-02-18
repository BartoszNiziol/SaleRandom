/**
 * Created by BRITENET on 18.02.2021.
 */

public with sharing class HD_HospitalSearchHelper {

    public List<Hospital__c> queryHospitals(String name, String email, String country) {
      //  String orderByLine = '';
      //  if (orderBy != null) {
      //      orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
     //   }
        String query = 'SELECT ID,Name,Email__c,Country__c ' +
                ' FROM Hospital__c ' +
                ' WHERE Name LIKE \'' + dynamicQueryLikeGenerator(name) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' ;
               // orderByLine;

        System.debug('stringQuery----------'+query);
        return Database.query(query);
    }

//    public String queryDoctorsString(String firstName, String lastName, String email, String country, String orderBy, String order) {
//        String orderByLine = '';
//        if (orderBy != null && orderBy != '') {
//            orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
//        }
//        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
//                ' FROM Doctor__c ' +
//                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
//                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
//                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
//                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
//                orderByLine;
//        return query;
//    }

    private String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

}