/**
 * Created by BRITENET on 21.03.2021.
 */
@RestResource(urlMapping = '/HospitalIntegration')
global class HD_HospitalIntegrationWebService {


    @HttpPatch
    global static void patchExternalId(){
        RestContext.request.requestBody.toString();
    }

}