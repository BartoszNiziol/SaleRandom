@isTest
private class BillingCalloutServiceTest {

  public static final Integer BULK_COUNT =100;

    @testSetup
    public static void loadData(){
        ServiceCredentials__c testCred = new ServiceCredentials__c();
        testCred.Name = 'BillingServiceCredential';
        testCred.Username__c = 'TEST';
        testCred.Password__c = 'TEST';
        insert  testCred;

        List <Account> accountsToCreate = new List<Account>();
        for(Integer i = 0; i<BULK_COUNT; i++){
            Account account = new Account();
            account.Name = 'Test '+i;
            accountsToCreate.add(account);
        }

        insert accountsToCreate;

        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();

        for(Account account:accountsToCreate){
            Opportunity firstOpportunity = new Opportunity();
            firstOpportunity.name = 'Testing1'+account.Name;
            firstOpportunity.Amount = 999;
            firstOpportunity.AccountId = account.Id;
            firstOpportunity.CloseDate = Date.Today();
            firstOpportunity.Description = '1';
            firstOpportunity.StageName ='Qualification';
            opportunitiesToCreate.add(firstOpportunity);
        }
        insert opportunitiesToCreate;

        List<Project__c> projectsToCreate = new List<Project__c>();

        for (Opportunity opp: opportunitiesToCreate){
            Project__c project = new Project__c();
            project.Name = 'TEST' + opp.Name;
            project.Billable_Amount__c = 1000;
            project.ProjectRef__c= 'TESTREF' + opp.Name;
            project.Status__c = 'Running';
            project.Opportunity__c = opp.Id;
            projectsToCreate.add(project);
        }

        insert projectsToCreate;
    }

    @isTest static void successTest(){
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.startTest();
        List<Project__c> projectsList = [SELECT Status__c,Id FROM Project__c];
        for(Project__c projectsToUpdate : projectsList){
            projectsToUpdate.Status__c ='Billable';
        }
        update projectsList;
        Test.stopTest();
        for(Project__c updatedProject: [SELECT Status__c FROM Project__c]){
            System.assertEquals('Billed',updatedProject.Status__c);
        }
    }
    @isTest static void faliureTest(){
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());

        Test.startTest();

        List<Project__c> prjectes =[SELECT Status__c, Id FROM Project__c];
        for (Project__c projectToUpdate: prjectes){
            projectToUpdate.Status__c ='Running';
        }

        update prjectes;

        Test.stopTest();

        for(Project__c updatedProjects: [SELECT Status__c,Id FROM Project__c]){
            System.assertEquals('Running', updatedProjects.Status__c);
        }
    }
}