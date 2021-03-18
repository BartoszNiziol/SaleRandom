/**
 * Created by BRITENET on 17.03.2021.
 */

public with sharing class HD_SingleMock implements HttpCalloutMock {
    public Integer code;
    public String status;
    public String bodyAsString;
    public Map<String, String> responseHeaders;

    public HD_SingleMock(Integer code, String status, String body, Map<String,String> responseHeaders){
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(code);
        response.setBody(bodyAsString);
        response.setStatus(status);
        if (responseHeaders != null) {
            for (String key: responseHeaders.keySet()){
                response.setHeader(key,responseHeaders.get(key));
            }
        }
        return response;
    }

}