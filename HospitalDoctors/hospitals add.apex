Hospital__c hospital = new Hospital__c();
hospital.Name = 'name';
hospital.Email__c = 'em@a.il';
hospital.City__c = 'city';
hospital.Street__c = 'street';

Hospital__c hospital2 = new Hospital__c();
hospital2.Name = 'name2';
hospital2.Email__c = 'em@a2.il';
hospital2.City__c = 'city2';
hospital2.Street__c = 'street2';

List<Hospital__c> hospitals = new List<Hospital__c>();


insert hospitals;