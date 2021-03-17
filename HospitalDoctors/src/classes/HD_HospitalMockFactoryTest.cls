/**
 * Created by BRITENET on 17.03.2021.
 */

@IsTest
public class HD_HospitalMockFactoryTest {

    @IsTest
    static  void shouldLogin() {

        HD_SingleMock fakeLoginResp = new HD_SingleMock(200,'Success','{ "access_token" : "00D5J000000Gh79!ARUAQG.i9os6CoXRz4Oa7Q.KyCGPsFXvaNb7F6M4HIMShkDrzAuAXV3BgYkLAALtNykrGTTEa3iPFsXSCCiHQi9BrxUhOEuP",' +
                '"instance_url":"https://britenet62-dev-ed.my.salesforce.com","id":"https://login.salesforce.com/id/00D09000006y2iiEAA/00509000001F3iHAAS"' +
                ',"token_type":"Bearer","issued_at":"1615965407230","signature":"FAudEjKzBjXTiP/rdJa7p97K2XahCDgyVrnsg3Kjd10="}',new Map<String,String>{'Content-Type' => 'application/json'});

        Map<String,HttpCalloutMock> endpointToTestResponse = new  Map<String,HttpCalloutMock>();
        endpointToTestResponse.put('https://login.salesforce.com/services/oauth2/token',fakeLoginResp);

        HD_HospitalFactoryMock factory = new HD_HospitalFactoryMock(endpointToTestResponse);



        HD_HospitalDBHandler handler = new HD_HospitalDBHandler();
      //  Test.setMock(HttpCalloutMock.class , factory);


    }
}