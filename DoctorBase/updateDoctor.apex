List<Doctor__c> doctors = new List<Doctor__c>();

Doctor__c doctor = new Doctor__c();
doctor.First_Name__c = 'Janxxxxxxxxxx';
doctor.Id ='';

Doctor__c doctor2 = new Doctor__c();
doctor2.First_Name__c = 'Jan2xxxxxxxxxxxx';
doctor2.Id ='';

doctors.add(doctor);
doctors.add(doctor2);

update  doctors;