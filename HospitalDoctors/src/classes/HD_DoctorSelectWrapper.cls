/**
 * Created by BRITENET on 25.02.2021.
 */

public with sharing class HD_DoctorSelectWrapper {

   public Doctor__c doctor { get; set; }
   public Boolean isSelected { get; set; }
    public Boolean isOpenForEdit {get;set;}
//    public Date newContractStartDate{get;set;}
//    public Date newContractEndDate {get;set;}

    public HD_DoctorSelectWrapper(Doctor__c doctor) {
        this.doctor = doctor;
        isSelected = false;
        isOpenForEdit = false;
    }
    public HD_DoctorSelectWrapper(Doctor__c doctor,Boolean isSelected) {
        this.doctor = doctor;
        this.isSelected = isSelected;
        isOpenForEdit = false;
    }
    public Boolean equals(Object  obj){

        if (obj instanceof HD_DoctorSelectWrapper) {
            HD_DoctorSelectWrapper p = (HD_DoctorSelectWrapper) obj;
            return doctor.Id == p.doctor.Id;
        }
        return false;
    }




}