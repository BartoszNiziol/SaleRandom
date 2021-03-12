/**
 * Created by BRITENET on 12.03.2021.
 */

global class DB_DoctorValuesWebService {

    webService static DB_DoctorCountriesResponseWrapper getCountries(){
        try {
            String[] singleCountries = DB_Utils.retrieveAvalibleCountries().split(',');
            List<String> pickListValuesList = new List<String>();
            for (String country: singleCountries){
                pickListValuesList.add(country);
            }
            DB_DoctorCountriesResponseWrapper wrapper = new DB_DoctorCountriesResponseWrapper(pickListValuesList);
            return wrapper;
        }catch (Exception e){
            DB_DoctorCountriesResponseWrapper responseStatus = new DB_DoctorCountriesResponseWrapper();
            responseStatus.status = false;
            responseStatus.message = e.getMessage();
            return responseStatus;
        }
    }

}