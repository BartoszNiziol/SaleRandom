public with sharing class HD_SearchForDoctorController {

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    HD_SearchForDoctorSearchHelper searchHelper = new HD_SearchForDoctorSearchHelper();
    public String sortDirection = 'ASC';
    public String actualSortExpression = 'Name';

    public String sortExpression {
        get {
            return actualSortExpression;
        }
        set {
            if (value == actualSortExpression) {
                sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC';
            } else {
                sortDirection = 'ASC';
                actualSortExpression = value;
            }
        }
    }

    public String getSortDirection() {
        if ((sortExpression == null) || (sortExpression == '')) {
            return 'ASC';
        } else {
            return sortDirection;
        }
    }

    public void setSortDirection(String value){
        sortDirection = value;
    }

    public HD_SearchForDoctorController(ApexPages.StandardController standardController) {
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();
        foundDoctors = new List<Doctor__c>();
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression,sortDirection );
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }

}