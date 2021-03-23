List<Hospital__c> hospitals = new List<Hospital__c>();

Hospital__c hospital = new Hospital__c();
hospital.First_Name__c = 'Janxxxxxxxxxx';
hospital.Id ='';

Hospital__c hospital2 = new Hospital__c();
hospital2.First_Name__c = 'Jan2xxxxxxxxxxxx';
hospital2.Id ='';

doctors.add(hospital);
doctors.add(hospital2);

update  hospitals;