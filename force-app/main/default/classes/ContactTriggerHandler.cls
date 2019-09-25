public with sharing class ContactTriggerHandler {
    
    public static void updateContactToDynamo(Map<Id,Contact> newContactMap, Map<Id,Contact> oldContactMap) {
        Contact oldContact = null;
        Map<Id,String> accountIdMerchantInfoMap = getAccountMerchantInfo(newContactMap.values());
        for(Contact contact : newContactMap.values()){
            oldContact = oldContactMap != null ? oldContactMap.get(contact.Id) : null;
            if(isContactQualifiedToUpdateDynamo(oldContact,contact)){
                if( accountIdMerchantInfoMap.containsKey(contact.AccountId) ){
                    Map<String, Object> contactDynamoRequest = getContactDynamoRequest(accountIdMerchantInfoMap,contact);
                    performSPIDUpdateCallout(contact,oldContact);   
                    String merchantUUID = accountIdMerchantInfoMap.get(contact.AccountId).split('#')[1];   
                    system.debug('::::request-contact-body:::::'+JSON.serialize(contactDynamoRequest));
                    ContactHelper.performContactUpdateCallout('merchants/'+merchantUUID, JSON.serialize(contactDynamoRequest));    
                }
            }
        }
    }
    
    
    private static Boolean isContactQualifiedToUpdateDynamo(Contact oldContact,Contact newContact){
        Boolean isQualified = false;
        for(String fieldName : RLConstants.CONTACT_FIELD_UPDATES_TO_DYNAMO){
           if(Util.isValueChanged(oldContact,newContact,fieldName)){
            	isQualified = true;
                break;
            }
        }
        return isQualified;
    }

    private static Map<String, Object> getContactDynamoRequest(Map<Id,String> accountIdMerchantInfoMap,Contact contact){
        Map<String, Object> contactDynamoRequest = new Map<String, Object>();
        if( accountIdMerchantInfoMap.containsKey(contact.AccountId) ){
            contactDynamoRequest.put('merchantId',accountIdMerchantInfoMap.get(contact.AccountId).split('#')[0]);
            if(contact.Owner__c){
                contactDynamoRequest.put('owners',getOwnersInfo(contact));
            }
            if(contact.IsApplicant__c){
                contactDynamoRequest.put('applicantInformation',getApplicationInformation(contact));
            }
            if(contact.Primary_Contact__c){
                contactDynamoRequest.put('businessInformation',getBusinessInformation(contact));
            }
        }
        return contactDynamoRequest;
    }

    private static Map<Id,String> getAccountMerchantInfo(List<Contact> contactList) {
        Map<Id,String> accountIdMerchantInfoMap = new Map<Id,String>();
        Set<Id> accountIdSet = new Set<Id>();
        for(Contact contact : contactList){
            accountIdSet.add(contact.AccountId);
        }
        for(Account account : [SELECT Id,Merchant_ID__c,Merchant_uuid__c FROM Account WHERE Id IN :accountIdSet ]){
            if( !String.isBlank(account.Merchant_ID__c) && !String.isBlank(account.merchant_uuid__c) ){
                accountIdMerchantInfoMap.put(account.Id,account.Merchant_ID__c+'#'+account.Merchant_uuid__c);
            }
        }
        return accountIdMerchantInfoMap;
    }

    private static List<DynamoContactBodyRequest.Owners> getOwnersInfo(Contact contact){
        List<DynamoContactBodyRequest.Owners> ownersList = null;
        if(contact.Owner__c){
            ownersList = new List<DynamoContactBodyRequest.Owners>();
            DynamoContactBodyRequest.Owners owner = new DynamoContactBodyRequest.Owners();
            owner.uuid = contact.Contact_UUID__c;
            owner.ownerSince = Util.getInBusinessSince(contact.Owner_Since__c);
            owner.personalInformation = getPersonalInformation(contact);
            owner.residentialAddress = Util.getAddressFields(contact,RLConstants.MAILING);
            owner.ownershipPercentage = contact.Ownership__c;
            ownersList.add(owner);
        }
        return ownersList;
    }
 
    private static DynamoContactBodyRequest.PersonalInformation getPersonalInformation(Contact contact){
        DynamoContactBodyRequest.PersonalInformation personalInfo = new DynamoContactBodyRequest.PersonalInformation();
        personalInfo.firstName = contact.FirstName;
        personalInfo.lastName = contact.LastName;
        personalInfo.dateOfBirth = Util.getDOB(contact.Birthdate);
        personalInfo.mobileNumber = contact.MobilePhone!= null ? Long.valueOf(contact.MobilePhone): contact.Phone != null ? Long.valueOf(contact.Phone):null;
        personalInfo.socialSecurityNumber = contact.SSN__c;
        personalInfo.email = contact.Email;
        return personalInfo;
    }

    private static DynamoTypes.BusinessInformation getbusinessInformation(Contact contact){
        DynamoTypes.BusinessInformation businessInfo = null;
        if(contact.Primary_Contact__c){
            businessInfo = new DynamoTypes.BusinessInformation();
            businessInfo.primaryContactForFinancingInformation = getContactInfo(contact);
        }
        return businessInfo;
    }

    private static DynamoTypes.ContactInfo getContactInfo(Contact contact){
        DynamoTypes.ContactInfo contactInfo = new DynamoTypes.ContactInfo();
        contactInfo.firstName = contact.FirstName;
        contactInfo.lastName = contact.LastName;
        contactInfo.email = contact.Email;
        return contactInfo;
    }

    private static DynamoTypes.ApplicantInformation getApplicationInformation(Contact contact){
        DynamoTypes.ApplicantInformation applicationInfo = null;
        if(contact.IsApplicant__c){
            applicationInfo = new DynamoTypes.ApplicantInformation();
            applicationInfo.uuid = contact.Contact_UUID__c; 
            applicationInfo.authorityToBindCompany = contact.Signature_Authority__c;
            applicationInfo.titleWithCompany = Util.verifyString(contact.Title_With_Company__c);
            applicationInfo.firstName = Util.verifyString(contact.FirstName);
            applicationInfo.lastName = contact.LastName;
            applicationInfo.isOwner = contact.Owner__c;
            applicationInfo.email  = Util.verifyString(contact.Email);
            applicationInfo.phone = contact.Phone!= null ? Long.valueOf(contact.Phone): contact.MobilePhone != null ? Long.valueOf(contact.MobilePhone):null;
        }
        return applicationInfo;
    }

    private static void performSPIDUpdateCallout(Contact contact,Contact oldContact){
        if( (Util.isValueChanged(oldContact,contact,'Contact_Type__c') || Util.isValueChanged(oldContact,contact,'isActive__c') )
            && !String.isBlank(contact.Contact_Type__c) && RLConstants.CONTACT_TYPE_SET.contains(contact.Contact_Type__c) && !String.isBlank(contact.Contact_UUID__c)  ) {
            String spid_baseurl = RLConstants.SPIDURL + '/' + contact.Contact_UUID__c + '/';
            spid_baseurl = contact.isActive__c ? spid_baseurl+'enable' : spid_baseurl+'disable';
            ContactHelper.performSPIDUpdateCallout(spid_baseurl);
        }
    }
    public ContactTriggerHandler() {}
}
