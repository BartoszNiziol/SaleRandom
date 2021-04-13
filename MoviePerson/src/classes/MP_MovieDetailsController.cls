/**
 * Created by BRITENET on 09.04.2021.
 */

public with sharing class MP_MovieDetailsController {
    @AuraEnabled
    public static MP_MovieResultWrapper findMovieDetails(String externalId) {
        Boolean inside = true ;

        try {
            Id id = Id.valueOf(externalId);
            System.debug(Id.getSobjectType());
        } catch (Exception e) {
            System.debug(e);
            inside = false;
        }
        System.debug(inside);
        if (!inside) {

            Http http = new Http();
            HttpRequest request = new HttpRequest();

            String endpoint = MP_Utils.retrieveCredentials('GetMovieEndpoint');
            endpoint += '/' + externalId;
            endpoint += '?api_key=' + MP_Utils.retrieveCredentials('ApiKey');
            endpoint += '&language=en-US';
            System.debug(endpoint);
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            Boolean isAdult = (Boolean) responseMap.get('adult');
            String overview = (String) responseMap.get('overview');
            String release_date = (String) responseMap.get('release_date');
            String Id = String.valueOf(responseMap.get('id'));
            String department = (String) responseMap.get('known_for_department');
            String backdrop_path = (String) responseMap.get('poster_path');
            String title = (String) responseMap.get('title');
            Decimal rating = (Decimal) responseMap.get('vote_average');

            String yId = getYLink(externalId);
            MP_MovieResultWrapper movieWrapper = new MP_MovieResultWrapper(isAdult, id, overview, backdrop_path, release_date, title, rating, yId);

            return movieWrapper;
        } else {
            Movie__c movie = [SELECT Id,Overviev__c,PosterPath__c,RelaseDate__c,Name,Rating__c FROM Movie__c WHERE Id = :externalId];
            MP_MovieResultWrapper wrapper = new MP_MovieResultWrapper(false, movie.Id, movie.Overviev__c, movie.PosterPath__c, String.valueOf(movie.RelaseDate__c), movie.Name, movie.Rating__c);
            return wrapper;

        }
    }

    private static String getYLink(String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endpoint = 'https://api.themoviedb.org/3/movie';
        endpoint += '/' + id + '/videos';
        endpoint += '?api_key=' + MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> resultList = (List<Object>) responseMap.get('results');
        if (!resultList.isEmpty()) {

            Map<String, Object> param = (Map<string, Object>) resultList.get(0);
            System.debug('param');
            System.debug(param);
            String videoId = (String) param.get('key');
            return videoId;
        } else {
            return null;
        }
    }
}