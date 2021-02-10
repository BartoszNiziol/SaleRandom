@isTest
public class TestVerifyDate {


        
    @isTest  static void testWithin30Days(){
        Date firstDate = Date.newInstance(2021,1,1);
        Date secondDate = Date.newInstance(2021,1,2);
        
        Date dateResult =  VerifyDate.CheckDates(firstDate,secondDate);
        
        System.assertEquals(secondDate, dateResult);
    }
    
    @isTest static void testAwayFrom30Days(){
        Date firstDate = Date.newInstance(2021,1,1);
        Date secondDate = Date.newInstance(2020,1,2);
         Date dateResult =  VerifyDate.CheckDates(firstDate,secondDate);
        
         System.assertEquals(secondDate, dateResult);

    }
    
}