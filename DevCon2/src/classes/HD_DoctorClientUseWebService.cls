/**
 * Created by BRITENET on 04.03.2021.
 */

global class HD_DoctorClientUseWebService  {

    webService static Id getDoctor(String firstName, String lastName, String email, String country) {
        List<Doctor__c> requestedDoctor = [
                SELECT Id
                FROM Doctor__c
                WHERE First_Name__c = :firstName AND Name = :lastName AND Email__c = :email AND Country__c = :country
        ];
        if (requestedDoctor.size() > 0) {
            return requestedDoctor[0].Id;
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

    webService static Id updateDoctor(Id id, String firstName, String lastName, String email, String country){
        List<Doctor__c> requestedDoctor = [
                SELECT Id
                FROM Doctor__c
                WHERE Id =:id
        ];
        Doctor__c doctorToUpdate = requestedDoctor[0];
        update doctorToUpdate ;
        return doctorToUpdate.Id;
    }

    webService static void deleteDoctor(Id id){
        List<Doctor__c> requestedDoctor = [
                SELECT Id
                FROM Doctor__c
                WHERE Id =:id
        ];
        Doctor__c doctorToDelete = requestedDoctor[0];
        delete doctorToDelete;
    }



}