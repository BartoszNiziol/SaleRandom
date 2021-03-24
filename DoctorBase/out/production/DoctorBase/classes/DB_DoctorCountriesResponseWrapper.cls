/**
 * Created by BRITENET on 12.03.2021.
 */

global class DB_DoctorCountriesResponseWrapper {

    webService List<String> countries;
    webService String message;
    webService Boolean status;

    public DB_DoctorCountriesResponseWrapper(List<String> countries){
        this.countries = countries;
        status = true;
    }

    public DB_DoctorCountriesResponseWrapper(){


    }

}