public class AccountTriggerUtility {
    
    public static Boolean isAccountQualifiedToUpdateDynamo(Account oldAccount,Account newAccount){
        Boolean isQualified = false;
        for(String fieldName : RLConstants.ACCOUNT_FIELD_UPDATES_TO_DYNAMO){
           if(Util.isValueChanged(oldAccount,newAccount,fieldName)){
            	isQualified = true;
                break;
            }
        }
        return isQualified;
    }
    
    public static DynamoAccountBodyRequest getDynamoRequestBody(Account account){
        DynamoAccountBodyRequest dynamoBodyRequest = new DynamoAccountBodyRequest();
        dynamoBodyRequest.bankInformation = getBankInfo(account);
        dynamoBodyRequest.businessInformation = getBusinessInfo(account);
        dynamoBodyRequest.isActive = account.Active__c;
        dynamoBodyRequest.status = Util.verifyString(account.Dynamo_Status__c);
        dynamoBodyRequest.uuid = Util.verifyString(account.merchant_uuid__c);
        dynamoBodyRequest.merchantId = Util.verifyString(account.Merchant_ID__c);
        dynamoBodyRequest.maxFirstDrawPercent = Util.verifyNumber(account.Initial_Draw__c);
        return dynamoBodyRequest;
    }
    
    public static DynamoTypes.BankInformation getBankInfo(Account account){
        DynamoTypes.BankInformation bankInfo = new DynamoTypes.BankInformation();
        bankInfo.accountNumber = Util.verifyString(account.Bank_Account_Number__c);
        bankInfo.routingNumber = Util.verifyString(account.Bank_Routing_Number__c);
        return bankInfo;
    }
    
    public static DynamoTypes.BusinessInformation getBusinessInfo(Account account){
        DynamoTypes.BusinessInformation businessInfo = new DynamoTypes.BusinessInformation();
        businessInfo.website =  Util.verifyString(account.Website);
        businessInfo.federalTaxId =  Util.verifyString(account.TaxID__c);
        businessInfo.contractorLicenseNumber = Util.verifyString(account.Contractor_License__c);	 
		businessInfo.businessStructure = Util.verifyString(account.Business_Structure__c);	 
		businessInfo.mailingAddress = getAddress(account,true);
		businessInfo.physicalAddress = getAddress(account,false);
		businessInfo.legalBusinessName = account.Name;	 
		businessInfo.businessLicenseNumber = Util.verifyString(account.Business_License__c);	 
		businessInfo.typeOfServiceOrProductOffered = Util.verifyString(account.Main_Service__c);	 
		businessInfo.allTradeNames = String.isBlank(account.Doing_Business_As__c)?new List<String>():account.Doing_Business_As__c.split(',');
		businessInfo.businessPhone = account.phone!=null?Long.valueOf(account.phone):null;	 
		businessInfo.annualSalesRevenue = Util.verifyNumber(account.AnnualRevenue);	 
		businessInfo.annualConsumerFinanceVolume = Util.verifyNumber(account.Annual_Consumer_Finance_Volume__c);
        if(account.In_Business_Since__c!= null){
            businessInfo.inBusinessSince = Util.getInBusinessSince(account.In_Business_Since__c); 
        }
		   
        return businessInfo;
    }
    
    public static DynamoTypes.PostalAddress getAddress(Account account,Boolean isMailingAddress){
        DynamoTypes.PostalAddress address = new DynamoTypes.PostalAddress();
        address.street = isMailingAddress ? Util.verifyString(account.ShippingStreet) : Util.verifyString(account.BillingStreet);   
        address.city =  isMailingAddress ? Util.verifyString(account.ShippingCity) : Util.verifyString(account.BillingCity);    
        address.state = isMailingAddress ? Util.changeStateToAbbrev(account.ShippingState) : Util.changeStateToAbbrev(account.BillingState);
        address.zip =  isMailingAddress ? Util.verifyString(account.ShippingPostalCode) : Util.verifyString(account.BillingPostalCode);
        return address;
    }
    
    public static Map<String,Decimal> getMainServiceInitialDrawMap(){
        Map<String,Decimal> mainServiceInitialDrawMap = new Map<String,Decimal>();
        for(Main_Service_Initial_Draw__mdt serviceDraw : [SELECT MasterLabel,Initial_Draw_Percentage__c FROM Main_Service_Initial_Draw__mdt]){
            mainServiceInitialDrawMap.put(serviceDraw.MasterLabel,serviceDraw.Initial_Draw_Percentage__c);
        }
        return mainServiceInitialDrawMap;
    }

    @future(callout=true)
    public static void performAccountUpdateCallout(String acctURL, String acctPutReq) {
        try{
            acctPutReq = acctPutReq.remove('"primaryContactForFinancingInformation":null,');
            system.debug('::::requestBody-after::::'+acctPutReq);
        	String response = CalloutHelper.performPutCallout(acctURL, acctPutReq);
            system.debug(':::::response:::::'+response);
        }Catch(Exception ex){
            System.debug('::::Exception::::'+ex.getMessage());
            System.debug('::::Exception::::'+ex.getStackTraceString());
        }
    	
    }
}