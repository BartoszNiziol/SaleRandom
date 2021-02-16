

public with sharing class HD_DoctorSearchController {

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    HD_DoctrSearchHelper searchHelper = new HD_DoctrSearchHelper();
    public String sortDirection = 'ASC';
    public String actualSortExpression = 'Name';
    public ApexPages.StandardSetController setController {get;set;}
    public Integer pageSize = 5;

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

    public HD_DoctorSearchController(ApexPages.StandardController standardController) {
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();
        foundDoctors = new List<Doctor__c>();
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression,sortDirection );
        setController = new ApexPages.StandardSetController(foundDoctors);
        setController.setPageSize(pageSize);
        foundDoctors = (List<Doctor__c>) setController.getRecords();
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }


}