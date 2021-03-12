/**
 * Created by BRITENET on 12.03.2021.
 */

global class DB_DoctorCountriesResponseWrapper {

    webService List<String> countries;
    webService String message;
    webService Boolean isSuccess;

    public DB_DoctorCountriesResponseWrapper(List<String> countries){
        this.countries = countries;
        isSuccess = true;
        message = 'Success';
    }

    public DB_DoctorCountriesResponseWrapper(){


    }

}