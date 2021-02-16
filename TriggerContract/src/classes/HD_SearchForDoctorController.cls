

public with sharing class HD_SearchForDoctorController {

    public String sortDirection = 'ASC';
    public String sortExp = 'Name';

    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            if (value == sortExp) {
                sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC';
            } else {
                sortDirection = 'ASC';
                sortExp = value;
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

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    HD_SearchForDoctorSearchHelper searchHelper = new HD_SearchForDoctorSearchHelper();

    public HD_SearchForDoctorController(ApexPages.StandardController standardController) {
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();
        foundDoctors = new List<Doctor__c>();
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c,sortExp,sortDirection );
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }

}