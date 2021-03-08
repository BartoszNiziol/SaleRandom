/**
 * Created by BRITENET on 04.03.2021.
 */

global class HD_DoctorClientUseWebService {

    webService static String sayHello() {
        return 'I is working';
    }

    webService static DoctorResponseWrapper getDoctor(String firstName, String lastName, String email, String country) {
        List<Doctor__c> requestedDoctor = [
                SELECT Id, First_Name__c, Name, Email__c, Country__c
                FROM Doctor__c
                WHERE First_Name__c = :firstName AND Name = :lastName AND Email__c = :email AND Country__c = :country
        ];
        if (requestedDoctor.size() > 0) {
            return new DoctorResponseWrapper(requestedDoctor[0]);
        }
        return null;
    }

    webService static List<DoctorResponseWrapper> getDoctors() {
        List<Doctor__c> requestedDoctors = [
                SELECT Id, First_Name__c, Name, Email__c, Country__c
                FROM Doctor__c
        ];
        List<DoctorResponseWrapper> wrappers = new List<DoctorResponseWrapper>();
        for (Doctor__c doctor : requestedDoctors) {
            wrappers.add(new DoctorResponseWrapper(doctor));
        }
        if (requestedDoctors.size() > 0) {
            return wrappers;
        }
        return null;
    }

    webService static Id addDoctor(String firstName, String lastName, String email, String country) {
        Doctor__c doctorToAdd = new Doctor__c();
        doctorToAdd.First_Name__c = firstName;
        doctorToAdd.Name = lastName;
        doctorToAdd.Email__c = email;
        doctorToAdd.Country__c = country;
        insert doctorToAdd;
        return doctorToAdd.Id;
    }

    webService static Id updateDoctor(Id id, String firstName, String lastName, String email, String country) {
        List<Doctor__c> requestedDoctor = [
                SELECT Id
                FROM Doctor__c
                WHERE Id = :id
        ];
        if (requestedDoctor.size() > 0) {
            requestedDoctor[0].First_Name__c = firstName;
            requestedDoctor[0].Name = lastName;
            requestedDoctor[0].Email__c = email;
            requestedDoctor[0].Country__c = country;
            Doctor__c doctorToUpdate = requestedDoctor[0];
            update doctorToUpdate ;
            return doctorToUpdate.Id;
        }
        return null;
    }

    webService static void deleteDoctor(Id id) {
        List<Doctor__c> requestedDoctor = [
                SELECT Id
                FROM Doctor__c
                WHERE Id = :id
        ];
        Doctor__c doctorToDelete = requestedDoctor[0];
        delete doctorToDelete;
    }


}