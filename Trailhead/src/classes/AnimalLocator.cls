public class AnimalLocator {
    
    public String getAnimalNameById (Integer id){

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> animal = (Map<String, Object>) results.get('animal');
        String name = (String) animal.get('name');

        return name;
       
    }

}