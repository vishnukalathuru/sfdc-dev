public class LeadTriggerUtility {
 // This method is calling service for every record. This will hit governor limits for dataload of more than 100 records. 
 // Once dynamo is updated to take list of Leads as input, Changes need to be made to this method.    	  
    public static void createApplicationURL(Map<Id,Lead> newLeads,Map<Id,Lead> oldLeads) {
        Lead oldLead = null;
        for(Lead newLead : newLeads.values()){
            if(oldLeads!= null){
                oldLead = oldLeads.get(newLead.Id);
            }
            if(String.isBlank(newLead.Merchant_Id__c) && String.isBlank(newLead.Application_URL__c) && (oldLeads == null || (oldLeads!= null && Util.isValueChanged(oldLead,newLead,'Application_URL__c') ) && !System.isFuture() )) {
                updateApplicationURL(JSON.serialize(newLead));
            }
        }
    }
    
    
    @future(callout=true)
    public static void updateApplicationURL(String newLead){
        try{
            Lead newLeadRecord = (Lead)JSON.deserialize(newLead,Lead.class);
            DynamoLeadBodyRequest.LeadMetaData leadBody = new DynamoLeadBodyRequest.LeadMetaData(newLeadRecord);
            DynamoLeadBodyRequest dynamoBodyRequest = new DynamoLeadBodyRequest();
            dynamoBodyRequest.metadata = leadBody;
            String leadPutURLRequest = JSON.serialize(dynamoBodyRequest);
            System.debug(':::::body-request::::'+leadPutURLRequest);
            String response = CalloutHelper.performPostCallout('links/merchants',leadPutURLRequest);
            system.debug(':::::response:::::'+response);
            if(String.isNotBlank(response)){
                Map<String, Object> urlMap = (Map<String, Object>) JSON.deserializeUntyped(response);
                if( urlMap != null && urlMap.containsKey('link')  ) {
                    Lead leadToUpdate = new Lead(Id=newLeadRecord.Id,Application_URL__c=(String)urlMap.get('link'));
                    update leadToUpdate;
                }
            }
        }Catch(Exception ex){
            Util.insertErrorLog('LeadTriggerUtility','updateApplicationURL',ex.getMessage());
            system.debug(':::::Exception:::::'+ex.getMessage() );
            system.debug(':::::Exception:::::'+ex.getStackTraceString());
        }
    }

    public static void convertLead(Lead lead,MerchantApplicationRequest.Resource resource){
        String leadPartnerUUID = lead.Partner_UUID__c;
        String leadPartnerName = lead.Partner_Name__c;
        if(lead != null && !lead.IsConverted && lead.Id == null && !String.isBlank(resource.uuid)){
            lead.Merchant_Id__c = resource.uuid;
            DynamoTypes.ApplicantInformation applicationInfo = resource.applicantInformation;
            DynamoTypes.BusinessInformation businessInfo = resource.businessInformation;
            if( applicationInfo != null){
                lead.FirstName = !String.isBlank(applicationInfo.firstName) ? applicationInfo.firstName : lead.FirstName;
                lead.LastName = !String.isBlank(applicationInfo.lastName) ? applicationInfo.lastName : lead.LastName;                 
                lead.Email = !String.isBlank(applicationInfo.email) ? applicationInfo.email : lead.Email;
                lead.Title_With_Company__c = !String.isBlank(applicationInfo.titleWithCompany) ? applicationInfo.titleWithCompany : lead.Title_With_Company__c;
            }
            if( businessInfo != null ){
                lead.Company = !String.isBlank(businessInfo.legalBusinessName) != null ? businessInfo.legalBusinessName : lead.Company;
                lead.Phone = businessInfo.businessPhone != null ? String.valueOf(businessInfo.businessPhone) : lead.Phone;
            } 
            upsert lead Merchant_Id__c;
        }
        if(lead != null && lead.Id != null && !lead.IsConverted ){
            Database.LeadConvert leadCon = new Database.LeadConvert();
            leadCon.setLeadId(lead.Id);
            LeadStatus convertStatus = [ SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            leadCon.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(leadCon);
            if (lcr.isSuccess()) {
                processConvertedAccount(lcr.getAccountId(),leadPartnerUUID,leadPartnerName,resource);
                processConvertedContact(lcr.getContactId(),lcr.getAccountId(),resource);
            }
        }
    }

    private static void processConvertedAccount(Id accountId,String partnerUUID,String partnerName,MerchantApplicationRequest.Resource resource){
        try{
            Account account = new Account(id = accountId);
            if(resource.businessInformation != null){
                DynamoTypes.BusinessInformation businessInfo = resource.businessInformation;
                account.Name = businessInfo.legalBusinessName;
                account.TaxId__c = businessInfo.federalTaxId;
                account.Website = businessInfo.website;
                account.Annual_Consumer_Finance_Volume__c = businessInfo.annualConsumerFinanceVolume;
                account.Contractor_License__c = businessInfo.contractorLicenseNumber;
                account.Business_Structure__c = businessInfo.businessStructure;
                account.Business_License__c = businessInfo.businessLicenseNumber;
                account.Main_Service__c = businessInfo.typeOfServiceOrProductOffered;
                account.AnnualRevenue = businessInfo.annualSalesRevenue;
                populateAddressFields(account,businessInfo.physicalAddress,RLConstants.BILLING);
                populateAddressFields(account,businessInfo.mailingAddress,RLConstants.SHIPPING);
                account.In_Business_Since__c = getBusinessSince(businessInfo.inBusinessSince);
                account.Doing_Business_As__c = getDoingBusinessAsInfo( businessInfo.allTradeNames);
            }
            if(resource.bankInformation != null){
                account.Bank_Account_Number__c = resource.bankInformation.accountNumber;
                account.Bank_Routing_Number__c = resource.bankInformation.routingNumber;
            }
            account.Merchant_Uuid__c = resource.uuid;
            account.Merchant_Id__c = resource.merchantId != null ? String.valueOf(resource.merchantId) : null;
            account.IP_Address__c = resource.ipAddress;
            account.Partner_UUID__c = partnerUUID;
            account.Partner_Name__c = partnerName;
            update account;
        }catch(Exception ex){
            Util.insertErrorLog('LeadTriggerUtility','processConvertedAccount',ex.getMessage());
            system.debug(':::::exception::::::'+ex.getMessage());
            system.debug(':::::exception::::::'+ex.getStackTraceString());
        }
    }  

    private static void processConvertedContact(Id contactId,Id accountId,MerchantApplicationRequest.Resource resource){
        try{
            delete [SELECT Id FROM Contact WHERE Id=:contactId];
            List<Contact> contactList = new List<Contact>();
            if( resource.businessInformation != null && resource.businessInformation.primaryContactForFinancingInformation != null ){
                DynamoTypes.ContactInfo contactInfo = resource.businessInformation.primaryContactForFinancingInformation;
                Contact contact = new Contact();
                contact.FirstName = contactInfo.name.substringBefore(' ');
                contact.LastName = contactInfo.name.substringBefore(' ');
                contact.Email = contactInfo.email;
                contact.Contact_UUID__c = contactInfo.uuid;
                contact.AccountId = accountId;
                contactList.add(contact);
            }
            if(resource.owners!=null&& resource.owners.size() > 0){
                DynamoTypes.ApplicantInformation applicantInformation = resource.applicantInformation;
                Contact contact = null;
                Boolean isApplicantSameAsOwner = false;
                for( DynamoTypes.Owners owner : resource.owners ){
                    contact = new Contact();
                    DynamoTypes.PersonalInformation personalInfo = owner.personalInformation;
                    contact.AccountId = accountId;
                    contact.FirstName = personalInfo.firstName;
                    contact.LastName = personalInfo.lastName;
                    contact.Email = personalInfo.email;
                    contact.BirthDate = personalInfo.dateOfBirth != null ? Date.newInstance(personalInfo.dateOfBirth.year,personalInfo.dateOfBirth.month,personalInfo.dateOfBirth.day) : null;
                    contact.SSN__c = personalInfo.socialSecurityNumber;
                    contact.MobilePhone = personalInfo.mobileNumber != null ? String.valueOf(personalInfo.mobileNumber) : null;
                    contact.Title_With_Company__c = personalInfo.titleWithCompany;
                    contact.Owner__c = true;
                    contact.Ownership__c = owner.ownershipPercentage;
                    contact.Owner_Since__c = getBusinessSince(owner.ownerSince);
                    contact.Contact_UUID__c = owner.uuid;
                    populateAddressFields(contact,owner.residentialAddress,RLConstants.MAILING); 
                    if( applicantInformation != null && applicantInformation.firstName.equalsIgnoreCase(personalInfo.firstName) && applicantInformation.lastName.equalsIgnoreCase(personalInfo.lastName) && 
                        !String.isBlank(applicantInformation.email) && applicantInformation.email.equalsIgnoreCase(personalInfo.email) ){
                        contact.IsApplicant__c = true;
                        isApplicantSameAsOwner = true;
                    }
                    contactList.add(contact);
                }
                if(!isApplicantSameAsOwner && applicantInformation != null){
                    Contact applicationContact = new Contact();
                    applicationContact.AccountId = accountId;
                    applicationContact.FirstName = applicantInformation.firstName;
                    applicationContact.LastName = applicantInformation.lastName;
                    applicationContact.Email = applicantInformation.email;
                    applicationContact.Owner__c = applicantInformation.isOwner;
                    applicationContact.IsApplicant__c = true;
                    applicationContact.Signature_Authority__c = applicantInformation.authorityToBindCompany;
                    applicationContact.Contact_UUID__c = applicantInformation.uuid;
                    contactList.add(applicationContact);
                } 
            }
            if(contactList != null && contactList.size() > 0){
                upsert contactList Contact_UUID__c;
            }
        } Catch(Exception ex){
            Util.insertErrorLog('LeadTriggerUtility','processConvertedContact',ex.getMessage());
            System.debug('::::::exception:::::'+ex.getMessage());
            System.debug('::::::exception:::::'+ex.getStackTraceString());
        }
        
    }

    private static String getDoingBusinessAsInfo(List<String> allTradeNames){
        String tradeNames = '';
        if( allTradeNames != null  && allTradeNames.size() > 0 ){
            for(String tradename : allTradeNames ){
                tradeNames = tradeNames + tradename+',';
            }
        }
        return tradeNames.removeEnd(',');
    }

    private static Date getBusinessSince(DynamoTypes.InBusinessSince dateSince){
        Date businessStartDate;
        if( dateSince != null ){
            businessStartDate = Date.newInstance(dateSince.year,dateSince.month,1);
        }
        return businessStartDate;
    }

    private static void populateAddressFields(SObject sObjrecord,DynamoTypes.PostalAddress address,String type){
        if(address != null){
            sObjrecord.put(type+RLConstants.STREET,address.street);
            sObjrecord.put(type+RLConstants.CITY,address.city);
            sObjrecord.put(type+RLConstants.STATE,!String.isBlank(address.state) ? Util.changeStateToFullName(address.state) : null);
            sObjrecord.put(type+RLConstants.POSTALCODE,address.zip);
            if(!RLConstants.MAILING.equalsIgnoreCase(type)){
                sObjrecord.put(type+RLConstants.COUNTRY,RLConstants.UNITED_STATES);
            }
        }
    }

    
}