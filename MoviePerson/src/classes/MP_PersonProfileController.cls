/**
 * Created by BRITENET on 08.04.2021.
 */

public with sharing class MP_PersonProfileController {
    @AuraEnabled
    public static MP_ProfileWrapper findPersonProfile (String externalId){

        System.debug('externalId');
        System.debug(externalId);

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endpoint = MP_Utils.retrieveCredentials('GetPersonEndpoint');
        endpoint += '/' + externalId;
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());

        Boolean isAdult = (Boolean) responseMap.get('adutl');
        String bio = (String) responseMap.get('biography');
        String birthday = (String) responseMap.get('birthday');
        String deathday = (String) responseMap.get('deathday');
        String Id = String.valueOf( responseMap.get('id'));
        String department = (String) responseMap.get('known_for_department');
        String birthPlace = (String) responseMap.get('place_of_birth');
        String profile_path = (String) responseMap.get('profile_path');
        String name = (String) responseMap.get('name');



        MP_ProfileWrapper profileWrapper = new MP_ProfileWrapper(Id,isAdult,name,bio,birthday,deathday,department,birthPlace,profile_path);

        System.debug(responseMap);


        return profileWrapper;
    }


}