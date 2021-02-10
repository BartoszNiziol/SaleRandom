trigger ClosedOpportunityTrigger on Opportunity (after Insert, after Update) {
        
    List<Opportunity> oppList = new List<Opportunity>();
    
    for (Opportunity o : [Select Id From Opportunity 
                         where Id In : Trigger.New ]){
                             
                             //Tworze triggera i jemu ustawiam id do Opportunity (Rodzica)
                             
                         }
   
    

}