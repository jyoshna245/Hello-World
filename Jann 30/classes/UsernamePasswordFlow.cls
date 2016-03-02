public class UsernamePasswordFlow {
    String username;
    String password;
    String clientId;
    String clientSecret;
    String tokenEndpoint;

    public UsernamePasswordFlow(String username, String password, String clientId, String clientSecret, string tokenEndpoint) {
        this.username = username;
        this.password = password;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.tokenEndpoint = tokenEndpoint;
    }

    public String requestAccessToken() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint);
        req.setMethod('POST');
        req.setBody(buildHttpQuery(new Map<String, String> {
            'grant_type' => 'password',
            'username' => username,
            'password' => password,
            'client_id' => clientId,
            'client_secret' => clientSecret
        }));
       HttpResponse resp = new HttpResponse();
       Map<String, Object> m = new Map<String, Object>();
       if(!Test.isRunningTest()){
          Http http = new Http();
          resp = http.send(req);
          m = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
       }

       return (String) m.get('access_token');
    }

    static String buildHttpQuery(Map<String, String> queryParams) {
        String[] params = new String[] {};
        for (String k : queryParams.keySet()) {
            String v = EncodingUtil.urlEncode(queryParams.get(k), 'UTF-8');

            params.add(String.format('{0}={1}', new String[] { k, v }));
        }

        return String.join(params, '&');
    }
}