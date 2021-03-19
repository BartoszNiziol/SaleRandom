
    HttpResponse res = loginCallout();
    Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
            res.getBody()
    );
    String accesToken = (String) params.get('access_token');
    String authorization = 'Bearer ' + accesToken;
    Cache.Session.put('authorization', authorization);
    System.debug(res);


public HttpResponse loginCallout(){
    HttpRequest req = new HttpRequest();
    req.setEndpoint(HD_Utils.retrieveCredentials('LoginEndpoint'));

    req.setMethod('POST');
    String username = HD_Utils.retrieveCredentials('DBLogin');
    System.debug('username');
    System.debug(username);
    String password = HD_Utils.retrieveCredentials('DBPassword');
    System.debug(password);
    System.debug('password');
    String grantType = 'password';
    String clientId = HD_Utils.retrieveCredentials('clientID');
    String clientSecret = HD_Utils.retrieveCredentials('clientSecret');
    req.setBody(
            'grant_type=password' +
                    '&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password
    );
    Http http = new Http();
    HttpResponse res = http.send(req);
    System.debug(req.getBody());
    return res;
}