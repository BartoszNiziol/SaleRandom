trigger DmlTriggerBulk on Account (before insert) {
    
    List<Opportunity> relatedOpps = [SELECT id,name,Probability 
                                     FROM Opportunity
                                     WHERE AccountId IN :Trigger.New];
    
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    
    for(Opportunity opp : relatedOpps){
        
        
        if((opp.Probability > 50) && (opp.Probability <100 )){
            opp.Description = 'New description for opportunity.';
            oppsToUpdate.add(opp);
        }
    }
    
    update oppsToUpdate;

}