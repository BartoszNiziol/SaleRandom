/**
 * Created by BRITENET on 16.03.2021.
 */
@IsTest
global class HD_HospitalSingleRequestMock implements HttpCalloutMock {

   public HttpResponse respond(HttpRequest request) {
       HttpResponse response = new HttpResponse();
       System.debug('RequestBody');
       System.debug(request.getBody());

       if ( request.getMethod() == 'GET' ) {
           response.setStatusCode(200);
           response.setStatus('success');
           response.setBody('[{"message":"Succes","isSuccess":true,"id":"a0409000001jNLOAA2","hospitalName":"St Monica","email":"jakies@wp.pl","country":"USA","city":"Kanzas"}' +
                   ',{"message":"Succes","isSuccess":true,"id":"a0409000001jMkCAAU","hospitalName":"St Maria","email":"stmari@com.op","country":"USA","city":"Kanzas"}]');
          response.setHeader('Content-Type','application/json');
           return response;

       } else if(request.getMethod() == 'POST' && request.getEndpoint().contains('token')) {
           response.setHeader('Content-Type', 'application/json');
           response.setBody('{ "access_token" : "00D5J000000Gh79!ARUAQG.i9os6CoXRz4Oa7Q.KyCGPsFXvaNb7F6M4HIMShkDrzAuAXV3BgYkLAALtNykrGTTEa3iPFsXSCCiHQi9BrxUhOEuP",' +
                   '"instance_url":"https://britenet62-dev-ed.my.salesforce.com","id":"https://login.salesforce.com/id/00D09000006y2iiEAA/00509000001F3iHAAS"' +
                   ',"token_type":"Bearer","issued_at":"1615965407230","signature":"FAudEjKzBjXTiP/rdJa7p97K2XahCDgyVrnsg3Kjd10="}');
           response.setStatusCode(200);
           return response;

       }else if(request.getMethod() == 'POST' && request.getEndpoint().endsWith('Hospital')) {
           response.setHeader('Content-Type', 'application/json');
           response.setHeader('Authorization', 'authorization');
           response.setBody('{"isSuccess" : true , "message" : "Success" }');
           response.setStatusCode(200);
           return response;

       } else if(request.getMethod() == 'DELETE') {
           response.setHeader('Content-Type', 'application/json');
           response.setHeader('Authorization', 'authorization');
           response.setBody('{"isSuccess" : true , "message" : "Success" }');
           response.setStatusCode(200);
           return response;

       } else if(request.getMethod() == 'GET' && request.getEndpoint().endsWith('Countries')) {
           response.setHeader('Content-Type', 'application/json');
           response.setHeader('Authorization', 'authorization');
           response.setBody('{"status":true,"message":null,"countries":["NL","PL","UA","UK","USA","DE","FR"]}');
           response.setStatusCode(200);
           return response;
       }
         return  null;



    }
}