/**
 * Created by BRITENET on 31.03.2021.
 */
@IsTest
global class ProjectCalloutServiceMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatus('OK');
        response.setStatusCode(201);

        return response;
    }

}