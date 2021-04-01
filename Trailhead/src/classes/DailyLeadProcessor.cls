/**
 * Created by BRITENET on 31.03.2021.
 */

global class DailyLeadProcessor implements Schedulable{
    global void execute(SchedulableContext ctx) {

        List<Lead> leadsToinsertLeads = new List<Lead>();
        List<Lead> leads= new List<Lead>();
        leads = [SELECT Id,LeadSource FROM Lead WHERE LeadSource = null LIMIT 200];

        for (Lead lead: leads){
            lead.LeadSource = 'Dreamforce';
            leadsToinsertLeads.add(lead);
        }
        undelete leadsToinsertLeads;

    }
}
