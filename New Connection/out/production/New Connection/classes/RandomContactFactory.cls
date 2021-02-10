public class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer contactsNumber,String contactLastName){
        
        List<Contact> contacts = new List<Contact>();
        List<String> firstNames = generateFirstNames(contactsNumber);
        
        for(String f: firstNames){
            Contact contact = new Contact(FirstName = f,LastName = contactLastName);
            contacts.add(contact);
        }
        
        return contacts;
    }
    
    
    private static List<String> generateFirstNames(Integer numberOfFirstNames) {
        
        List<String> firstNames = new List<String>();
        
        for(Integer i =0; i< numberOfFirstNames;i++){
            firstNames.add('Test'+i);
        }
        
        return firstNames;
        
    }
}