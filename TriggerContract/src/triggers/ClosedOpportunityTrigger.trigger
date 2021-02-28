trigger ClosedOpportunityTrigger on Opportunity (after Insert, after Update) {


    List<Task> ListTask = new List<Task>();


    for(Opportunity opp : Trigger.New ){
        if(opp.StageName == 'Closed Won'){
            Task a = new Task();
            a.subject = 'Follow Up Test Task';
            a.whatId = opp.Id;
            ListTask.add(a);
        }
    }

    if(ListTask.size()>0)
    {
        insert(ListTask);
    }
}