/**
 * Created by BRITENET on 04.03.2021.
 */

global class HD_DoctorClientUseWebService {

    webService static List<DoctorResponseWrapper> getDoctors(String firstName, String lastName, String email, String country) {
        List<DoctorResponseWrapper> wrappers = new List<DoctorResponseWrapper>();
        try {
            List<Doctor__c> foundDoctors = HD_DoctorHandler.queryDoctorsORStartsWith(firstName, lastName, email, country);
            for (Doctor__c doctor : foundDoctors) {
                wrappers.add(new DoctorResponseWrapper(doctor));
            }
            return wrappers;
        } catch (Exception e) {
            DoctorResponseWrapper errorWrapper = new DoctorResponseWrapper();
            wrappers.clear();
            errorWrapper.isSuccess = false;
            errorWrapper.message = e.getMessage();
            wrappers.add(errorWrapper);
            return wrappers;
        }
    }

    webService static HD_DoctorResponseStatus addDoctor(String firstName, String lastName, String email, String country) {
        try {
            Doctor__c doctorToAdd = new Doctor__c();
            doctorToAdd.First_Name__c = firstName;
            doctorToAdd.Name = lastName;
            doctorToAdd.Email__c = email;
            doctorToAdd.Country__c = country;
            insert doctorToAdd;
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus(doctorToAdd);
            responseStatus.isSuccess = true;
            return responseStatus;
        } catch (Exception e) {
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus();
            responseStatus.message = e.getMessage();
            responseStatus.isSuccess = false;
            return responseStatus;
        }
    }

    webService static HD_DoctorResponseStatus updateDoctor(String id, String firstName, String lastName, String email, String country) {
        try {
            Doctor__c doctor = new Doctor__c();
            doctor.First_Name__c = firstName;
            doctor.Name = lastName;
            doctor.Email__c = email;
            doctor.Country__c = country;
            doctor.Id = id;
            update doctor;
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus(doctor);
            responseStatus.isSuccess = true;
            return responseStatus;
        } catch (Exception e) {
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus();
            responseStatus.isSuccess = false;
            responseStatus.message = e.getMessage();
            return responseStatus;
        }
    }

    webService static HD_DoctorResponseStatus deleteDoctor(String id) {
        try {
            Doctor__c doctorToDelete = new Doctor__c();
            doctorToDelete.Id = id;
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus(doctorToDelete);
            responseStatus.isSuccess = true;
            delete doctorToDelete;
            return responseStatus;
        } catch (Exception e) {
            HD_DoctorResponseStatus responseStatus = new HD_DoctorResponseStatus();
            responseStatus.isSuccess = false;
            responseStatus.message = e.getMessage();
            return responseStatus;
        }
    }


}