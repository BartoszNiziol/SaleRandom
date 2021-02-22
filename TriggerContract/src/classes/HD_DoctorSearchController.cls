

public with sharing class HD_DoctorSearchController {

    public Doctor__c inputFormDoctor { get; set; }
    public List<Doctor__c> foundDoctors { get; set; }
    public HD_DoctorSearchHandler searchHelper { get; set; }
    public String sortDirection = 'ASC';
    public String actualSortExpression = 'Name';
    public ApexPages.StandardSetController setController { get; set; }
    public Integer pageSize = 5;

    public HD_DoctorSearchController() {
        inputFormDoctor = new Doctor__c();
        searchHelper = new HD_DoctorSearchHandler();
    }

    public void spin() {
        long now = datetime.now().gettime();
        while (datetime.now().gettime() - now < 5000); // Busy loop for 5000 ms
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

    public PageReference exportCSV() {
        setController.setPageSize(setController.getResultSize());
        foundDoctors = setController.getRecords();
        PageReference page = Page.HD_DoctorSearchExportToCSV;
        page.setRedirect(false);
        return page;
    }

    public PageReference exportXML() {
        setController.setPageSize(setController.getResultSize());
        foundDoctors = setController.getRecords();
        PageReference page = Page.HD_DoctorSearchExportToXML;
        page.setRedirect(false);
        return page;
    }

    public void search() {
        foundDoctors = searchHelper.queryDoctors(inputFormDoctor.First_Name__c, inputFormDoctor.Name, inputFormDoctor.Email__c, inputFormDoctor.Country__c, actualSortExpression, sortDirection);
        setController = new ApexPages.StandardSetController(foundDoctors);
        setController.setPageSize(pageSize);
        foundDoctors = (List<Doctor__c>) setController.getRecords();
    }

    public void clear() {
        foundDoctors = new List<Doctor__c>();
        inputFormDoctor = new Doctor__c();
    }

    public Boolean hasNext {
        get {
            if (setController != null) {
                return setController.getHasNext();
            } else {
                return false;
            }
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            if (setController != null) {
                return setController.getHasPrevious();
            } else {
                return false;
            }
        }
        set;
    }

    public void next() {
        setController.next();
        foundDoctors =(List<Doctor__c>) setController.getRecords();

    }
    public void first() {
        setController.first();
        foundDoctors =(List<Doctor__c>) setController.getRecords();
    }

    public void last() {
        setController.last();
        foundDoctors =(List<Doctor__c>) setController.getRecords();
    }

    public void previous() {
        setController.previous();
        foundDoctors =(List<Doctor__c>) setController.getRecords();
    }


}