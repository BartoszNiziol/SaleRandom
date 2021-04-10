/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_SearchController {
    @auraenabled
    public static MP_WholeResultWrapper findMovies(String search,Integer currentPage){

        search.replace(' ','+');
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endpoint = MP_Utils.retrieveCredentials('MovieSearchEndpoint');
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US&query='+search;
        endpoint += '&page='+currentPage;
        endpoint += '&include_adult=false';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> resultList = (List<Object>) responseMap.get('results');
        MP_WholeResultWrapper wholeResultWrapper = new MP_WholeResultWrapper();
        List<MP_SingleResultWrapper> wrappers = new List<MP_SingleResultWrapper>();

        for (Object obj : resultList) {
            Map<String, Object> params = (Map<string, Object>) obj;
            String overviev;
            String backdropPath;
            Decimal rating;
            String releaseYear;

            Boolean isAdult = (Boolean) params.get('adult');
            String apiId = String.valueOf(params.get('id'));
            String title = (String) params.get('title');
            if(params.get('overview') != null){
                overviev = (String) params.get('overview');
            }else{
                overviev = '';
            }
            if(params.get ('backdrop_path') != null){
                backdropPath =(String) params.get ('backdrop_path');
            }else {
                backdropPath = '';
            }
            if(params.get('vote_average')!= null){
                rating = (Decimal) params.get('vote_average');
            }else {
                rating = 0;
            }
            if(params.get('release_date') != null){
                String relaseDate = (String) params.get('release_date');
                releaseYear  = relaseDate.split('-').get(0);
            }
            else {
                releaseYear = '';
            }
            MP_SingleResultWrapper wrapper = new MP_SingleResultWrapper(isAdult,apiId,overviev,backdropPath,releaseYear,title,rating,'movie',null,null);
            wrappers.add(wrapper);
        }
        wholeResultWrapper.wrappedSingles = wrappers;
        wholeResultWrapper.page =(Integer) responseMap.get('page');
        wholeResultWrapper.totalPages = (Integer) responseMap.get('total_pages');
        wholeResultWrapper.totalResults = (Integer) responseMap.get('total_results');
        return wholeResultWrapper;
    }

    @auraenabled
    public static MP_WholeResultWrapper findPeoples(String search,Integer currentPage){

        search.replace(' ','+');
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String endpoint = MP_Utils.retrieveCredentials('PersonSearchEndpoint');
        endpoint +='?api_key=' +MP_Utils.retrieveCredentials('ApiKey');
        endpoint += '&language=en-US&query='+search;
        endpoint += '&page='+currentPage;
        endpoint += '&include_adult=false';
        System.debug(endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Map<String,Object> responseMap  = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> resultList = (List<Object>) responseMap.get('results');
        MP_WholeResultWrapper wholeResultWrapper = new MP_WholeResultWrapper();
        List<MP_SingleResultWrapper> wrappers = new List<MP_SingleResultWrapper>();

        for (Object obj : resultList) {
            Map<String, Object> params = (Map<string, Object>) obj;
            String backdropPath;
            Integer gender;
            String department;
            String releaseYear;
            Boolean isAdult = (Boolean) params.get('adult');
            String apiId = String.valueOf(params.get('id'));
            String name = (String) params.get('name');



            if(params.get ('profile_path') != null){
                backdropPath =(String) params.get ('profile_path');
            }else {
                backdropPath = '';
            }
            if(params.get('gender') != null){
                gender  = (Integer) params.get('gender');
            }else{
                gender = 1;
            }
            if (params.get('known_for_department') != null){
                department =(String) params.get('known_for_department');
            }else{
                department = '';
            }
            if(params.get('release_date') != null){
                String relaseDate = (String) params.get('release_date');
                releaseYear  = relaseDate.split('-').get(0);
            }
            else {
                releaseYear = '';
            }

            MP_SingleResultWrapper wrapper = new MP_SingleResultWrapper(isAdult,apiId,null,backdropPath,releaseYear,name,null,'person',gender,department);
            wrappers.add(wrapper);

        }
        wholeResultWrapper.wrappedSingles = wrappers;
        wholeResultWrapper.page =(Integer) responseMap.get('page');
        wholeResultWrapper.totalPages = (Integer) responseMap.get('total_pages');
        wholeResultWrapper.totalResults = (Integer) responseMap.get('total_results');

        return wholeResultWrapper;
    }

}