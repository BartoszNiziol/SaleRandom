/**
 * Created by BRITENET on 07.04.2021.
 */

public with sharing class MP_SearchController {
    @auraenabled
    public static MP_WholeResultWrapper findMovies(String search,Integer currentPage){

      search =  search.replace(' ','+');
       // search = EncodingUtil.urlEncode(search, 'UTF-8');
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
                backdropPath =(String) params.get ('poster_path');
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
            System.debug(currentPage);
            System.debug((Integer) responseMap.get('total_pages'));

        if(currentPage  == (Integer) responseMap.get('total_pages') || (Integer) responseMap.get('total_pages') == 0 ){
            System.debug('INIT');
            search =  search.replace('+',' ');
            List<MP_SingleResultWrapper> moviesFromDB = searchMovieInDb(search);
            for (MP_SingleResultWrapper movie:moviesFromDB){
                wrappers.add(movie);
            }

        }


        wholeResultWrapper.wrappedSingles = wrappers;
        wholeResultWrapper.page =(Integer) responseMap.get('page');
        wholeResultWrapper.totalPages = (Integer) responseMap.get('total_pages');
        wholeResultWrapper.totalResults = (Integer) responseMap.get('total_results');
        return wholeResultWrapper;
    }

    @auraenabled
    public static  MP_WholeResultWrapper findPeoples(String search,Integer currentPage){

        search = search.replace(' ','+');
        System.debug(search);
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

        if(currentPage ==(Integer) responseMap.get('total_pages') || (Integer) responseMap.get('total_pages') == 0){
            search =  search.replace('+',' ');
            List<MP_SingleResultWrapper> peoplesFromDb = searchPersonInDb(search);
            for(MP_SingleResultWrapper person:peoplesFromDb){
                wrappers.add(person);
            }
                    }


        wholeResultWrapper.wrappedSingles = wrappers;
        wholeResultWrapper.page =(Integer) responseMap.get('page');
        wholeResultWrapper.totalPages = (Integer) responseMap.get('total_pages');
        wholeResultWrapper.totalResults = (Integer) responseMap.get('total_results');

        return wholeResultWrapper;
    }

    private static List<MP_SingleResultWrapper> searchMovieInDb(String searchString) {

        String approved = 'Approved';
        List<MP_SingleResultWrapper> wrappers = new List<MP_SingleResultWrapper>() ;
        String likeQuery = '%' + searchString + '%';
        String stringQuery = 'SELECT Id,ApiId__c,PosterPath__c,RelaseDate__c,Name,Rating__c,Overviev__c FROM Movie__c WHERE Name LIKE \'' + likeQuery+'\''+ 'AND Status__c = \'' + approved + '\'';

        List<Movie__c> insideMovies = Database.query(stringQuery);


        for (Movie__c movie : insideMovies) {

            MP_SingleResultWrapper wrapper = new MP_SingleResultWrapper(false, movie.Id, movie.Overviev__c, movie.PosterPath__c, String.valueOf(movie.RelaseDate__c), movie.Name, movie.Rating__c, 'movie', null, null);
            wrapper.inside = true;
            wrappers.add(wrapper);
            System.debug(wrapper);
        }
        return wrappers;
    }
    private static List<MP_SingleResultWrapper> searchPersonInDb(String searchString) {

        String approved = 'Approve';
        List<MP_SingleResultWrapper> wrappers = new List<MP_SingleResultWrapper>() ;
        String likeQuery = '%' + searchString + '%';
        System.debug('likeQuery');
        System.debug(likeQuery);
        String stringQuery = 'SELECT Id,ApiId__c,KnownForRole__c,Name,Biography__c FROM Person__c WHERE Name LIKE \'' + likeQuery+'\''+ 'AND Status__c = \'' + approved + '\'';

        List<Person__c> insidePersons = Database.query(stringQuery);


        for (Person__c person : insidePersons) {

            MP_SingleResultWrapper wrapper = new MP_SingleResultWrapper(false, person.Id, null,null, null, person.Name,null, 'movie', null, person.KnownForRole__c);
            wrapper.inside = true;
            wrappers.add(wrapper);
            System.debug(wrapper);
        }
        return wrappers;
    }

}