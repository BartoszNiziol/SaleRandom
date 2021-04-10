/**
 * Created by BRITENET on 09.04.2021.
 */

public with sharing class MP_MovieDetailsController {
    @AuraEnabled
    public static MP_MovieResultWrapper findMovieDetails (String externalId){

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endpoint = MP_Utils.retrieveCredentials('GetMovieEndpoint');
        endpoint += '/' + externalId;
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());

        Boolean isAdult = (Boolean) responseMap.get('adult');
        String overview = (String) responseMap.get('overview');
        String release_date = (String) responseMap.get('release_date');
        String Id = String.valueOf( responseMap.get('id'));
        String department = (String) responseMap.get('known_for_department');
        String backdrop_path = (String) responseMap.get('poster_path');
        String title = (String) responseMap.get('title');
        Decimal rating = (Decimal) responseMap.get('vote_average');


        MP_MovieResultWrapper movieWrapper = new MP_MovieResultWrapper(isAdult,id,overview,backdrop_path,release_date,title,rating);

        System.debug(responseMap);

        return movieWrapper;
    }
}