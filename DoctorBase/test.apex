
Doctor__c doctor = new Doctor__c();
doctor.First_Name__c = 'Jan';
doctor.Name = 'Kowalski';
doctor.Email__c = 'jk@op.po';
doctor.City__c = 'Lublin';
doctor.Street__c = 'wolna 3';
doctor.Birthday_Date__c = Date.Today();
doctor.License_Number__c = 1234567;
insert doctor;

Doctor__c doctor2 = new Doctor__c();
doctor2.First_Name__c = 'Jan2';
doctor2.Name = 'Kowalski2';
doctor2.Email__c = 'jk@op2.po';
doctor2.City__c = 'Lublin2';
doctor2.Street__c = 'wolna 4';
doctor2.Birthday_Date__c = Date.Today();
doctor2.License_Number__c = 12345678;
insert  doctor2;

Doctor__c doctor3 = new Doctor__c();
doctor3.First_Name__c = 'Jan3';
doctor3.Name = 'Kowalski3';
doctor3.Email__c = 'jk@op3.po';
doctor3.City__c = 'Lublin3';
doctor3.Street__c = 'wolna 5';
doctor3.Birthday_Date__c = Date.Today();
doctor3.License_Number__c = 12300678;
insert  doctor3;