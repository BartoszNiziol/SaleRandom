/**
 * Created by BRITENET on 31.03.2021.
 */
@isTest
private class ProjectRestServiceTest {
    @testSetup
    public static void prepereData(){
        Opportunity opportunity= new Opportunity();
        opportunity.Name = 'TEST';
        opportunity.DeliveryInstallationStatus__c = 'In Progress';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Qualification';

        insert opportunity;

        Project__c project = new Project__c();
        project.ProjectRef__c = 'ProjectRef';
        project.Name = 'ProjectName';
        project.Opportunity__c = opportunity.Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = (Date.today()).addDays(1);
        project.Billable_Amount__c = 999;
        project.Status__c = 'Running';

        insert project;
    }

    @isTest
    public static void testProjectRestService(){
        Project__c project = [SELECT Id,ProjectRef__c,Name,Opportunity__c,Start_Date__c,End_Date__c,Billable_Amount__c,Status__c FROM Project__c LIMIT 1];

        Test.startTest();
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(1,[SELECT count() FROM Opportunity]);
        String returnMessage = ProjectRestService.postProjectData('ProjectRef','ProjectName',String.valueOf(opportunity.Id),Date.today(),Date.today(),999,'Running');
        Test.stopTest();
    }

}