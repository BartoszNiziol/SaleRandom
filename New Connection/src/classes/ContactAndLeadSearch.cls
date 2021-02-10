public class ContactAndLeadSearch {
    
    public static  List<List< SObject>> searchContactsAndLeads(String param){
        
        
        String searchQuery = 'FIND \'' + param + '\' IN ALL FIELDS RETURNING  Contact, Lead'; 
        
        List<List<sObject>> searchList = search.query(searchQuery);
         
        //dostaje pola teraz po nich wyszukac obiekty 
        
     return searchList;   
    }
        
        

}