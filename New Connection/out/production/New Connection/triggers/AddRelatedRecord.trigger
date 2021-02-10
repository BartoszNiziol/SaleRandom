trigger AddRelatedRecord on Account (after insert, after update) {
        List<Opportunity> oppList = new List<Opportunity>();
    
    Map<Id,Account> acctWithOpps = new Map<Id,Account>(
      [SELECT id,(SELECT id FROM Opportunities) FROM Account WHERE Id IN :Trigger.NEW]);
    
    
    for(Account a : Trigger.New) {
        System.debug('acctsWithOpps.get(a.Id).Opportunities.size()=' + acctWithOpps.get(a.Id).Opportunities.size());
        
        if(acctWithOpps.get(a.Id).Opportunities.size() == 0){
            
            oppList.add(new Opportunity(Name=a.Name + 'Opportunity',
                                        StageName = 'prospecting',
                                       CloseDate= System.today().addMonths(1),
                                       AccountId=a.Id));
        }
    }
    if(oppList.size()> 0){
        insert oppList;
    }
}