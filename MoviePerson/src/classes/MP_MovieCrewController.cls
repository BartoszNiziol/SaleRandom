/**
 * Created by BRITENET on 09.04.2021.
 */

public with sharing class MP_MovieCrewController {

    @AuraEnabled
    public static List<MP_ProfileWrapper> findCrew (String externalId){

        if(externalId == null){
            return null;
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = MP_Utils.retrieveCredentials('GetMovieEndpoint');
        endpoint += '/' + externalId+'/credits';
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        List <MP_ProfileWrapper> crew = new List<MP_ProfileWrapper>();

        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> resultList = (List<Object>) responseMap.get('cast');

        for (Object obj : resultList) {
            Map<String, Object> params = (Map<string, Object>) obj;

            Boolean isAdult = (Boolean) params.get('adutl');
            String bio = (String) params.get('biography');
            String Id = String.valueOf( params.get('id'));
            String profile_path = (String) params.get('profile_path');
            String name = (String) params.get('name');
            String known_for_department = (String) params.get('known_for_department');
            Decimal rating = (Decimal) params.get('vote_average');
            String role = (String) params.get('character');

            MP_ProfileWrapper profileWrapper = new MP_ProfileWrapper(Id,isAdult,name,bio,null,null,known_for_department,null,profile_path,role);
            crew.add(profileWrapper);

        }

        System.debug(crew);

        return crew;
    }

}