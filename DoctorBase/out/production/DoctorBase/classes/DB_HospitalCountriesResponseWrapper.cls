/**
 * Created by BRITENET on 15.03.2021.
 */

global class DB_HospitalCountriesResponseWrapper {

    webService List<String> countries;
    webService String message;
    webService Boolean status;

    public DB_HospitalCountriesResponseWrapper(List<String> countries){
        this.countries = countries;
        status = true;
    }
    public DB_HospitalCountriesResponseWrapper(){

    }

}