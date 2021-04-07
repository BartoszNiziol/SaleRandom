/**
 * Created by BRITENET on 30.03.2021.
 */
@isTest
public with sharing class LeadProcessorTest {

    @isTest
    public static void testit() {
        List<lead> l_lst = new List<lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new lead();
            l.LastName = 'name' + i;
            l.company = 'company';
            l.Status = 'somestatus';
            l_lst.add(l);
        }
        insert l_lst;

        test.startTest();

        Leadprocessor lp = new Leadprocessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
    }
}