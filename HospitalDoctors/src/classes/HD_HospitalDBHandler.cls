/**
 * Created by BRITENET on 16.03.2021.
 */

public with sharing class HD_HospitalDBHandler {

    public String authorization { get; set; }

    public void loginCacheResourcesCheck() {
        if (Cache.Session.get('authorization') == null) {
            login();
        }
        authorization = (String) Cache.Session.get('authorization');
    }

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
        return res;
    }

    public List<SelectOption> populateCountriesList() {
        loginCacheResourcesCheck();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(HD_Utils.retrieveCredentials('countriesEndpoint'));
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        System.debug(res.getBody());
        List<String> singleCountries = new List<String>();
        List<Object> countries = (List<Object>) params.get('countries');
        List<SelectOption> countriesSet = new List<SelectOption>();
        for (Object o : countries) {
            countriesSet.add(new SelectOption( String.valueOf(o),String.valueOf(o)));
        }
        Cache.Org.put('countriesValues', countriesSet);
        return countriesSet;
    }

    public List<HD_HospitalFormWrapper> searchRequest( String nameSearchValue, String emailSearchValue, String countrySearchValue) {
        loginCacheResourcesCheck();
        HttpResponse res = searchCallout(nameSearchValue,emailSearchValue,countrySearchValue);
        System.debug(res);
        List <Object> params = (List<Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        List<HD_HospitalFormWrapper> rewritedHospitals = new List<HD_HospitalFormWrapper>();
        for (Object o : params) {
            Map<String, Object> parsedHospital = (Map<String, Object>) o;
            HD_HospitalFormWrapper singleWrapper = new HD_HospitalFormWrapper(parsedHospital);
            rewritedHospitals.add(singleWrapper);
        }
        return rewritedHospitals;
    }

    public HttpResponse searchCallout(String nameSearchValue, String emailSearchValue, String countrySearchValue){
        if (emailSearchValue == '') {
            emailSearchValue = null;
        }
        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint') + '?';
        endpointString += 'name=' + nameSearchValue + '&' + 'email=' + emailSearchValue + '&' + 'country=' + countrySearchValue;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }

    public Boolean upsertRequest(String name, String email, String country, String id) {
        loginCacheResourcesCheck();
        HttpResponse res = upsertCallout(name,email,country,id);
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        Boolean isSuccess = (Boolean) params.get('isSuccess');
        String message = (String) params.get('message');
        Boolean isDialogReadyToClose;
        if (isSuccess == false) {
            isDialogReadyToClose = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
            ApexPages.addMessage(myMsg);
        } else {
            isDialogReadyToClose = true;
        }
        return isDialogReadyToClose;
    }

    public HttpResponse upsertCallout(String name, String email, String country, String id){

        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        req.setBody(
                '{"name" : "' + name + '", "email" : "' + email + '" , "country" : "' + country + '","id" : "' + id + '"}'
        );
        Http http = new Http();
        return http.send(req);
    }

    public HttpResponse deleteRequest( String id) {
        loginCacheResourcesCheck();
        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint') + '?';
        endpointString += 'id=' + id;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('DELETE');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HD_HospitalFormWrapper hospToRemoveFromList;
        HttpResponse res = http.send(req);
        return res;
    }


}