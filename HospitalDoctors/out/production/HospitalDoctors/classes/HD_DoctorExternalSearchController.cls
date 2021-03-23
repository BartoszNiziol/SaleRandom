public with sharing class HD_DoctorExternalSearchController {

    public HD_DoctorFormResponseWrapper inputSearchFormDoctor { get; set; }
    public List<HD_DoctorFormResponseWrapper> foundDoctors { get; set; }
    public HD_DoctorFormResponseWrapper inputUpsertFormDoctor { get; set; }
    public String dBSesionId { get; set; }
    public String toDeleteId { get; set; }
    public String toEditId { get; set; }
    public Boolean isDialogReadyToClose { get; set; }
    public Boolean editDialog { get; set; }
    public Boolean addDialog { get; set; }
    public String selectedCountryForSearch { get; set; }
    public String selectedCountryForUpsert { get; set; }
    public List <SelectOption> countriesSet { get; set; }
    public List <String> requestCountries {get; set;}

    public HD_DoctorExternalSearchController() {
        inputSearchFormDoctor = new HD_DoctorFormResponseWrapper();
        foundDoctors = new List<HD_DoctorFormResponseWrapper>();
        inputUpsertFormDoctor = new HD_DoctorFormResponseWrapper();
        getSessionId();
        populateCountriesList();
    }

    public void searchButtonAction() {
        foundDoctors = new List<HD_DoctorFormResponseWrapper>();
        DB_SearchApi.DB_DoctorExternalSearchWebService service = configureService();
        DB_ResponseWrapper.DB_DoctorResponseWrapper[] wrap = service.getDoctors(inputSearchFormDoctor.firstName, inputSearchFormDoctor.lastName, inputSearchFormDoctor.email, selectedCountryForSearch);
        if (wrap != null) {
            if (wrap.size() != 0) {
                for (DB_ResponseWrapper.DB_DoctorResponseWrapper wrapElement : wrap) {
                    HD_DoctorFormResponseWrapper doctor = new HD_DoctorFormResponseWrapper();
                    doctor.id = wrapElement.id;
                    doctor.firstName = wrapElement.firstName;
                    doctor.lastName = wrapElement.lastName;
                    doctor.country = wrapElement.country;
                    doctor.email = wrapElement.email;
                    foundDoctors.add(doctor);
                }
            }
        }
    }

    public void saveButtonAction() {
        isDialogReadyToClose = false;
        DB_SearchApi.DB_DoctorExternalSearchWebService service = configureService();
        DB_ResponseWrapper.DB_DoctorResponseWrapper wrap = service.upsertDoctor(toEditId, inputUpsertFormDoctor.firstName, inputUpsertFormDoctor.lastName, inputUpsertFormDoctor.email, selectedCountryForUpsert);
        System.debug(wrap.isSuccess);
        if (wrap.isSuccess == false) {
            isDialogReadyToClose = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, wrap.message);
            ApexPages.addMessage(myMsg);

        } else {
            isDialogReadyToClose = true;
        }
        searchButtonAction();
    }

    public void deleteButtonAction() {
        DB_SearchApi.DB_DoctorExternalSearchWebService service = configureService();
        DB_ResponseWrapper.DB_DoctorResponseWrapper wrap = service.deleteDoctor(toDeleteId);
        HD_DoctorFormResponseWrapper docToRemoveFromList;
        for (HD_DoctorFormResponseWrapper doc : foundDoctors) {
            if (doc.Id == toDeleteId) {
                docToRemoveFromList = doc;
                break;
            }
        }
        foundDoctors.remove(foundDoctors.indexOf(docToRemoveFromList));
    }

    public void clearButtonAction() {
        inputSearchFormDoctor = new HD_DoctorFormResponseWrapper();
        foundDoctors = new List<HD_DoctorFormResponseWrapper>();
    }

    public void setEditedIdNull() {
        toEditId = null;
        inputUpsertFormDoctor = new HD_DoctorFormResponseWrapper();
        isDialogReadyToClose = false;
    }

    public void setEditedForm() {
        isDialogReadyToClose = false;
        for (HD_DoctorFormResponseWrapper doctor : foundDoctors) {
            if (doctor.Id == toEditId) {
                inputUpsertFormDoctor = doctor;
                break;
            }
        }
    }

    private DB_SearchApi.DB_DoctorExternalSearchWebService configureService() {
        DB_SearchApi.DB_DoctorExternalSearchWebService service = new DB_SearchApi.DB_DoctorExternalSearchWebService();
        Map<String, String> inputHttpHeaders = new Map<String, String>();
        inputHttpHeaders.put('Content-Type', 'text/xml');
        inputHttpHeaders.put('Accept', 'text/xml');
        inputHttpHeaders.put('SoapAction', '');
        DB_SearchApi.SessionHeader_element sessionId = new DB_SearchApi.SessionHeader_element();
        sessionId.sessionId = dBSesionId;
        service.inputHttpHeaders_x = inputHttpHeaders;
        service.SessionHeader = sessionId;
        return service;
    }

    private void getSessionId() {
        partnerSoapSforceCom.Soap obj = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = obj.login(HD_Utils.retrieveCredentials('DBLogin'), HD_Utils.retrieveCredentials('DBPassword'));
        obj.SessionHeader = new partnerSoapSforceCom.SessionHeader_element();
        obj.endpoint_x = loginResult.ServerUrl;
        obj.Sessionheader.sessionid = loginResult.sessionid;
        dbSesionId = loginResult.sessionid;

    }

    private void populateCountriesList() {
        DB_ValuesService.DB_DoctorValuesWebService service = new DB_ValuesService.DB_DoctorValuesWebService();
        Map<String, String> inputHttpHeaders = new Map<String, String>();
        inputHttpHeaders.put('Content-Type', 'text/xml');
        inputHttpHeaders.put('Accept', 'text/xml');
        inputHttpHeaders.put('SoapAction', '');
        DB_ValuesService.SessionHeader_element sessionId = new DB_ValuesService.SessionHeader_element();
        sessionId.sessionId = dBSesionId;
        service.inputHttpHeaders_x = inputHttpHeaders;
        service.SessionHeader = sessionId;
        DB_DataListWrapper.DB_DoctorCountriesResponseWrapper wrap = service.getCountries();
        requestCountries = wrap.countries;
        countriesSet = new List<SelectOption>();
        for(String c: requestCountries){
            countriesSet.add(new SelectOption(c,c));
        }

    }
}