/**
 * Created by BRITENET on 17.02.2021.
 */

public with sharing class HD_DoctorViewControllerHelper {

    public void processContract(Contract__c actualContract) {
        if (actualContract.End_Date__c != null) {
            if (actualContract.Start_Date__c < System.today() && actualContract.End_Date__c <= System.today()) {

            } else if (actualContract.Start_Date__c <= System.today() && (actualContract.End_Date__c > System.today())) {
                actualContract.End_Date__c = System.today();
                update actualContract;
            } else if (actualContract.Start_Date__c > System.today() && actualContract.End_Date__c > System.today()) {
                delete actualContract;
            }
        } else {
            if (actualContract.Start_Date__c <= System.today()) {
                actualContract.End_Date__c = System.today();
                update actualContract;
            } else {
                delete actualContract;
            }
        }
    }
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