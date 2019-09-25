public class DynamoLeadBodyRequest{
	public LeadMetaData metadata;	
    public class LeadMetaData {
        public String leadid;	 
        public String firstName;	 
        public String lastName;	 
        public String email;	 
        public String titleWithCompany;	 
        public Boolean isOwner;	 
        public Boolean authorityToBindCompany;	 
        public String legalBusinessName;	 
        public String businessPhone;
        public LeadMetaData(Lead newLead){
            this.leadid = newLead.Id;
            this.firstName = newLead.FirstName;
            this.lastName = newLead.LastName;
            this.email = newLead.Email;
            this.titleWithCompany = newLead.Title_With_Company__c;
            this.isOwner = newLead.Owner__c;
            this.authorityToBindCompany = newLead.hasSignAuth__c;
            this.legalBusinessName = newLead.Company;
            this.businessPhone = newLead.Phone;
        }		
	}
}