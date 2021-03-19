public with sharing class HD_DoctorHandler {


    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country, String orderBy, String order) {
        String orderByLine = '';
        if (orderBy != null) {
            orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
        }
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
                orderByLine;
        return Database.query(query);
    }

    public List<Doctor__c> queryDoctors(String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'';

        return Database.query(query);
    }
    public List<Doctor__c> queryDoctorsOR (String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGeneratorOR(firstName) + '\'' +
                ' OR Name LIKE \'' + dynamicQueryLikeGeneratorOR(lastName) + '\'' +
                ' OR Email__c LIKE \'' + dynamicQueryLikeGeneratorOR(email) + '\'' +
                ' OR Country__c LIKE \'' + dynamicQueryLikeGeneratorOR(country) + '\'';

        return Database.query(query);
    }

    public static List<Doctor__c> queryDoctorsORStartsWith (String firstName, String lastName, String email, String country) {
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(firstName) + '\'' +
                ' OR Name LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(lastName) + '\'' +
                ' OR Email__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(email) + '\'' +
                ' OR Country__c LIKE \'' + dynamicQueryLikeGeneratorORStartsWith(country) + '\'';

        return Database.query(query);
    }

    public String queryDoctorsString(String firstName, String lastName, String email, String country, String orderBy, String order) {
        String orderByLine = '';
        if (orderBy != null && orderBy != '') {
            orderByLine = ' ORDER BY ' + orderBy + ' ' + order;
        }
        String query = 'SELECT ID,First_Name__c,Name,Email__c,Country__c ' +
                ' FROM Doctor__c ' +
                ' WHERE First_Name__c LIKE \'' + dynamicQueryLikeGenerator(firstName) + '\'' +
                ' AND Name LIKE \'' + dynamicQueryLikeGenerator(lastName) + '\'' +
                ' AND Email__c LIKE \'' + dynamicQueryLikeGenerator(email) + '\'' +
                ' AND Country__c LIKE \'' + dynamicQueryLikeGenerator(country) + '\'' +
                orderByLine;
        return query;
    }

    private String dynamicQueryLikeGenerator(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = + '%'+field+'%';
        } else {
            fieldLike = '%';
        }
        return fieldLike;
    }
    private String dynamicQueryLikeGeneratorOR(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = + '%'+field+'%';
        }
        return fieldLike;
    }
    private static String dynamicQueryLikeGeneratorORStartsWith(String field) {
        String fieldLike;
        if ((field != null) && (field != '')) {
            fieldLike = field+'%';
        }
        return fieldLike;
    }

    public static Doctor__c parseDoctorFromResponseWrapper(HD_DoctorResponseWrapper wrapper){
        Doctor__c doctor = new Doctor__c();

        doctor.Id = wrapper.id;
        doctor.Name = wrapper.lastName;
        doctor.Birthday_Date__c = wrapper.birthdayDate;
        doctor.City__c = wrapper.city;
        doctor.Country__c = wrapper.country;
        doctor.Doctor_External_Id__c = wrapper.doctorExternalId;
        doctor.Email__c = wrapper.email;
        doctor.First_Name__c = wrapper.firstName;
        doctor.License_Number__c = wrapper.licenseNumber;
        doctor.Phone_Number__c = wrapper.phoneNumber;
        doctor.Street__c = wrapper.street;

        return doctor;


    }


}