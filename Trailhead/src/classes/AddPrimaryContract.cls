/**
 * Created by BRITENET on 31.03.2021.
 */

public with sharing class AddPrimaryContract implements Queueable{
    Contact contact{get;set;}
    String stateAbbreviation{get;set;}

    public AddPrimaryContract(Contact contact,String stateAbbreviation){
        this.contact = contact;
        this.stateAbbreviation = stateAbbreviation;
    }

        public void  execute(QueueableContext context){

            List<Account> accounts =  [SELECT Id,Name,BillingState FROM Account WHERE BillingState =: stateAbbreviation LIMIT 200];

            List<Contact> contacts = new List<Contact>();

            for (Account acc: accounts){
                Contact cont = new Contact();
                cont =this.contact.clone(false, false, false, false);
                cont.AccountId = acc.Id;
                contacts.add(cont);
            }
            insert contacts;

        }


}