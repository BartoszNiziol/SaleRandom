List<Doctor__c> doctors = new List<Doctor__c>();

Doctor__c doctor = new Doctor__c();
doctor.First_Name__c = 'Jan';
doctor.Name = 'Kowalski';
doctor.Email__c = 'jk@op.po';
doctor.City__c = 'Lublin';
doctor.Street__c = 'wolna 3';
doctor.Birthday_Date__c = Date.Today();
doctor.License_Number__c = 1234567;

Doctor__c doctor2 = new Doctor__c();
doctor.First_Name__c = 'Jan2';
doctor.Name = 'Kowalski2';
doctor.Email__c = 'jk@op2.po';
doctor.City__c = 'Lublin2';
doctor.Street__c = 'wolna 4';
doctor.Birthday_Date__c = Date.Today();
doctor.License_Number__c = 12345678;

doctors.add(doctor);
doctors.add(doctor2);

insert  doctors;