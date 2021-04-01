/**
 * Created by BRITENET on 31.03.2021.
 */

public with sharing class ProjectCalloutServiceMockFailure implements HttpCalloutMock{

    public HttpResponse respond (HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatus('Failure');
        response.setStatusCode(500);

        return response;
    }

}