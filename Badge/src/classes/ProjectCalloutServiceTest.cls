/**
 * Created by BRITENET on 31.03.2021.
 */
@IsTest
private class ProjectCalloutServiceTest {
    @TestSetup
    public static void createTestData() {
        ServiceTokens__c serviceTokens = new ServiceTokens__c();
        serviceTokens.Name = 'ProjectServiceToken';
        serviceTokens.Token__C = 'xxxxxxxxxxxxx';

        insert serviceTokens;

        Opportunity firstOpportunity = new Opportunity();
        firstOpportunity.name = 'Testing1';
        firstOpportunity.Type = 'New Project';
        firstOpportunity.Amount = 999;
        firstOpportunity.CloseDate = Date.Today();
        firstOpportunity.Description = '1';
        firstOpportunity.StageName ='Qualification';


        Opportunity secondOpportunity = new Opportunity();
        secondOpportunity.name = 'Testing2';
        secondOpportunity.Type = 'New Project';
        secondOpportunity.Amount = 997;
        secondOpportunity.CloseDate = Date.Today();
        secondOpportunity.Description = '2';
        secondOpportunity.StageName ='Qualification';

        insert firstOpportunity;
        insert secondOpportunity;
    }
    @IsTest
    public static void succesTest() {
        List<Opportunity> opportuniteis = [SELECT Id,Name FROM Opportunity WHERE Name = 'Testing1'];
        Opportunity opp = opportuniteis.get(0);
        List<Id> oppsIds = new List<Id>();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        Test.startTest();
        ProjectCalloutService.PostOpportunityToPMS(oppsIds);
        Test.stopTest();
        List<Opportunity> updated = [SELECT Id,Name,Description FROM Opportunity WHERE Name ='Testing1'];
        Opportunity updatedOpportunity = updated.get(0);
        System.assertEquals('1',updatedOpportunity.Description);
    }

    @IsTest
    public static void failedTest() {
        List<Opportunity> opportuniteis = [SELECT Id,Name FROM Opportunity WHERE Name = 'Testing2'];
        Opportunity opp = opportuniteis.get(0);
        List<Id> oppsIds = new List<Id>();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        Test.startTest();
        ProjectCalloutService.PostOpportunityToPMS(oppsIds);
        Test.stopTest();
        List<Opportunity> updated = [SELECT Id,Name,Description FROM Opportunity WHERE Name ='Testing2'];
        Opportunity updatedOpportunity = updated.get(0);
        System.assertEquals('2',updatedOpportunity.Description);
    }

}