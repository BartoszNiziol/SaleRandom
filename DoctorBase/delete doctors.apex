Doctor__c doctor = new Doctor__c();
doctor.Id ='';
Doctor__c doctor2 = new Doctor__c();
doctor2.Id = '';

List <Doctor__c> doctors = new List<Doctor__c>();
doctors.add(doctor);
doctors.add(doctor2);

delete  doctors;