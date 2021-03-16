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
    public HD_HospitalDBHandler dbHandler {get; set;}


    public HD_HospitalExternalSearchController() {
        dbHandler = new HD_HospitalDBHandler();
        inputSearchFormHospital = new HD_HospitalFormWrapper();
        foundHospitals = new List<HD_HospitalFormWrapper>();
        inputUpsertFormHospital = new HD_HospitalFormWrapper();
        authorization = dbHandler.login();
        authorization = (String) Cache.Session.get('authorization');
        dbHandler.populateCountriesList(authorization);
        countriesSet = (List<SelectOption>) Cache.Org.get('countriesValues');

    }

    public void searchButtonAction() {
        foundHospitals = new List<HD_HospitalFormWrapper>();

        String nameSearchValue = inputSearchFormHospital.name;
        String emailSearchValue = inputSearchFormHospital.email;
        String countrySearchValue = selectedCountryForSearch;
        if(emailSearchValue == ''){
            emailSearchValue = null;
        }
        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint')+'?';
        endpointString += 'name=' + nameSearchValue + '&' + 'email=' + emailSearchValue + '&' + 'country=' + countrySearchValue;

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
        System.debug(foundHospitals);
    }

    public void saveButtonAction() {
        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointString);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorization);

        req.setBody(
                 '{"name" : "' + inputUpsertFormHospital.name + '", "email" : "' + inputUpsertFormHospital.email + '" , "country" : "' + selectedCountryForUpsert +'","id" : "' + inputUpsertFormHospital.Id+'"}'
        );
        Http http = new Http();
        System.debug(req.getBody());
        HttpResponse res = http.send(req);
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
                res.getBody()
        );
        System.debug(params);
        Boolean isSuccess =(Boolean) params.get('isSuccess');
        String message =(String) params.get('message');
        System.debug(isSuccess);
        System.debug(message);
        if (isSuccess == false) {
            isDialogReadyToClose = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
            ApexPages.addMessage(myMsg);
        } else {
            isDialogReadyToClose = true;
        }
        searchButtonAction();

    }

    public void deleteButtonAction() {
        String endpointString = HD_Utils.retrieveCredentials('databaseEndpoint')+'?';
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

    private void setEditedIdNull() {
        toEditId = null;
        inputUpsertFormHospital = new HD_HospitalFormWrapper();
        isDialogReadyToClose = false;
    }

    private void clearButtonAction() {
        inputSearchFormHospital = new HD_HospitalFormWrapper();
        foundHospitals = new List<HD_HospitalFormWrapper>();
    }

    private void setEditedForm() {
        isDialogReadyToClose = false;
        for (HD_HospitalFormWrapper hospital : foundHospitals) {
            if (hospital.Id == toEditId) {
                inputUpsertFormHospital = hospital;
                selectedCountryForUpsert = hospital.country;
                break;
            }
        }
    }

}