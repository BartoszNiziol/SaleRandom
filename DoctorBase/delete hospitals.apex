Hospital__c hospital = new Hospital__c();
hospital.Id ='';
Hospital__c hospital2 = new Hospital__c();
hospital2.Id = '';

List <Hospital__c> hospitals = new List<Hospital__c>();
hospitals.add(hospital);
hospitals.add(hospital2);

delete  hospitals;