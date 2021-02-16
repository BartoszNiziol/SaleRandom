

public with sharing class HD_DoctorSearchController {

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public HD_DoctrSearchHelper searchHelper = new HD_DoctrSearchHelper();
    public String sortDirection = 'ASC';
    public String actualSortExpression = 'Name';
    public ApexPages.StandardSetController setController {get;set;}
    public Integer pageSize = 5;


    public HD_DoctorSearchController(ApexPages.StandardController standardController) {
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();
        foundDoctors = new List<Doctor__c>();
        setController = new ApexPages.StandardSetController(foundDoctors);

    }

    public List<Doctor__c> getResultsForCsv(){
        setController.setPageSize(setController.getResultSize());
        return (List<Doctor__c>) setController.getRecords();
    }
    public void getPrepereCSV(){
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression,sortDirection );
    }

    public void spin() {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
    }

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
    public PageReference exportCSV(){
        PageReference pageReference = new PageReference('https://resourceful-goat-uzeiu7-dev-ed--c.visualforce.com/apex/HD_DoctorSearchExportToCSV');
        pageReference.setRedirect(true);

        return pageReference;
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression,sortDirection );
        setController = new ApexPages.StandardSetController(foundDoctors);
        setController.setPageSize(pageSize);
        foundDoctors = (List<Doctor__c>) setController.getRecords();
        System.debug(foundDoctors);
    }
    public void search2() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression,sortDirection );
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }

    public List<Doctor__c> getlistDoctors(){
        return (List<Doctor__c>)setController.getRecords();
    }

    public Boolean hasNext {
        get {
            if(setController != null) {
                return setController.getHasNext();
            } else {
                return false;
            }
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            if(setController != null) {
                return setController.getHasPrevious();
            }else {
                return false;
            }
        }
        set;
    }

    public Integer pageNumber {
        get {
            return setController.getPageNumber();
        }
        set;
    }

    public void next() {
        setController.next();

    }
    public void first() {
        setController.first();
    }

    public void last() {
        setController.last();
    }

    public void previous() {
        setController.previous();
    }



}