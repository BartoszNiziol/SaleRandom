/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class HD_IntegrationLoginHandler implements Database.AllowsCallouts{

    public static  HttpResponse loginCallout(){
        HttpRequest loginRequest = new HttpRequest();
        String endpointString = HD_Utils.retrieveCredentials('LoginEndpoint');
        loginRequest.setEndpoint(HD_Utils.retrieveCredentials('LoginEndpoint'));
        loginRequest.setMethod('POST');
        String username = HD_Utils.retrieveCredentials('DBLogin');
        String password = HD_Utils.retrieveCredentials('DBPassword');
//        password = 'ugabuga';
        String grantType = 'password';
        String clientId = HD_Utils.retrieveCredentials('clientID');
        String clientSecret = HD_Utils.retrieveCredentials('clientSecret');
        loginRequest.setBody(
                'grant_type=password' +
                        '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
        );
        Http http = new Http();
        HttpResponse response = http.send(loginRequest);
        return response;
    }

}