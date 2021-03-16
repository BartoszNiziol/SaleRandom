/**
 * Created by BRITENET on 16.03.2021.
 */

public with sharing class HD_HospitalSingleRequestMock implements HttpCalloutMock {

    public Integer code;
    public String status;
    public String bodyAsString;
    public Map<String, String> responseHeaders;

    public HD_HospitalSingleRequestMock(Integer code,String status,String bodyAsString,Map<String,String> responseHeaders){
        this.code = code;
        this.status = status;
        this.responseHeaders = responseHeaders;
        this.bodyAsString = bodyAsString;
    }

   public HttpResponse respond(HttpRequest request) {
       HttpResponse response = new HttpResponse();
       response.setStatusCode(code);
       response.setStatus(status);
       response.setBody(bodyAsString);

       if (responseHeaders != null){
           for(String key : responseHeaders.keySet()){
               response.setHeader(key,responseHeaders.get(key));
           }
       }
        return response;
    }
}