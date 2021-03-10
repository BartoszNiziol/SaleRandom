/**
 * Created by BRITENET on 08.03.2021.
 */

    global class HD_DoctorResponseStatus {
        webService String id;
        webService String message;
        webService Boolean isSuccess;

        public HD_DoctorResponseStatus(Doctor__c doctor){
            this.id = doctor.Id;
            message = 'Success';
            isSuccess = true;
        }

        public HD_DoctorResponseStatus(){

        }



}