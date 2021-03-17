/**
 * Created by BRITENET on 17.03.2021.
 */
@RestResource(urlMapping = '/HospitalCountries')
global class DB_HospitalCountriesRestWebService {
    @HttpGet
    global static DB_HospitalCountriesResponseWrapper deployCountries() {
        try {
            String[] singleCountries = DB_Utils.retrieveAvalibleCountries().split(',');
            List<String> pickListValuesList = new List<String>();
            for (String country : singleCountries) {
                pickListValuesList.add(country);
            }
            DB_HospitalCountriesResponseWrapper wrapper = new DB_HospitalCountriesResponseWrapper(pickListValuesList);
            return wrapper;
        } catch (Exception e) {
            DB_HospitalCountriesResponseWrapper responseStatus = new DB_HospitalCountriesResponseWrapper();
            responseStatus.status = false;
            responseStatus.message = e.getMessage();
            return responseStatus;
        }
    }

}