
Doctor__c doctor2 = [SELECT Id FROM Doctor__c WHERE Name ='Kowalski2'];
doctor2.First_Name__c ='Edited';
Doctor__c doctor3 = [SELECT Id FROM Doctor__c WHERE Name ='Kowalski3'];
update  doctor2;
delete doctor3;