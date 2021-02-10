trigger DmlTriggerNotBulk on Account (after update) {
	List<Opportunity> relatedOpps = [SELECT Id,Name, Probability FROM Opportunity
                                     WHERE AccountID IN : Trigger.New];
    
    for(Opportunity opp : relatedOpps) {
        
        if((opp.Probability>= 50)&& (opp.Probability<100)){
            opp.Description = 'New description for opportunity.';
            update opp;
        }
    }
}