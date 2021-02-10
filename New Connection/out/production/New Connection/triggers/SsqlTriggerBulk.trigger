trigger SsqlTriggerBulk on Account (after update) {

    List<Account> acctsWithOpps = 
        [Select Id, (SELECT Id, Name,CloseDate FROM Opportunities)
        FROM Account WHERE ID IN :Trigger.New];
    
    for (Account a : acctsWithOpps){
        Opportunity[] relatedOpps =a.Opportunities;
    }
    
}