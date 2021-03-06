/**
 * Created by BRITENET on 24.03.2021.
 */
@RestResource(urlMapping = '/Logger')
global class HD_LoggerWebService {

    @HttpPost
    global static void upsertLog() {

        Map <String, Object> respMap = (Map <String, Object>) JSON.deserializeUntyped(
                RestContext.request.requestBody.toString()
        );

        String addedId = HD_LoggerHandler.createLog((String) respMap.get('soType'), (String) respMap.get('endpoint'),
                (String) respMap.get('request'), (String) respMap.get('response'), (String) respMap.get('actionType'),
                (String) respMap.get('logID'), (Decimal) respMap.get('statusCode'), (String) respMap.get('status'),
                (Decimal) respMap.get('batchCounter'),(Boolean) respMap.get('isInBatch'),(String) respMap.get('externalId'));
        RestContext.response.addHeader('addedId', addedId);

    }
}