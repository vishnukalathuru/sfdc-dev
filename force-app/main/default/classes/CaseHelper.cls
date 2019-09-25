/**
 * Created by sanjeev.karanwal on 2019-05-28.
 */

/**
 * @File Name          : CaseHelper
 * @Description        : This class contains helper methods for case object.
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-05-28
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-05-28                    Initial Version
**/
public without sharing class CaseHelper {

    /*
     *   Name: insertClientInfoForLoan
     *   Parameter name:
     *          newCase:  (Case). This is the current case object.
     *   Description: This method takes the current case object as input parameter and calls the performLoanCallout
     *   Return Type: None
    */

    public static void insertClientInfoForLoan(Case newCase) {
        String loanId = newCase.account__c;
        String case_id = newCase.Id;
        System.debug('loan id is ' + loanId);
        System.debug('case_id is ' + case_id);
        performLoanCallout(loanId, case_id);
    }


    /*
     *   Name: performLoanCallout
     *   Parameter name:
     *          loanId:  (String). This is the loan number associated with the case object. Also called as account #
     *          case_id: (String). This is the id of the current case object.
     *   Description: This method is used to make a Get callout to dynamo and obtain the loan information corresponding to the
     *                loan number. This information is then updated on the case object.
     *                PLEASE NOTE THAT THIS METHOD IS NOT BULKIFIED AS THIS IS SUPPOSED TO BE INVOKED FOR ONE CASE OBJECT AT A TIME.
     *                CREATE A SEPARATE METHOD FOR BULKIFICATION IF THERE IS SUCH REQUIREMENT IN FUTURE
     *   Return Type: None
    */

    @future(callout=true)
    public static void performLoanCallout(String loanId, String case_id) {
           if(loanId != null && loanId != '') {
               String caseURL = 'cases/' + loanId;
               try {
                   String response = CalloutHelper.performGetCallout(caseURL);
/*
                   String response = '{ "Client": { "firstName" : "FName", "lastName" : "LName", "state" : "Michigan"},"Investor" : "PSC Eaglewood",' +
                           '"Merchant" : { "MerchantId" : "merch1234","MerchantUuid" : "Meruu1234"},"Salesperson":{ "SalespersonId": 12345,"SalespersonUuid":"salesuud7654"},"Servicing" : { "StatusCode" : 12345, "Status" : "60DPD" }, ' +
                           ' "Loan" : { "loanId" : 98765, "loanUuid" : "lonuu987654333"}} ';

*/
                   System.debug('response is ' + response);
                   Map<String,Object> loanMap = (Map<String,Object>)JSON.deserializeUntyped(response);
                   Map<String,Object> clientInfo = (Map<String,Object>)loanMap.get('Client');
                   String firstNameStr = (String)clientInfo.get('firstName');
                   String lastNameStr = (String)clientInfo.get('lastName');
                   String stateStr = (String)clientInfo.get('state');
                   String InvestorStr = (String) loanMap.get('Investor');
                   Map<String,Object> merchantInfo = (Map<String,Object>)loanMap.get('Merchant');
                   String merchantIdStr = (String)merchantInfo.get('MerchantId');
                   String merchantUUIDStr = (String)merchantInfo.get('MerchantUuid');
                   Map<String,Object> salespersonInfo = (Map<String,Object>)loanMap.get('Salesperson');
                   Integer SalespersonStr = (Integer)salespersonInfo.get('SalespersonId');
                   String salespersonUuidStr = (String)salespersonInfo.get('SalespersonUuid');

                   Map<String,Object> servicingInfo = (Map<String,Object>)loanMap.get('Servicing');
                   Integer statuscodeStr = (Integer)servicingInfo.get('StatusCode');
                   String statusStr = (String)servicingInfo.get('Status');

                   Map<String,Object> loanInfo = (Map<String,Object>)loanMap.get('Loan');
                   Integer loanidStr = (Integer)loanInfo.get('loanId');
                   String loanuuidStr = (String)loanInfo.get('loanUuid');

                   System.debug('firstNameStr : ' + firstNameStr);
                   System.debug('lastNameStr : ' + lastNameStr);
                   System.debug('stateStr : ' + stateStr);
                   System.debug('InvestorStr : ' + InvestorStr);
                   System.debug('merchantIdStr : ' + merchantIdStr);
                   System.debug('merchantUUIDStr : ' + merchantUUIDStr);
                   System.debug('SalespersonStr : ' + SalespersonStr);
                   System.debug('salespersonUuidStr ' + salespersonUuidStr);
                   System.debug('statuscodeStr : ' + statuscodeStr);
                   System.debug('statusStr : ' + statusStr);
                   System.debug('loanidStr : ' + loanidStr);
                   System.debug('loanuuidStr : ' + loanuuidStr);

                   Case newCase = new Case();
                   newCase.Id = case_id;
                   newCase.Customer_First_Name__c = firstNameStr;
                   newCase.Customer_Last_Name__c = lastNameStr;
                   newCase.State_of_Residence__c = stateStr;
                   newCase.Investor__c = InvestorStr;
                   newCase.Loan_Delinquency_Status__c = statusStr;

                   try {
                       update newCase;
                   } catch (DmlException e) {
                       for (Integer i = 0; i < e.getNumDml(); i++) {

                           System.debug(e.getDmlMessage(i));
                       }
                   }
               } catch (CalloutException ce) {
                   String errorMessage = 'Exception occured during callout ' + ce.getMessage() + ' \n stack trace is ' + ce.getStackTraceString();
                   System.debug(errorMessage);
                   Util.insertErrorLog('CaseHelper','performLoanCallout',errorMessage);

               } catch (Exception ex) {
                   String errorMessage1 = 'Exception occured during callout ' + ex.getMessage() + ' \n stack trace is ' + ex.getStackTraceString();
                   System.debug(errorMessage1);
                   Util.insertErrorLog('CaseHelper','performLoanCallout',errorMessage1);
               }



           } else {
               System.debug('Account number is not provided');
               Util.insertErrorLog('CaseHelper','performLoanCallout','Account number is not provided');
           }
    }
}