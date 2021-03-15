global class DB_IdentyficationResponseWrapper {
        webService String id;
        webService String message;
        webService Boolean isSuccess;

    public DB_IdentyficationResponseWrapper(Doctor__c doctor) {
        this.id = doctor.Id;
        message = 'Success';
    }

    public DB_IdentyficationResponseWrapper(){
        
    }
}