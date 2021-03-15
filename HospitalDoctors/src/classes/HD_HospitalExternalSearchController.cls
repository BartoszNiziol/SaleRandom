/**
 * Created by BRITENET on 15.03.2021.
 */

public with sharing class HD_HospitalExternalSearchController {
    public String authorization { get; set; }
    public List<String> countriesList { get; set; }
    public List<HD_HospitalFormWrapper> foundHospitals { get; set; }
    public HD_HospitalFormWrapper inputSearchFormHospital { get; set; }
    public HD_HospitalFormWrapper inputUpsertFormHospital { get; set; }
    public String toDeleteId { get; set; }
    public String toEditId { get; set; }
    public Boolean isDialogReadyToClose { get; set; }
    public Boolean editDialog { get; set; }
    public Boolean addDialog { get; set; }
    public String selectedCountryForSearch { get; set; }
    public String selectedCountryForUpsert { get; set; }
    public List <SelectOption> countriesSet { get; set; }


    public HD_HospitalExternalSearchController() {
        inputSearchFormHospital = new HD_HospitalFormWrapper();
        foundHospitals = new List<HD_HospitalFormWrapper>();
        inputUpsertFormHospital = new HD_HospitalFormWrapper();
        login();
        populateCountriesList();
    }

    public void searchButtonAction() {
        foundHospitals = new List<HD_HospitalFormWrapper>();

        String nameSearchValue = inputSearchFormHospital.name;
        String emailSearchValue = inputSearchFormHospital.email;
        String countrySearchValue = inputSearchFormHospital.country;
        String endpointString = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital?';
        endpointString += 'name=' + nameSearchValue + '&' + 'email=' + emailSearchValue + '&' + 'country=' + countrySearchValue;

        System.debug(endpointString);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);

        Http http = new Http();
        HttpResponse res = http.send(req);
        List <Object> params = (List<Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        List<HD_HospitalFormWrapper> rewritedHospitals = new List<HD_HospitalFormWrapper>();
        for (Object o : params) {
            HD_HospitalFormWrapper singleWrapper = new HD_HospitalFormWrapper();
            Map<String, Object> parsedHospital = (Map<String, Object>) o;
            singleWrapper.name = (String) parsedHospital.get('hospitalName');
            singleWrapper.email = (String) parsedHospital.get('email');
            singleWrapper.country = (String) parsedHospital.get('country');
            singleWrapper.city = (String) parsedHospital.get('city');
            singleWrapper.id = (String) parsedHospital.get('id');
            rewritedHospitals.add(singleWrapper);
        }

        foundHospitals = rewritedHospitals;


    }

    public void saveButtonAction() {
        String endpointString = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        req.setBody(
                'id=' + inputUpsertFormHospital.Id + '&name=' + inputUpsertFormHospital.name + '&email=' + inputUpsertFormHospital.email + '&country=' + inputUpsertFormHospital.country
        );

        Http http = new Http();
        HttpResponse res = http.send(req);
    }

    public void deleteButtonAction() {
        String endpointString = 'https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital?';
        endpointString += 'id=' + toDeleteId;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('DELETE');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HD_HospitalFormWrapper hospToRemoveFromList;
        HttpResponse res = http.send(req);
        for (HD_HospitalFormWrapper hosp : foundHospitals) {
            if (hosp.Id == toDeleteId) {
                hospToRemoveFromList = hosp;
                break;
            }
        }
        foundHospitals.remove(foundHospitals.indexOf(hospToRemoveFromList));

    }

    private void populateCountriesList() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://britenet62-dev-ed.my.salesforce.com//services/apexrest/Hospital');
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
        countriesSet = new List<SelectOption>();
        countriesList = singleCountries;
        for (String country : countriesList) {
            countriesSet.add(new SelectOption(country, country));
        }
    }

    public void login() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        String username = 'eggshell@britenet.com';
        String password = 'poco2jestem23dw3WF2mrIHOvMUy2nk2548';
        String grantType = 'password';
        String clientId = '3MVG9SOw8KERNN0_MmtOtA1pCB39Fgw9ZYCjbgI4oGI3Iv5xPRQ2vGwIP8SjAqKMfdkC8aNkwHKtFnyzdCKIS';
        String clientSecret = 'F365E2D8A3745E3BFA77E9D514AF7F9B4EF6A698BD054E9BFAD50186BBD8D894';

        req.setBody(
                'grant_type=password' +
                        '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
        );

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        String accesToken = (String) params.get('access_token');
        authorization = 'Bearer ' + accesToken;
    }

    public void setEditedIdNull() {
        toEditId = null;
        inputUpsertFormHospital = new HD_HospitalFormWrapper();
        isDialogReadyToClose = false;
    }

    public void clearButtonAction() {
        inputSearchFormHospital = new HD_HospitalFormWrapper();
        foundHospitals = new List<HD_HospitalFormWrapper>();
    }

    public void setEditedForm() {
        isDialogReadyToClose = false;
        for (HD_HospitalFormWrapper hospital : foundHospitals) {
            if (hospital.Id == toEditId) {
                inputUpsertFormHospital = hospital;
                break;
            }
        }
    }

}