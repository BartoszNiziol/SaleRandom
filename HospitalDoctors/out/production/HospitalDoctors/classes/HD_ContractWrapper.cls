/**
 * Created by BRITENET on 25.02.2021.
 */

public with sharing class HD_ContractWrapper {
    public String status {get;set;}
    public Boolean isOpenForEdit {get;set;}
    public Contract__c contract {get;set;}


    public HD_ContractWrapper (){

    }
    public HD_ContractWrapper(Contract__c contract){
        this.contract = contract;
        isOpenForEdit = false;
        status = 'Waiting';

    }

}