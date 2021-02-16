

public with sharing class HD_DoctrSearchHelper {


    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country, String orderBy ,String order) {

        String orderByLine = '';

        if (orderBy != null) {
            orderByLine = ' ORDER BY ' + orderBy+ ' ' + order;
        }

        String query ='SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
               orderByLine;


         return  Database.query(query);

    }

    public String  queryDoctorsString(String firstName, String lastName, String email, String country, String orderBy ,String order) {

        String orderByLine = '';

        if (orderBy != null && orderBy !='') {
            orderByLine = ' ORDER BY ' + orderBy+ ' ' + order;
        }

        String query ='SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
                orderByLine;


        return  query;

    }

    private String dynamicQueryLikeGenerator(String field){
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

}