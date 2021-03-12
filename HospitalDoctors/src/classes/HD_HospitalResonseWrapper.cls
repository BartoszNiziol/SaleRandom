/**
 * Created by BRITENET on 12.03.2021.
 */

 global class HD_HospitalResonseWrapper {

    webService String id;
     webService String hospitalName;
     webService String email;
     webService String country;
     webService String city;
     webService String message;
     webService Boolean isSuccess;

       public HD_HospitalResonseWrapper (Hospital__c hospital){
           this.id = hospital.Id;
           this.hospitalName = hospitalName;
           this.email = email;
           this.country = country;
           this.city = city;
           this.message = 'Succes';
           this.isSuccess = true;
       }

       public HD_HospitalResonseWrapper(){
       }


}