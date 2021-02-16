/**
 * Created by BRITENET on 16.02.2021.
 */

public with sharing class HD_DoctorSearchPaginationController {

    private Doctor__c inputFormDoctor;

    HD_DoctrSearchHelper helper = new HD_DoctrSearchHelper();

    public  HD_DoctorSearchPaginationController(ApexPages.StandardController standardController){
        this.inputFormDoctor = (Doctor__c) standardController.getRecord();

    }

    public ApexPages.StandardSetController con {
        get {
            String mainSearchQuery = helper.queryDoctorsString(inputFormDoctor.First_Name__c,inputFormDoctor.Name,inputFormDoctor.Email__c,inputFormDoctor.Country__c,'','');
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator(mainSearchQuery));
                con.setPageSize(5);
            }
            return con;
        }
        set;
    }

    public List<Doctor__c> getlistDoctors(){
        return (List<Doctor__c>)con.getRecords();
    }

    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    public void first() {
        con.first();
    }

    public void last() {
        con.last();
    }

    public void previous() {
        con.previous();
    }

    public void next() {
        con.next();
    }

    public void cancel() {
        con.cancel();
    }
}
