/**
 * Created by BRITENET on 01.03.2021.
 */

public without sharing class HD_DoctorRandomListController {

    public Doctor__c doctor{get;set;}
    public List<Doctor__c> allDoctors{get;set;}
    public List<Doctor__c> randomDoctors{get;set;}


    public HD_DoctorRandomListController(ApexPages.StandardController standardController){
        doctor = (Doctor__c) standardController.getRecord();
        allDoctors = [SELECT Id,First_Name__c,Name,Country__c,Email__c FROM Doctor__c];
        randomDoctors = new List<Doctor__c>();
        System.debug('before shufle in constructor');
        shufle();
        System.debug('after shufle in constructor');
        doctor = [SELECT Id FROM Doctor__c LIMIT 1];
    }

    public void shufle(){
        System.debug('shufle start');

        for (Integer i =0; i<5; i++){
            Integer randomNumber = Integer.valueOf((Math.random() * 8));
           randomDoctors.add(allDoctors.get(randomNumber));
        }
        System.debug('shufle end');
    }
}