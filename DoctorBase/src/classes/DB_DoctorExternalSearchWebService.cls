global class DB_DoctorExternalSearchWebService {

    webService static List<DB_DoctorResponseWrapper> getDoctors(String firstName, String lastName, String email, String country) {
        List<DB_DoctorResponseWrapper> wrappers = new List<DB_DoctorResponseWrapper>();
        try {
            List<Doctor__c> foundDoctors = DB_DoctorHandler.queryDoctorsORStartsWith(firstName, lastName, email, country);
            for (Doctor__c doctor : foundDoctors) {
                wrappers.add(new DB_DoctorResponseWrapper(doctor));
            }
            return wrappers;
        } catch (Exception e) {
            DB_DoctorResponseWrapper errorWrapper = new DB_DoctorResponseWrapper();
            wrappers.clear();
            errorWrapper.isSuccess = false;
            errorWrapper.message = e.getMessage();
            wrappers.add(errorWrapper);
            return wrappers;
        }
    }

    webService static DB_DoctorResponseWrapper upsertDoctor(String id, String firstName, String lastName, String email, String country){
        try {
            Doctor__c doctor = new Doctor__c();
            doctor.First_Name__c = firstName;
            doctor.Name = lastName;
            doctor.Email__c = email;
            doctor.Country__c = country;
            if(id != null){
                doctor.Id = id;
            }
            upsert doctor;
            DB_DoctorResponseWrapper responseStatus = new DB_DoctorResponseWrapper(doctor);
            return responseStatus;
        } catch (Exception e) {
            return applyErrorStatus(e);
        }
    }

    webService static DB_DoctorResponseWrapper deleteDoctor(String id) {
        try {
            Doctor__c doctorToDelete = new Doctor__c();
            doctorToDelete.Id = id;
            DB_DoctorResponseWrapper responseStatus = new DB_DoctorResponseWrapper(doctorToDelete);
            delete doctorToDelete;
            return responseStatus;
        } catch (Exception e) {
            return applyErrorStatus(e);
        }
    }

    private static DB_DoctorResponseWrapper applyErrorStatus(Exception e) {
        DB_DoctorResponseWrapper responseStatus = new DB_DoctorResponseWrapper();
        responseStatus.isSuccess = false;
        responseStatus.message = e.getMessage();
        return responseStatus;
    }

}