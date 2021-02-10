@isTest
public class TestRestrictContactByName {

    @isTest static void testInsertContactWithInvalid()   {
        
        Contact contact = new Contact(LastName = 'INVALIDNAME');
            Test.startTest();
          Database.saveResult inserResult =  Database.insert(contact,false);
            Test.stopTest();
            
        System.assert(!inserResult.isSuccess());
        system.assert(inserResult.getErrors().size()>0);
    }
    
}