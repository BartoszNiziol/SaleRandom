Hospital__c hospital2 = [SELECT Id FROM Hospital__c WHERE Name ='hospital2'];
hospital2.City__c = 'Edited';
Hospital__c hospital3 = [SELECT Id FROM Hospital__c WHERE Name ='hospital3'];

update hospital2;
delete hospital3;