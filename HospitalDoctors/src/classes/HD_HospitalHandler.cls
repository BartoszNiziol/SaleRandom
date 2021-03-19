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

    public static Hospital__c parseHospitalFromResponseWrapper(HD_HospitalResonseWrapper wrapper){

        Hospital__c hospital = new Hospital__c();
        hospital.Id =wrapper.id;
        hospital.Name = wrapper.hospitalName;
        hospital.City__c = wrapper.city;
        hospital.Country__c = wrapper.country;
        hospital.Email__c = wrapper.email;
        hospital.Hospital_External_Id__c = wrapper.hospitalExternalId;
        hospital.Phone_Number__c = wrapper.phoneNumber;
        hospital.Street__c = wrapper.street;
        hospital.Web_Page__c = wrapper.webPage;

        return hospital;
    }

}