/**
 * Created by BRITENET on 16.03.2021.
 */

public with sharing class HD_HospitalDBHandler {

    public String login() {
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

        Cache.Session.put('authorization',authorization);
        return authorization;
    }

    public void populateCountriesList(String authorization) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint(HD_Utils.retrieveCredentials('databaseEndpoint'));
        req.setMethod('PUT');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        List<String> singleCountries = new List<String>();
        List<Object> countries = (List<Object>) params.get('countries');
        for (Object o : countries) {
            singleCountries.add(String.valueOf(o));
        }
        List<SelectOption> countriesSet = new List<SelectOption>();
        for (String country : singleCountries) {
            countriesSet.add(new SelectOption(country, country));
        }
            Cache.Org.put('countriesValues',countriesSet);
    }

}