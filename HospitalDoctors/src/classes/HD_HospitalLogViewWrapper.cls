/**
 * Created by BRITENET on 28.03.2021.
 */

public with sharing class HD_HospitalLogViewWrapper {

    public HD_HospitalLogViewWrapper(String hospitalName, String methodName, String status, Datetime createDate){
        this.hospitalName = hospitalName;
        this.methodType = methodType;
        this.status = status;
        this.createDate= createDate;

    }
    public String hospitalName{get;set;}
    public String methodType{get;set;}
    public String status{get;set;}
    public Datetime createDate{get;set;}

}