public class ContactSearch  {
    public static List<Contact> searchForContacts(String first, String second){
        
      Contact[] contacts =   [SELECT Id,Name 
                              FROM Contact
                              WHERE (LastName=:first AND MailingPostalCode=:second)];
        
        return contacts;
        
    }

}