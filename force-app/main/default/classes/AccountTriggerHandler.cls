public class AccountTriggerHandler {
    public static void prePopulateInitialDraw(List<Account> accountList,Map<Id,Account> oldMap){
        Map<String,Decimal> mainServiceInitialDrawMap = AccountTriggerUtility.getMainServiceInitialDrawMap();
        Account oldAccount;
        for(Account account : accountList){
            oldAccount = oldMap != null ? oldMap.get(account.Id) : null;
            if(Util.isValueChanged(oldAccount, account, RLConstants.MAIN_SERVICE) && mainServiceInitialDrawMap.containsKey(account.Main_Service__c) ){
                account.Initial_Draw__c = mainServiceInitialDrawMap.get(account.Main_Service__c);
            }
        }
    }
 // This method is calling service for every record. This will hit governor limits for dataloads of more than 100 records. 
 // Once dynamo is updated to take list of Accounts as input, Changes need to be made to this method.    	
    public static void updateAccountToDynamo(Map<Id,Account> newAcctMap, Map<Id,Account> acctOldMap) {
        Account oldAccount = null;
        for(Account account : newAcctMap.values()){
            oldAccount = acctOldMap != null ? acctOldMap.get(account.Id) : null;
            if(AccountTriggerUtility.isAccountQualifiedToUpdateDynamo(oldAccount,account)){
                DynamoAccountBodyRequest dynamoBodyRequest = AccountTriggerUtility.getDynamoRequestBody(account);
                if(!String.isBlank(account.merchant_uuid__c)){
                	AccountTriggerUtility.performAccountUpdateCallout('merchants/'+account.merchant_uuid__c,JSON.serialize(dynamoBodyRequest));    
                }
            }
        }
    }
     
}