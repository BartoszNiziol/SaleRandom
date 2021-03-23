List<Doctor__c> doctors = new List<Doctor__c>();

Doctor__c doctor = new Doctor__c();
doctor.First_Name__c = 'Janxxxxxxxxxx';
doctor.Name = 'Kowalski';
doctor.Email__c = 'jk@op.po';
doctor.City__c = 'Lublin';
doctor.Street__c = 'wolna 3';
doctor.Birthday_Date__c = Date.Today();
doctor.License_Number__c = 1234567;
doctor.Id ='';

Doctor__c doctor2 = new Doctor__c();
doctor2.First_Name__c = 'Jan2xxxxxxxxxxxx';
doctor2.Name = 'Kowalski2';
doctor2.Email__c = 'jk@op2.po';
doctor2.City__c = 'Lublin2';
doctor2.Street__c = 'wolna 4';
doctor2.Birthday_Date__c = Date.Today();
doctor2.License_Number__c = 12345678;
doctor2.Id ='';

doctors.add(doctor);
doctors.add(doctor2);

insert  doctors;

System.debug(doctor.Id);
System.debug(doctor2.Id);