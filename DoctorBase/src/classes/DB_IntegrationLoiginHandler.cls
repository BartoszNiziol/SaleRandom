/**
 * Created by BRITENET on 19.03.2021.
 */

public with sharing class DB_IntegrationLoiginHandler {

    public HttpResponse login() {
        HttpResponse res = loginCallout();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        String accesToken = (String) params.get('access_token');
        String authorization = 'Bearer ' + accesToken;
        Cache.Session.put('authorization', authorization);
        return res;
    }

    public HttpResponse loginCallout(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(DB_Utils.retrieveCredentials('LoginEndpoint'));

        req.setMethod('POST');
        String username = DB_Utils.retrieveCredentials('HDLogin');
        System.debug('username');
        System.debug(username);
        String password = DB_Utils.retrieveCredentials('HDPassword');
        System.debug('password');
        System.debug(password);
        String grantType = 'password';
        String clientId = DB_Utils.retrieveCredentials('clientID');
        String clientSecret = DB_Utils.retrieveCredentials('clientSecret');
        req.setBody(
                'grant_type=password' +
                        '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
        );
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(req.getBody());
        System.debug(req.getEndpoint());

        return res;

    }

}