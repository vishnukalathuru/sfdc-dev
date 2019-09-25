public class LeadTriggerHandler {
    
    // This method is calling service for every record. This will hit governor limits for dataload of more than 100 records. 
    // Once dynamo is updated to take list of Leads as input, Changes need to be made to this method. 
	public static void createApplicationURL(Map<Id,Lead> newLeads,Map<Id,Lead> oldLeads) {
        Lead oldLead = null;
        for(Lead newLead : newLeads.values()){
            if(oldLeads!= null){
                oldLead = oldLeads.get(newLead.Id);
            }
            if(String.isBlank(newLead.Merchant_Id__c) && String.isBlank(newLead.Application_URL__c) && (oldLeads == null || (oldLeads!= null && Util.isValueChanged(oldLead,newLead,'Application_URL__c') ) && !System.isFuture() )) {
                LeadTriggerutility.updateApplicationURL(JSON.serialize(newLead));
            }
        }
    }
}