public with sharing class HD_DoctorExternalSearchController {

    public Doctor__c inputSearchFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public Doctor__c inputUpsertFormDoctor { get; set; }
    public String dBSesionId { get; set; }
    public String toDeleteId { get; set; }
    public String toEditId { get; set; }


    public HD_DoctorExternalSearchController() {
        inputSearchFormDoctor = new Doctor__c();
        foundDoctors = new List<Doctor__c>();
        inputUpsertFormDoctor = new Doctor__c();
        getSessionId();
    }

    private void getSessionId() {
        partnerSoapSforceCom.Soap obj = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult loginResult = obj.login('EggShell@Britenet.com', 'poco2jestem23dw3WF2mrIHOvMUy2nk2548');
        obj.SessionHeader = new partnerSoapSforceCom.SessionHeader_element();
        obj.endpoint_x = loginResult.ServerUrl;
        obj.Sessionheader.sessionid = loginResult.sessionid;
        dbSesionId = loginResult.sessionid;
    }



    public void searchButtonAction() {
        foundDoctors = new List<Doctor__c>();
        DoctorExternalBaseService.DB_DoctorExternalSearchWebService service = new DoctorExternalBaseService.DB_DoctorExternalSearchWebService();
        Map<String, String> inputHttpHeaders = new Map<String, String>();
        inputHttpHeaders.put('Content-Type', 'text/xml');
        inputHttpHeaders.put('Accept', 'text/xml');
        inputHttpHeaders.put('SoapAction', '');
        DoctorExternalBaseService.SessionHeader_element sessionId = new DoctorExternalBaseService.SessionHeader_element();
        sessionId.sessionId = dBSesionId;
        service.inputHttpHeaders_x = inputHttpHeaders;
        service.SessionHeader = sessionId;
        DoctorExternalBaseWrapper.DB_DoctorResponseWrapper[] wrap = service.getDoctors(inputSearchFormDoctor.First_Name__c, inputSearchFormDoctor.Name, inputSearchFormDoctor.Email__c, inputSearchFormDoctor.Country__c);
        if (wrap != null) {
            if (wrap.size() != 0) {
                for (DoctorExternalBaseWrapper.DB_DoctorResponseWrapper wrapElement : wrap) {
                    Doctor__c doctor = new Doctor__c();
                    doctor.Id = wrapElement.id;
                    doctor.First_Name__c = wrapElement.firstName;
                    doctor.Name = wrapElement.lastName;
                    doctor.Country__c = wrapElement.country;
                    doctor.Email__c = wrapElement.email;
                    foundDoctors.add(doctor);
                }
            }
        }
    }

//    public void newButtonAction() {
//
//        DoctorExternalBaseService.DB_DoctorExternalSearchWebService service = new DoctorExternalBaseService.DB_DoctorExternalSearchWebService();
//        Map<String, String> inputHttpHeaders = new Map<String, String>();
//        inputHttpHeaders.put('Content-Type', 'text/xml');
//        inputHttpHeaders.put('Accept', 'text/xml');
//        inputHttpHeaders.put('SoapAction', '');
//        DoctorExternalBaseService.SessionHeader_element sessionId = new DoctorExternalBaseService.SessionHeader_element();
//        sessionId.sessionId = dBSesionId;
//        service.inputHttpHeaders_x = inputHttpHeaders;
//        service.SessionHeader = sessionId;
//        DoctorExternalBaseWrapper.DB_DoctorResponseWrapper wrap = service.addDoctor(inputUpsertFormDoctor.First_Name__c, inputUpsertFormDoctor.Name, inputUpsertFormDoctor.Email__c, inputUpsertFormDoctor.Country__c);
//    }
//
//    public void editButtonAction() {
//        System.debug(toEditId);
//        DoctorExternalBaseService.DB_DoctorExternalSearchWebService service = new DoctorExternalBaseService.DB_DoctorExternalSearchWebService();
//        Map<String, String> inputHttpHeaders = new Map<String, String>();
//        inputHttpHeaders.put('Content-Type', 'text/xml');
//        inputHttpHeaders.put('Accept', 'text/xml');
//        inputHttpHeaders.put('SoapAction', '');
//        DoctorExternalBaseService.SessionHeader_element sessionId = new DoctorExternalBaseService.SessionHeader_element();
//        sessionId.sessionId = dBSesionId;
//        service.inputHttpHeaders_x = inputHttpHeaders;
//        service.SessionHeader = sessionId;
//        DoctorExternalBaseWrapper.DB_DoctorResponseWrapper wrap = service.updateDoctor(toEditId,inputUpsertFormDoctor.First_Name__c, inputUpsertFormDoctor.Name, inputUpsertFormDoctor.Email__c, inputUpsertFormDoctor.Country__c);
//    }

    public void saveButtonAction() {
        DB_SearchApi.DB_DoctorExternalSearchWebService service = new  DB_SearchApi.DB_DoctorExternalSearchWebService();
        Map<String, String> inputHttpHeaders = new Map<String, String>();
        inputHttpHeaders.put('Content-Type', 'text/xml');
        inputHttpHeaders.put('Accept', 'text/xml');
        inputHttpHeaders.put('SoapAction', '');
        DB_SearchApi.SessionHeader_element sessionId = new DB_SearchApi.SessionHeader_element();
        sessionId.sessionId = dBSesionId;
        service.inputHttpHeaders_x = inputHttpHeaders;
        service.SessionHeader = sessionId;
        DB_ResponseWrapper.DB_DoctorResponseWrapper wrap = service.upsertDoctor(toEditId,inputUpsertFormDoctor.First_Name__c, inputUpsertFormDoctor.Name, inputUpsertFormDoctor.Email__c, inputUpsertFormDoctor.Country__c);
        System.debug('saveButtonmesage');
        System.debug(wrap.message);
        System.debug(wrap.isSuccess);

    }

    public void deleteButtonAction() {
        DoctorExternalBaseService.DB_DoctorExternalSearchWebService service = new DoctorExternalBaseService.DB_DoctorExternalSearchWebService();
        Map<String, String> inputHttpHeaders = new Map<String, String>();
        inputHttpHeaders.put('Content-Type', 'text/xml');
        inputHttpHeaders.put('Accept', 'text/xml');
        inputHttpHeaders.put('SoapAction', '');
        DoctorExternalBaseService.SessionHeader_element sessionId = new DoctorExternalBaseService.SessionHeader_element();
        sessionId.sessionId = dBSesionId;
        service.inputHttpHeaders_x = inputHttpHeaders;
        service.SessionHeader = sessionId;
        DoctorExternalBaseWrapper.DB_DoctorResponseWrapper wrap = service.deleteDoctor(toDeleteId);
        Doctor__c docToRemoveFromList;

        for (Doctor__c doc: foundDoctors){

            if (doc.Id == toDeleteId) {
                docToRemoveFromList = doc;
            }
        }
        foundDoctors.remove(foundDoctors.indexOf(docToRemoveFromList));
    }

    public void clearButtonAction() {
        inputSearchFormDoctor = new Doctor__c();
        foundDoctors = new List<Doctor__c>();
    }

    public void setEditedIdNull(){
        toEditId = null;
    }


}