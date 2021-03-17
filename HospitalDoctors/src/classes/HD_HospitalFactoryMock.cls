/**
 * Created by BRITENET on 17.03.2021.
 */


    public with sharing class HD_HospitalFactoryMock implements  HttpCalloutMock {
        Map<String,HttpCalloutMock> requests;

        public HD_HospitalFactoryMock (Map<String,HttpCalloutMock> requests){
            this.requests = requests;
        }

        public HttpResponse respond(HttpRequest request){
            HttpCalloutMock mock = requests.get(request.getEndpoint());
            if (mock != null) {
                return mock.respond(request);
            } else {
                throw new HD_DateException('HTTP callout not supported for test methods');
            }
        }

        public void addRequestMock(String url, HttpCalloutMock mock){
            requests.put(url,mock);
        }

    }

