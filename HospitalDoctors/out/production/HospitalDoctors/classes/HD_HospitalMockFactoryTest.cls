/**
 * Created by BRITENET on 17.03.2021.
 */

@IsTest
public class HD_HospitalMockFactoryTest {

    @TestSetup
    public static void testSetup() {
        HD_Setting__c setting = new HD_Setting__c();
        setting.Name = 'LoginEndpoint';
        setting.Value__c = 'https://login.salesforce.com/services/oauth2/token';
        insert setting;

        HD_Setting__c setting2 = new HD_Setting__c();
        setting2.Name = 'countriesEndpoint';
        setting2.Value__c = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/HospitalCountries';
        insert setting2;

        HD_Setting__c setting3 = new HD_Setting__c();
        setting3.Name = 'databaseEndpoint';
        setting3.Value__c = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital';
        insert setting3;

    }

    public static HD_HospitalFactoryMock prepareFactory() {
        HD_SingleMock fakeLoginResp = new HD_SingleMock(200, 'Success', '{ "access_token" : "00D5J000000Gh79!ARUAQG.i9os6CoXRz4Oa7Q.KyCGPsFXvaNb7F6M4HIMShkDrzAuAXV3BgYkLAALtNykrGTTEa3iPFsXSCCiHQi9BrxUhOEuP",' +
                '"instance_url":"https://britenet62-dev-ed.my.salesforce.com","id":"https://login.salesforce.com/id/00D09000006y2iiEAA/00509000001F3iHAAS"' +
                ',"token_type":"Bearer","issued_at":"1615965407230","signature":"FAudEjKzBjXTiP/rdJa7p97K2XahCDgyVrnsg3Kjd10="}'
                , new Map<String, String>{
                        'Content-Type' => 'application/json'
                });
        HD_SingleMock fakeCountriesResp = new HD_SingleMock(200, 'Success', '{"status":true,"message":null,"countries":["NL","PL","UA","UK","USA","DE","FR"]}'
                , new Map<String, String>{
                        'Content-Type' => 'application/json', 'Authorization' => 'authorization'
                });
        HD_SingleMock fakeHospitalSearchResp = new HD_SingleMock(200, 'success', '[{"message":"Succes","isSuccess":true,"id":"a0409000001jNLOAA2","hospitalName":"St Monica","email":"jakies@wp.pl","country":"USA","city":"Kanzas"}' +
                ',{"message":"Succes","isSuccess":true,"id":"a0409000001jMkCAAU","hospitalName":"St Maria","email":"stmari@com.op","country":"USA","city":"Kanzas"}]'
                , new Map<String, String>{
                        'Content-Type' => 'application/json'
                });
        HD_SingleMock fakeHospitalUpsertResp = new HD_SingleMock(200, 'success', '{"isSuccess" : true , "message" : "Success" }'
                , new Map<String, String>{
                        'Content-Type' => 'application/json', 'Authorization' => 'authorization'
                });
        HD_SingleMock fakeHospitalDeleteResp = new HD_SingleMock(200, 'success', '{"isSuccess" : true , "message" : "Success" }'
                , new Map<String, String>{
                        'Content-Type' => 'application/json', 'Authorization' => 'authorization'
                });

        Map<String, HttpCalloutMock> endpointToTestResponse = new Map<String, HttpCalloutMock>();
        endpointToTestResponse.put('https://login.salesforce.com/services/oauth2/token', fakeLoginResp);
        endpointToTestResponse.put('https://britenet62-dev-ed.my.salesforce.com//services/apexrest/HospitalCountries', fakeCountriesResp);
        endpointToTestResponse.put('https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital?name=s&email=null&country=USA', fakeHospitalSearchResp);
        endpointToTestResponse.put('https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital', fakeHospitalUpsertResp);
        endpointToTestResponse.put('https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital?id=DELETEID', fakeHospitalDeleteResp);
        HD_HospitalFactoryMock factory = new HD_HospitalFactoryMock(endpointToTestResponse);
        return factory;
    }

    public static testMethod void shouldLogin() {
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        HD_HospitalFactoryMock factory = prepareFactory();
        Test.setMock(HttpCalloutMock.class, factory);
        Test.startTest();
        HttpResponse loginResponse = handler.login();
        Test.stopTest();
        System.assertEquals(200,loginResponse.getStatusCode());
    }

    public static testMethod void shouldPopulateCountriesList() {
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        SelectOption option = new SelectOption('PL', 'PL');
        HD_HospitalFactoryMock factory = prepareFactory();
        Test.setMock(HttpCalloutMock.class, factory);
        Test.startTest();
        List<SelectOption> countriesReceived = handler.populateCountriesList();
        Test.stopTest();
        System.assert(countriesReceived.contains(option));
    }

    public static testMethod void shouldFind2Hospitals() {
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        HD_HospitalFactoryMock factory = prepareFactory();
        Test.setMock(HttpCalloutMock.class, factory);
        Test.startTest();
        List<HD_HospitalFormWrapper> wrappers = handler.searchRequest('s', null, 'USA');
        Test.stopTest();
        System.assertEquals('St Monica', wrappers[0].name);
        System.assertEquals('St Maria', wrappers[1].name);
    }

    public static testMethod void shouldAddHospital() {
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        HD_HospitalFactoryMock factory = prepareFactory();
        Test.setMock(HttpCalloutMock.class, factory);
        Test.startTest();
        Boolean isReadyToClose = handler.upsertRequest('Ogolny', 'og@pac.pl', 'NL', 'HOSPITALID');
        Test.stopTest();
        System.assert(isReadyToClose);
    }

    public static testmethod void shouldDeleteHospital() {
        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
        HD_HospitalFactoryMock factory = prepareFactory();
        Test.setMock(HttpCalloutMock.class, factory);
        Test.startTest();
        HttpResponse response = handler.deleteRequest('DELETEID');
        Test.stopTest();
        System.assertEquals(200,response.getStatusCode());


    }
}