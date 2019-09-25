public with sharing class CreateApplicationUtility {
    public CreateApplicationUtility() {}

    public static void processApplicationBasedOnTopic(MerchantApplicationRequest merchantRequest){
        if( RLConstants.MERCHANT_APPLICATION_STARTED.equalsIgnoreCase(merchantRequest.topic) ){
            createLeadRecord(merchantRequest.resource);
        }else if( RLConstants.MERCHANT_APPLICATION_PENDING_DECISION.equalsIgnoreCase(merchantRequest.topic) ){
            processLeadConversion(merchantRequest.resource);
        }else if( RLConstants.SALESPERSON_CREATED.equalsIgnoreCase(merchantRequest.topic) || RLConstants.SALESPERSON_UPDATED.equalsIgnoreCase(merchantRequest.topic) ){
            updateSalesPersonId(merchantRequest.resource.uuid);
        }else if( RLConstants.MERCHANT_TRAINING_COMPLETE.equalsIgnoreCase(merchantRequest.topic)){
            updateTrainingAccount(merchantRequest.resource);
        }
    }

    private static void createLeadRecord(MerchantApplicationRequest.Resource resource){
        if(resource.metadata != null && !String.isBlank(resource.metadata.leadId)) {
            DynamoTypes.Metadata leadMetadata =  resource.metadata;
            Lead leadToUpdate = new Lead(Id=resource.metadata.leadId);
            leadToUpdate.FirstName = leadMetadata.firstName;
            leadToUpdate.LastName = leadMetadata.lastName;
            leadToUpdate.Owner__c =  leadMetadata.isOwner;  
            leadToUpdate.Title_With_Company__c = leadMetadata.titleWithCompany;  
            leadToUpdate.Company = leadMetadata.legalBusinessName;
            leadToUpdate.Phone = leadMetadata.businessPhone != null ? String.valueOf(leadMetadata.businessPhone) : null;
            leadToUpdate.Email = leadMetadata.email;
            update leadToUpdate;
        }else {
            Lead newLead = new Lead();
            if(resource.applicantInformation != null){
                DynamoTypes.ApplicantInformation applicationInfo = resource.applicantInformation;
                newLead.FirstName = applicationInfo.firstName;
                newLead.LastName = applicationInfo.lastName;
                newLead.Email = applicationInfo.email;
                newLead.Title_With_Company__c = applicationInfo.titleWithCompany; 
                newLead.Phone = applicationInfo.phone!= null ? String.valueOf(applicationInfo.phone) : null;
                newLead.Contact_UUID__c = applicationInfo.uuid;                          
            }
            if(resource.businessInformation != null){
                DynamoTypes.BusinessInformation businessInfo = resource.businessInformation;
                newLead.Company = businessInfo.legalBusinessName;
                newLead.Main_Service__c = businessInfo.typeOfServiceOrProductOffered;
            }
            newLead.Merchant_Id__c = resource.merchantId != null ? String.valueOf(resource.merchantId) : null;
            newLead.Partner_UUID__c = resource.partnerUuid; 
            if (!String.isBlank(resource.partnerUuid)) {
                String partnerResponse = CalloutHelper.performGetCallout('partners/' +resource.partnerUuid+'/');
                Map<String, Object> partnerData = (Map<String, Object>) JSON.deserializeUntyped(partnerResponse);
                newLead.Partner_Name__c = partnerData.get('partnerName') != null ? (String) partnerData.get('partnerName') : null ;
            }
            newLead.Status = RLConstants.NEW_STATUS;
            Leadhelper.createLead(newLead);
        }
    }

    private static void processLeadConversion(MerchantApplicationRequest.Resource resource){
        Lead existingLead = null;
        if(resource.metadata != null && !String.isBlank(resource.metadata.leadId)) {
            existinglead = [ SELECT Id, IsConverted, FirstName, LastName, Email, Title_With_Company__c,Company,Phone,Merchant_Id__c,Partner_UUID__c,Partner_Name__c FROM Lead WHERE Id = :resource.metadata.leadId ];
        }else if(resource.merchantId != null){
            String merchantId = String.valueOf(resource.merchantId);
            existinglead = [ SELECT Id,IsConverted,FirstName,LastName,Email,Title_With_Company__c,Company,Phone,Merchant_Id__c,Partner_UUID__c,Partner_Name__c FROM Lead WHERE Merchant_Id__c = :merchantId LIMIT 1 ];
        } 
        LeadTriggerUtility.convertLead(existingLead,resource);
    }

    private static void updateSalesPersonId(String merchantUuid){
        if(!String.isBlank(merchantUuid)){
            try{
                String spidURL = 'merchants/'+merchantUuid+'/salespeople';
                String spidResponse = CalloutHelper.performGetCallout(spidURL);
                ContactHelper.upsertSPID(spidResponse);
            }catch(Exception ex){
                system.debug(':::::exception:::::'+ex.getMessage());
            }
        }
    }

    private static void updateTrainingAccount(MerchantApplicationRequest.Resource resource){
        String merchantId = resource.merchantId != null ? String.valueOf(resource.merchantId) : null;
        if(!String.isBlank(merchantId)){
            Account trainingAccount = [SELECT Id,Training_Complete__c,Training_Complete_Date__c FROM Account WHERE Merchant_ID__c = :merchantId LIMIT 1];
            if(trainingAccount != null){
                trainingAccount.Training_Complete__c = true;
                trainingAccount.Training_Complete_Date__c = System.today();
                update trainingAccount;    
            }
        }
    }
}
