List<Doctor__c> doctors = new List<Doctor__c>();

Doctor__c doctor = new Doctor__c();
doctor.First_Name__c = 'Jan';
doctor.Name = 'Kowalski';
doctor.Email__c = 'jk@op.po';
doctor.City__c = 'Lublin';
doctor.Street__c = 'wolna 3';
doctor.Birthday_Date__c = Date.Today();
doctor.License_Number__c = 1234567;
insert doctor;

doctor.First_Name__c = 'innnnne';
upsert  doctor;
doctor.First_Name__c = 'calkiem';
upsert  doctor;
doctor.First_Name__c = 'last';
upsert  doctor;

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
doctor3.First_Name__c = 'Jan2';
doctor3.Name = 'Kowalski2';
doctor3.Email__c = 'jk@op2.po';
doctor3.City__c = 'Lublin2';
doctor3.Street__c = 'wolna 4';
doctor3.Birthday_Date__c = Date.Today();
doctor3.License_Number__c = 12345678;
insert  doctor3;
delete  doctor3;

