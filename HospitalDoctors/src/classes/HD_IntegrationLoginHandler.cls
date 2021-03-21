/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class HD_IntegrationLoginHandler {



    public static String login() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(HD_Utils.retrieveCredentials('LoginEndpoint'));
        req.setMethod('POST');
        String username = HD_Utils.retrieveCredentials('DBLogin');
        String password = HD_Utils.retrieveCredentials('DBPassword');
        String grantType = 'password';
        String clientId = HD_Utils.retrieveCredentials('clientID');
        String clientSecret = HD_Utils.retrieveCredentials('clientSecret');
        req.setBody(
                'grant_type=password' +
                        '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
        );
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;
       // Cache.Session.put('authorization', authorization);
        return authorization;

    }


}