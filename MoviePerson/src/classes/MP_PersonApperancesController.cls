/**
 * Created by BRITENET on 08.04.2021.
 */

public with sharing class MP_PersonApperancesController {
    @AuraEnabled
    public static List<MP_MovieDescriptionWrapper> findPersonAppearances (String externalId){

        System.debug('externalId');
        System.debug(externalId);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = MP_Utils.retrieveCredentials('GetPersonEndpoint');
        endpoint += '/' + externalId+'/movie_credits';
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        List <MP_MovieDescriptionWrapper> allAppearances = new List<MP_MovieDescriptionWrapper>();

        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> resultList = (List<Object>) responseMap.get('cast');
        for (Object obj : resultList) {
            Map<String, Object> params = (Map<string, Object>) obj;

            Boolean isAdult = (Boolean) params.get('adutl');
            String bio = (String) params.get('biography');
            String releaseDate = (String) params.get('release_date');
            String Id = String.valueOf( params.get('id'));
            String posterPath = (String) params.get('poster_path');
            String title = (String) params.get('title');
            Decimal rating = (Decimal) params.get('vote_average');

            MP_MovieDescriptionWrapper apperanceWrapper = new MP_MovieDescriptionWrapper(isAdult,posterPath,id,title,releaseDate,null,null,rating);
            allAppearances.add(apperanceWrapper);

        }

        System.debug(allAppearances);

        return allAppearances;
    }

}