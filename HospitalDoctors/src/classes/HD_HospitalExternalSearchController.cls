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
    public HD_HospitalDBHandler dbHandler { get; set; }

    public HD_HospitalExternalSearchController() {
        dbHandler = new HD_HospitalDBHandler();
        inputSearchFormHospital = new HD_HospitalFormWrapper();
        foundHospitals = new List<HD_HospitalFormWrapper>();
        inputUpsertFormHospital = new HD_HospitalFormWrapper();
        loginCacheResourcesCheck();
        authorization = (String) Cache.Session.get('authorization');
        countriesCacheResourcesCheck();
        countriesSet = (List<SelectOption>) Cache.Org.get('countriesValues');
    }

    public void searchButtonAction() {
        foundHospitals = new List<HD_HospitalFormWrapper>();
        foundHospitals = dbHandler.searchRequest(authorization, inputSearchFormHospital.name, inputSearchFormHospital.email, selectedCountryForSearch);
    }

    public void saveButtonAction() {
        isDialogReadyToClose = dbHandler.upsertRequest(authorization, inputUpsertFormHospital.name, inputUpsertFormHospital.email, selectedCountryForUpsert, inputUpsertFormHospital.Id);
        searchButtonAction();
    }

    public void deleteButtonAction() {
        dbHandler.deleteRequest(authorization, toDeleteId);
        HD_HospitalFormWrapper hospToRemoveFromList;
        for (HD_HospitalFormWrapper hosp : foundHospitals) {
            if (hosp.Id == toDeleteId) {
                hospToRemoveFromList = hosp;
                break;
            }
        }
        foundHospitals.remove(foundHospitals.indexOf(hospToRemoveFromList));
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
                selectedCountryForUpsert = hospital.country;
                break;
            }
        }
    }

    public void loginCacheResourcesCheck() {
        if (Cache.Session.get('authorization') == null) {
            dbHandler.login();
        }
    }

    public void countriesCacheResourcesCheck() {
        if ((List<SelectOption>) Cache.Org.get('countriesValues') == null) {
            dbHandler.populateCountriesList(authorization);
        }
    }

}