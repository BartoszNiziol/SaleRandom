/**
 * Created by BRITENET on 31.03.2021.
 */

global class BillingCalloutServiceMock implements WebServiceMock{
    global void doInvoke(
            Object stub,
            Object request,
            Map<String,Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){

        BillingServiceProxy.billProjectResponse_element response_element = new BillingServiceProxy.billProjectResponse_element();
        response_element.status = 'OK';
        response.put('response_x',response_element);
    }

}