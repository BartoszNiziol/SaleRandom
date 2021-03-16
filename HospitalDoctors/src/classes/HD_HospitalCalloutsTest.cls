/**
 * Created by BRITENET on 16.03.2021.
 */

@IsTest
public class HD_HospitalCalloutsTest {
    public static testMethod void shouldFoundTwoHospitals() {
        HD_HospitalSingleRequestMock fakeSearchResp = new HD_HospitalSingleRequestMock
                (200, 'Success','[{"message":"Succes","isSuccess":true,"id":"a0409000001jNLOAA2","hospitalName":"St Monica","email":"jakies@wp.pl","country":"USA","city":"Kanzas"}' +
                        ',{"message":"Succes","isSuccess":true,"id":"a0409000001jMkCAAU","hospitalName":"St Maria","email":"stmari@com.op","country":"USA","city":"Kanzas"}]',null);

        Map<String, HttpCalloutMock> endpointForTestRespoonse =
                new Map<String, HttpCalloutMock>();
        endpointForTestRespoonse.put(HD_Utils.retrieveCredentials('databaseEndpoint')+'?name=s&email=null&country=USA',fakeSearchResp);

        HttpCalloutMock multiCalloutMock = new HD_HospitalSearchMock(endpointForTestRespoonse);

        Test.setMock(HttpCalloutMock.class,multiCalloutMock);
        HD_HospitalExternalSearchController controller = new HD_HospitalExternalSearchController();
        controller.searchButtonAction();

    }
}