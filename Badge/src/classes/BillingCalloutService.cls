/**
 * Created by BRITENET on 31.03.2021.
 */

public with sharing class BillingCalloutService {

    public static void callBillingService (List<Project__c> newProjects, Map<Id,Project__c> odlProjects){


        List <Project__c> projectToSynchronize = new List<Project__c>();
        for(Project__c project: newProjects){


            Project__c oldProject = odlProjects.get(project.Id);

            if(meetCriteria(project,oldProject)){
                projectToSynchronize.add(project);
            }
        }

        synchronizeCallout(JSON.serialize(projectToSynchronize));
    }

    @future(callout=true)
    public static void synchronizeCallout(String serializeProjects){
        List<Project__c> projectsToProcess =(List<Project__c> )JSON.deserialize(serializeProjects,List<Project__c>.class);


        Map<String,String> mapCalloutResponses = new Map<String,String>();

        ServiceCredentials__c credentials =  ServiceCredentials__c.getInstance('BillingServiceCredential');

        List<BillingServiceProxy.project> soapRequests = new List<BillingServiceProxy.project>();

        List<Project__c> projectsReadyToUpdate = new List<Project__c>();

        for(Project__c projec: projectsToProcess){
            BillingServiceProxy.project project = new BillingServiceProxy.project();
            project.username = credentials.Username__c;
            project.password = credentials.Password__c;
            project.projectid = projec.ProjectRef__c;
            project.billAmount = projec.Billable_Amount__c;
            soapRequests.add(project);
        }

        for(BillingServiceProxy.project soapPayloads:soapRequests){
            BillingServiceProxy.InvoicesPortSoap11 invoiceCall = new BillingServiceProxy.InvoicesPortSoap11();
            mapCalloutResponses.put(soapPayloads.projectid,invoiceCall.billProject(soapPayloads));
        }

        for(String projectRef :mapCalloutResponses.keySet()){
            if(mapCalloutResponses.get(projectRef) != null && mapCalloutResponses.get(projectRef).equalsIgnoreCase('OK')){
                Project__c projectToUpdate =new Project__c(ProjectRef__c = projectRef);
                projectToUpdate.Status__c = 'Billed';
                projectsReadyToUpdate.add(projectToUpdate);
            }
        }

        if(projectsReadyToUpdate.size() >0){

            upsert projectsReadyToUpdate ProjectRef__c;
        }
    }

    public static Boolean meetCriteria(Project__c newProject, Project__c oldProject){
        if(newProject.Status__c =='Billable' && newProject.Status__c != oldProject.Status__c){
            return true;
        }
        return false;
    }

}