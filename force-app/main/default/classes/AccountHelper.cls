/**
 * @File Name          : AccountHelper
 * @Description        : This class contains Helper method for Account object
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : Sanjeev Karanwal
 * @Last Modified On   : 6/17/2019, 10:26:09 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-05-31                    Initial Version
**/
public with sharing class AccountHelper {

    /* Name: performAccountUpdateCallout
     * Parameter name:
     *          acctURL (String). URL to make callout to dynamo excluding the base url
     *          acctPutReq (String) The put request to be sent as part of the callout to dynamo
     * Description: This method makes the put callout to dynamo to update the Account attributes.
     * Return Type: None
     */

    @future(callout=true)
    public static void performAccountUpdateCallout(String acctURL, String acctPutReq) {
        try {
            String response = CalloutHelper.performPutCallout(acctURL, acctPutReq);
            String message = 'Response is ' + response;
            Util.insertErrorLog('AccountHelper','performAccountUpdateCallout',message);

        } catch (CalloutException ce) {
            String errorMessage = 'Exception occured during account update callout ' + ce.getMessage() + ' \n stack trace is ' + ce.getStackTraceString();
            System.debug(errorMessage);
            Util.insertErrorLog('AccountHelper','performAccountUpdateCallout',errorMessage);

        } catch (Exception ex) {
            String errorMessage1 = 'Exception occured after updating the account ' + ex.getMessage() + ' \n stack trace is ' + ex.getStackTraceString();
            System.debug(errorMessage1);
            Util.insertErrorLog('AccountHelper','performAccountUpdateCallout',errorMessage1);
        }
    }


    /* Name: updateAccountToDynamo
     * Parameter name:
     *          newAcctLst (List<Account>). List of accounts with the new values
     *          acctOldMap (Map<Id,Account>) Map with key as Id and Value as Account object containing the old values (values before the account is updated).
     * Description: This method takes the list of Accounts with new values and Map of accounts with old values (key is Id and value is Account Object). It then compares the old values
     *              with new values to perform the callout when atleast one of the values are changed.
     * Return Type: (String)   state name
     */





   public static void updateAccountToDynamo(List<Account> newAcctLst, Map<Id,Account> acctOldMap) {
       System.debug('Inside updateAccountToDynamo');
       System.debug('The size of Account List is ' + newAcctLst.size());
       // This method is not bulkified and as such should be used only for one record at a time. Once dynamo is updated to take list of Accounts as input,
       // bulkify this method
       if(newAcctLst.size() < 2) {
           Account varAcct = newAcctLst[0];
           System.debug('Account is ' + varAcct);
           // Check whether one of the values have been changed
           if(
                   (varAcct.Name != acctOldMap.get(varAcct.Id).Name)  ||
                   (varAcct.TaxID__c != acctOldMap.get(varAcct.Id).TaxID__c)  ||
                   (varAcct.BillingStreet != acctOldMap.get(varAcct.Id).BillingStreet)  ||
                   (varAcct.BillingState != acctOldMap.get(varAcct.Id).BillingState)  ||
                   (varAcct.BillingCity != acctOldMap.get(varAcct.Id).BillingCity)  ||
                   (varAcct.BillingPostalCode != acctOldMap.get(varAcct.Id).BillingPostalCode)  ||
                   (varAcct.ShippingStreet != acctOldMap.get(varAcct.Id).ShippingStreet)  ||
                   (varAcct.ShippingState != acctOldMap.get(varAcct.Id).ShippingState)  ||
                   (varAcct.ShippingCity != acctOldMap.get(varAcct.Id).ShippingCity)  ||
                   (varAcct.ShippingPostalCode != acctOldMap.get(varAcct.Id).ShippingPostalCode)  ||
                   (varAcct.Business_License__c != acctOldMap.get(varAcct.Id).Business_License__c)  ||
                   (varAcct.Contractor_License__c != acctOldMap.get(varAcct.Id).Contractor_License__c)  ||
                   (varAcct.Doing_Business_As__c != acctOldMap.get(varAcct.Id).Doing_Business_As__c)  ||
                   (varAcct.In_Business_Since__c != acctOldMap.get(varAcct.Id).In_Business_Since__c)  ||
                   (varAcct.Business_Structure__c != acctOldMap.get(varAcct.Id).Business_Structure__c)  ||
                   (varAcct.Main_Service__c != acctOldMap.get(varAcct.Id).Main_Service__c)  ||
                   (varAcct.Website != acctOldMap.get(varAcct.Id).Website)  ||
                   (varAcct.AnnualRevenue != acctOldMap.get(varAcct.Id).AnnualRevenue)  ||
                   (varAcct.Annual_Consumer_Finance_Volume__c != acctOldMap.get(varAcct.Id).Annual_Consumer_Finance_Volume__c)  ||
                   (varAcct.Bank_Account_Number__c != acctOldMap.get(varAcct.Id).Bank_Account_Number__c)  ||
                   (varAcct.Bank_Routing_Number__c != acctOldMap.get(varAcct.Id).Bank_Routing_Number__c)  ||
                   (varAcct.phone != acctOldMap.get(varAcct.Id).Phone) || 
                   (varAcct.Active__c != acctOldMap.get(varAcct.Id).Active__c) ||
                   (varAcct.Dynamo_Status__c != acctOldMap.get(varAcct.Id).Dynamo_Status__c)
             ) {
                   
               String billingState = Util.changeStateToAbbrev(varAcct.BillingState);

               String shippingState = Util.changeStateToAbbrev(varAcct.ShippingState);


// Create the PUT response for sending update information to dynamo. merchant_uuid is unique identifier in dynamo
               Integer ibsmonth;
               Integer ibsday;
               Integer ibsyear;
               if(varAcct.In_Business_Since__c != null) {
                   ibsmonth = varAcct.In_Business_Since__c.month();
                   ibsday = varAcct.In_Business_Since__c.day();
                   ibsyear = varAcct.In_Business_Since__c.year();
               }

               //if(varAcct.AnnualRevenue == null) varAcct.AnnualRevenue = 0.0;
               //if(varAcct.Annual_Consumer_Finance_Volume__c == null) varAcct.Annual_Consumer_Finance_Volume__c = 0.0;
               String accountPutBody = '{  "bankInformation": { "accountNumber": "' + varAcct.Bank_Account_Number__c + '", "routingNumber": "' + varAcct.Bank_Routing_Number__c + '"},'
                       + '"businessInformation": { "website": "' + varAcct.Website + '","federalTaxId": "' + varAcct.TaxID__c + '","contractorLicenseNumber": "' + varAcct.Contractor_License__c + '","businessStructure": "'
                       + varAcct.Business_Structure__c + '","mailingAddress": {"zip": "' + varAcct.BillingPostalCode + '","state": "' + Util.changeStateToAbbrev(shippingState) + '","city": "' + varAcct.ShippingCity
                       + '","street": "' + varAcct.ShippingStreet + '"},"physicalAddress": { "zip": "' + varAcct.BillingPostalCode + '","state": "' + Util.changeStateToAbbrev(billingState) + '","city": "'
                       + varAcct.BillingCity + '","street": "' + varAcct.BillingStreet + '"}, "legalBusinessName": "' + varAcct.Name + '","businessLicenseNumber": "'
                       + varAcct.Business_License__c + '","typeOfServiceOrProductOffered": "' + varAcct.Main_Service__c + '", "allTradeNames": [ "'
                       + varAcct.Doing_Business_As__c + '"]';

               if(varAcct.phone != null) {
                accountPutBody = accountPutBody + ',"businessPhone":' + Util.replaceNonNumChars(varAcct.phone) ;
               }
               
               if(varAcct.AnnualRevenue != null) {
                 accountPutBody = accountPutBody + ',"annualSalesRevenue":' + varAcct.AnnualRevenue ;
               }
               if(varAcct.Annual_Consumer_Finance_Volume__c != null) {
                   accountPutBody = accountPutBody + ',"annualConsumerFinanceVolume":' + varAcct.Annual_Consumer_Finance_Volume__c ;
               }

               if(varAcct.In_Business_Since__c != null) {
                   accountPutBody = accountPutBody + ',"inBusinessSince": { "month": ' + ibsmonth  + ',"year": ' + ibsyear + ',"day": ' + ibsday + '} ';
               }

               
               accountPutBody = accountPutBody + '},"isActive":' + varAcct.Active__c +  ',"status":"' + varAcct.Dynamo_Status__c + '"' + ',"uuid": "' + varAcct.merchant_uuid__c + '","merchantId":' + varAcct.Merchant_ID__c + '}' ;

               
               

               System.debug('The put request is ' + accountPutBody);

               if (varAcct.merchant_uuid__c != null && varAcct.merchant_uuid__c != '') {
                   String accountURL = 'merchants/' + varAcct.merchant_uuid__c;
                   performAccountUpdateCallout(accountURL, accountPutBody);
               } else {
                   System.debug('Merchant uuid is not provided');
                   Util.insertErrorLog('AccountHelper','updateAccountToDynamo','Merchant uuid is not provided');
               }
           }
       } else {

           System.debug('Mass updates of Accounts can not be sent to dynamo');
           Util.insertErrorLog('AccountHelper','updateAccountToDynamo','Mass updates of Accounts can not be sent to dynamo');
       }
   }



}