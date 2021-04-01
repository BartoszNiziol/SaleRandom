/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class DB_IntegrationLoiginHandler {

    public static  HttpResponse loginCallout(){
        HttpRequest loginRequest = new HttpRequest();
        loginRequest.setEndpoint(DB_Utils.retrieveCredentials('LoginEndpoint'));
        loginRequest.setMethod('POST');
        String username = DB_Utils.retrieveCredentials('HDLogin');
        String password = DB_Utils.retrieveCredentials('HDPassword');
//         password = 'ugabuga';
        String grantType = 'password';
        String clientId = DB_Utils.retrieveCredentials('clientID');
        String clientSecret = DB_Utils.retrieveCredentials('clientSecret');
        loginRequest.setBody(
                'grant_type=password' +
                        '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
        );
        Http http = new Http();
        return http.send(loginRequest);
    }


}