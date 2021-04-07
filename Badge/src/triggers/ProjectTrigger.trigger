trigger ProjectTrigger on Project__c (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        if(!System.isFuture()){
            BillingCalloutService.callBillingService(Trigger.new, Trigger.oldMap);
        }
    }
}