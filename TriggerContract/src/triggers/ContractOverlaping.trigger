/**
 * Created by BRITENET on 10.02.2021.
 */

trigger ContractOverlaping on Contract__c (after insert, after update) {
                  Id addedId = null;
                  List<Contract__c > invalidContract = new List<Contract__c>();
                  Boolean isOverlaped = false;

          //  if(Trigger.isInsert){
                For(Contract__c c :Trigger.new){
                    List<Contract__c> matchedContracts =   [
                             SELECT Id,Start_Date__c,End_Date__c
                             FROM Contract__c
                             WHERE Doctor__c = :c.Doctor__c AND Hospital__c = :c.Hospital__c];

                            System.debug(matchedContracts);

                            for(Contract__c match :matchedContracts){

                                if(isOverlaped(c,match)){
                                    invalidContract.add(match);
                                    isOverlaped = true;
                                }
                            }
                            addedId = c.Id;
                }


        if(isOverlaped) {
            String errorMessage = 'Contract that you trying to create is overlaping with : ';
            for (Contract__c inv : invalidContract) {
                errorMessage += inv.Id + ' ';
            }

            Trigger.newMap.get(addedId).addError(errorMessage);
        }


        private Boolean isOverlaped(Contract__c oldContract,Contract__c newContract){
            if(oldContract.End_Date__c==null){
                if(oldContract.Start_Date__c<newContract.End_Date__c || oldContract.Start_Date__c < newContract.Start_Date__c){
                    return true;
                }
            }
            if (newContract.End_Date__c == null){

                if(oldContract.End_Date__c > newContract.Start_Date__c){
                    return true;
                }
            }

            if(    (oldContract.Start_Date__c > newContract.Start_Date__c) && (oldContract.Start_Date__c < newContract.End_Date__c)
                    || (oldContract.End_Date__c > newContract.Start_Date__c   && oldContract.End_Date__c < newContract.End_Date__c)
                    || (oldContract.Start_Date__c < newContract.Start_Date__c && oldContract.End_Date__c > newContract.End_Date__c)
                    || (oldContract.Start_Date__c > newContract.Start_Date__c && oldContract.End_Date__c < newContract.End_Date__c)){
                return true;
            }
            return false;
        }




}