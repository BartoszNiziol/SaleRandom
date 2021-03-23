trigger AddRelatedRecords on Account (after insert, after update) {
    
    List<Opportunity> oppList = new List<Opportunity>();
    
    
    
    for(Account a: [SELECT id,name FROM Account
                   WHERE id IN :Trigger.New AND
                    Id NOT IN (SELECT AccountId FROM Opportunity)]){
                        
                        oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
                                                   StageName='prospecting',
                                                   CloseDate=System.today().addMonths(1),
                                                   AccountId=a.Id));
                        
                        
                    }
    if(oppList.size() > 0){
        insert oppList;
    }

}