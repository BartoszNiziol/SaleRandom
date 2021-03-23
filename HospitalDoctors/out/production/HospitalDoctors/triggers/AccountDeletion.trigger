trigger AccountDeletion on Account (before delete) {
    
    
    for(Account a : [Select id from Account
                     where id in (select AccountId from Opportunity) and id in :Trigger.old]){
                         
                         Trigger.oldMap.get(a.id).addError('Cannot deleta account with related opportunitiees');
                     }

}