/**
 * Created by BRITENET on 16.03.2021.
 */

@IsTest
public class HD_HospitalCalloutsTest {

    @TestSetup
    public static void setupTestData(){
        HD_Setting__c setting = new HD_Setting__c();
        setting.Name = 'databaseEndpoint';
        setting.Value__c = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital';
        insert setting;
    }

    @IsTest
    public  static void shouldLogIn(){
        //given
        HD_Setting__c setting = new HD_Setting__c();
        setting.Name = 'LoginEndpoint';
        setting.Value__c = 'https://login.salesforce.com/services/oauth2/token';
        insert setting;
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        //when
        Test.startTest();
        HttpResponse response = handler.login();
        Test.stopTest();
        //then
        System.assertEquals(200,response.getStatusCode());
    }

    @IsTest
    public static void shouldFoundTwoHospitals() {
        //given
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        //when
        Test.startTest();
        List<HD_HospitalFormWrapper> wrappers = handler.searchRequest('s',null,'USA');
        Test.stopTest();
        //then
        System.assertEquals('St Monica',wrappers[0].name);
        System.assertEquals('St Maria',wrappers[1].name);
    }

    @IsTest
    public static void shouldAddHospital() {
        //given
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        //when
        Test.startTest();
        Boolean isReadyToClose = handler.upsertRequest('Ogolny','ogolny@pl.com','Pl',null);
        Test.stopTest();
        //then
        System.assertEquals(true,isReadyToClose);
    }

    @IsTest
    public static void shouldNotAddHospital() {
        //given
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        //when
        Test.startTest();
        Boolean isReadyToClose = handler.upsertRequest(null,'ogolny@pl.com','Pl',null);
        Test.stopTest();
        //then
        System.assertEquals(true,isReadyToClose);
    }

    @IsTest
    public static void shouldDeleteOneHospital() {
        //given
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        //when
        Test.startTest();
        HttpResponse response = handler.deleteRequest('IDTODELETE');
        Test.stopTest();
        //then
        System.assertEquals(200,response.getStatusCode());
    }

    @IsTest
    public static void shouldPopulateCountriesList(){
        HD_Setting__c setting = new HD_Setting__c();
        setting.Name = 'countriesEndpoint';
        setting.Value__c = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/HospitalCountries';
        insert setting;
        //given
        Test.setMock(HttpCalloutMock.class,new HD_HospitalSingleRequestMock());
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        SelectOption option = new SelectOption('PL','PL');
        //when
        Test.startTest();
        List<SelectOption> selectedCountries  = handler.populateCountriesList();
        Test.stopTest();
        //then
        System.assert(selectedCountries.contains(option));
    }



}