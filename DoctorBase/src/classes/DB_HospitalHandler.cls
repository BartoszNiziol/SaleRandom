/**
 * Created by BRITENET on 15.03.2021.
 */

public with sharing class DB_HospitalHandler {


    public static List<HospitalResponseWrapper> queryHospitals(String name, String email, String country) {
        List<HospitalResponseWrapper> responseWrappers= new List<HospitalResponseWrapper>();

        System.debug(name);
        System.debug(email);
        System.debug(country);

        String query = 'SELECT ID,Name,City__c,Email__c,Country__c ' +
                ' FROM Hospital__c ' +
                ' WHERE Name LIKE \'' + dynamicQueryLikeGenerator(name) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' ;

        List<Hospital__c> hospital = Database.query(query);
        System.debug(query);
        for (Hospital__c hos: hospital){
            responseWrappers.add(new HospitalResponseWrapper(hos.Name,hos.Email__c,hos.Country__c,hos.City__c,hos.Id));
        }
        return responseWrappers;
    }

    private static String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '') && (field !='null')) {
            fieldLike = field + '%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }

    public static Hospital__c parseHospitalResponseWrapperTHospital(HospitalResponseWrapper wrapper){
        Hospital__c hospital = new Hospital__c();
        hospital.Name = wrapper.hospitalName;
        hospital.City__c = wrapper.city;
        hospital.Country__c = wrapper.country;
        hospital.Email__c = wrapper.email;
      //  hospital.Hospital_External_Id__c = wrapper.hospitalExternalId;
        hospital.Phone_Number__c = wrapper.phoneNumber;
        hospital.Street__c = wrapper.street;
        hospital.Web_Page__c = wrapper.webPage;

        return hospital;

    }

}