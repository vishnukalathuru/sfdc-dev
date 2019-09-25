/**
 * Created by sanjeev.karanwal on 2019-06-03.
 */

/**
 * @File Name          : PerformanceSummaryHelper
 * @Description        : This class contains helper methods for Performance Summary Object
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-03                    Initial Version
**/
public without sharing class PerformanceSummaryHelper {

    /*
     *   Name: createSummaryList
     *   Parameter name:
     *          summaryPostStr:  (String). This is the JSON string containing performance summary information
     *                            with merchant_uuid as unique identifier
     *   Description: This method takes the JSON String as input, parses the JSON and creates a list of Performance
     *                 Summary objects to be updated. This information comes from Dynamo. The JSON string will contain
     *                 information for all merchants
     *   Return Type: List<Performance_Summary__c>.   This is list of Performance_Summary__c objects created from the JSON
    */
    public static List<Performance_Summary__c> createSummaryList(String summaryPostStr) {

        System.debug('input string inside the createSummaryList is ' + summaryPostStr);
        List<Performance_Summary__c> psList = new List<Performance_Summary__c>();
        if (summaryPostStr != null && summaryPostStr != '') {
            // Deserialize the JSON string and parse it
            List<Object> summaryList = (List<Object>) JSON.deserializeUntyped(summaryPostStr);
            System.debug('Size of summaryList is ' + summaryList.size());
            if (summaryList != null) {
                for (Object varObj : summaryList) {
                    Map<String, Object> summaryMap = (Map<String, Object>) varObj;
                    String uuid;
                    Decimal financeVolumeYtd;
                    Decimal financeVolumeTtm;
                    Decimal financeVolumeLtd;
                    Integer fundedLoans30;
                    Integer fundedLoans60;
                    Integer fundedLoans90;
                    Integer fundedLoansLtd;
                    Decimal totalContractorFeesYtd;
                    Decimal totalContractorFeesTtm;
                    Decimal totalContractorFeesLtd;
                    Decimal averageContractorFeesLtd;
                    Decimal averageLoanSize;
                    Integer averageFicoOnApprovedLoansLtd;
                    Integer averageFicoOnFundedLoansLtd;
                    Decimal approvalRateLtd;
                    Decimal approvalRate90;
                    Decimal approvalRateTtm;
                    Integer lossesCount;
                    Decimal lossesInDollars;
                    Decimal lossRateCount;
                    Decimal lossRateInDollars;
                    Decimal dqRateLtd;
                    Integer NoNoCount;
                    Decimal NoNoInDollars;
                    DateTime dateOfLastApplication;
                    Date dateOfLastSubmission;

                    // Get the information corresponding to uuid
                    uuid = (String) summaryMap.get('uuid');
                    financeVolumeYtd = (Decimal) summaryMap.get('financeVolumeYtd');
                    financeVolumeTtm = (Decimal) summaryMap.get('financeVolumeTtm');
                    financeVolumeLtd = (Decimal) summaryMap.get('financeVolumeLtd');

                    fundedLoans30 = (Integer) summaryMap.get('fundedLoans30');
                    fundedLoans60 = (Integer) summaryMap.get('fundedLoans60');
                    fundedLoans90 = (Integer) summaryMap.get('fundedLoans90');
                    fundedLoansLtd = (Integer) summaryMap.get('fundedLoansLtd');

                    totalContractorFeesYtd = (Decimal) summaryMap.get('totalContractorFeesYtd');
                    totalContractorFeesTtm = (Decimal) summaryMap.get('totalContractorFeesTtm');
                    totalContractorFeesLtd = (Decimal) summaryMap.get('totalContractorFeesLtd');
                    averageContractorFeesLtd = (Decimal) summaryMap.get('averageContractorFeesLtd');


                    averageLoanSize = (Decimal) summaryMap.get('averageLoanSize');

                    averageFicoOnApprovedLoansLtd = (Integer) summaryMap.get('averageFicoOnApprovedLoansLtd');
                    averageFicoOnFundedLoansLtd = (Integer) summaryMap.get('averageFicoOnFundedLoansLtd');

                    approvalRateLtd = (Decimal) summaryMap.get('approvalRateLtd');
                    approvalRate90 = (Decimal) summaryMap.get('approvalRate90');
                    approvalRateTtm = (Decimal) summaryMap.get('approvalRateTtm');

                    lossesCount = (Integer) summaryMap.get('lossesCount');
                    lossesInDollars = (Decimal) summaryMap.get('lossesInDollars');
                    lossRateCount = (Decimal) summaryMap.get('lossRateCount');
                    lossRateInDollars = (Decimal) summaryMap.get('lossRateInDollars');

                    dqRateLtd = (Decimal) summaryMap.get('dqRateLtd');

                    NoNoCount = (Integer) summaryMap.get('6MNoNoCount');
                    NoNoInDollars = (Decimal) summaryMap.get('6MNoNoInDollars');
                    String dateTimeStr = (String) summaryMap.get('dateOfLastApplication');
                    // The information is in date time format (eg 2019-05-31T18:26:38.564Z). Convert it into Date format.
                    // (2019-05-31)
                    if(dateTimeStr != null && dateTimeStr != '') {
                        String dateStr =  dateTimeStr.left(10);
                        dateOfLastSubmission =  Date.valueOf(dateStr);
                    }

                    if (uuid != null) {
                        Performance_Summary__c varPS = new Performance_Summary__c();
                        System.debug('uuid inside loop is ' + uuid);
                        varPS.Merchant_UUID__c = uuid;
                        varPS.Finance_Volume_YTD__c = financeVolumeYtd;
                        varPS.Finance_Volume_TTM__c = financeVolumeTtm;
                        varPS.Finance_Volume_LTD__c = financeVolumeLtd;
                        varPS.Funded_Loans_30__c = fundedLoans30;
                        varPS.Funded_Loans_60__c = fundedLoans60;
                        varPS.Funded_Loans_90__c = fundedLoans90;
                        varPS.Funded_Loans_LTD__c = fundedLoansLtd;
                        varPS.Total_Contractor_Fees_LTD__c = totalContractorFeesLtd;
                        varPS.Total_Contractor_Fees_TTM__c = totalContractorFeesTtm;
                        varPS.Total_Contractor_Fees_YTD__c = totalContractorFeesYtd;
                        varPS.Average_Contractor_Fees_LTD__c = averageContractorFeesLtd;
                        varPS.Average_Loan_Size__c = averageLoanSize;
                        varPS.Average_FICO_on_Approved_Loans_LTD__c = averageFicoOnApprovedLoansLtd;
                        varPS.Average_FICO_on_Funded_Loans_LTD__c = averageFicoOnFundedLoansLtd;
                        // percentage values are received as decimals from Dynamo. Convert them into percentages
                        if (approvalRate90 != null) varPS.Approval_Rate_90__c = approvalRate90 * 100;
                        if (approvalRateLtd != null) varPS.Approval_Rate_LTD__c = approvalRateLtd * 100;
                        if (approvalRateTtm != null) varPS.Approval_Rate_TTM__c = approvalRateTtm * 100;

                        if (lossRateCount != null) varPS.Loss_Rate__c = lossRateCount * 100;
                        if (lossRateInDollars != null) varPS.Loss_Rate_Vol__c = lossRateInDollars * 100;
                        varPS.Losses__c = lossesCount;
                        varPS.Losses_Vol__c = lossesInDollars;
                        if (dqRateLtd != null) varPS.DQ_Rate_LTD__c = dqRateLtd * 100;
                        varPS.No_No__c = NoNoCount;
                        varPS.No_No_Vol__c = NoNoInDollars;
                        varPS.Date_of_Last_Submission__c = dateOfLastSubmission;

                        psList.add(varPS);
                    } else {
                        util.insertErrorLog('PerformanceSummaryHelper','createSummaryList','Merchant id is empty');
                        System.debug('Merchant id is empty');
                    }
                }
            }
        }
        return psList;
    }



    /*
     *   Name: upsertSummaryObject
     *   Parameter name:
     *          psList:  (List<Performance_Summary__c>). This is the list of Performance_Summary__c objects which has to be updated
     *   Description: This method takes the list of Performance_Summary__c objects as input, associates the performance_summary_object__c
     *                 with account id correspondng to the merchant_uuid__c and updates the list.
     *   Return Type: None
    */
    public static void upsertSummaryObject(List<Performance_Summary__c> psList) {
        // Use Merchant_UUID__c as external id for upsert.
        Schema.DescribeFieldResult F = Performance_Summary__c.Merchant_UUID__c.getDescribe();
        Schema.SObjectField uuidExternalField = F.getSobjectField();

        //Create a set of Merchant UUIDs
        Set<String> merchantIdSet = new Set<String>();
        for(Performance_Summary__c varPS : psList ) {
            if(varPS.Merchant_UUID__c != null) merchantIdSet.add(varPS.Merchant_UUID__c);
            System.debug('Before inserting the list the merchant uuid is ' + varPS.Merchant_UUID__c);
        }

        // Get a list of all accounts for the merchant ids present in the above set. Create a map with merchant uuid as key and account id as value
        Map<String,String> uuidMap = new Map<String,String>();
        List<Account> acctList = [select Id, merchant_uuid__c from Account where merchant_uuid__c IN :merchantIdSet];
        for(Account varAcct : acctList) {
            if(varAcct.merchant_uuid__c != null) uuidMap.put(varAcct.merchant_uuid__c,varAcct.Id);
        }

        for(Performance_Summary__c varPS1 : psList ) {
            if(uuidMap.get(varPS1.Merchant_UUID__c) != null) {
                // Associate the performance summary object with account id.
                varPS1.Account_Name__c = uuidMap.get(varPS1.Merchant_UUID__c);
               // psListToUpdate.add(varPS1);
            }


        }


        // Perform upsert with Merchant_UUID__c as external field.
        Database.UpsertResult[] upResult = Database.upsert(psList,uuidExternalField,false);
        for(Database.UpsertResult usRes : upResult) {
            if(!usRes.isSuccess()) {
                String errorMessage = 'Error occured while updating the summary object. Error message is:  ' + usRes.getErrors()[0].getMessage() +
                        ' Fields effected are ' + usRes.getErrors()[0].getFields();
                System.debug(errorMessage);
                util.insertErrorLog('PerformanceSummaryHelper','upsertSummaryObject',errorMessage);
            }
        }
    }


    /*
     *   Name: performSummaryCallout
     *   Parameter name: None
     *   Description: This method calls the Get callout using Callout Helper and passes the merchant stats url as parameter. It calls the createSummaryList method
     *                with the response from Get callout as input and then calls upsertSummaryObject method passing the List of Performance Summary objects.
     *                 with account id correspondng to the merchant_uuid__c and updates the list.
     *   Return Type: None
    */

    public static void performSummaryCallout() {
        String perfSumUrl = 'merchants/stats';
        String response;
        try {
            response = CalloutHelper.performGetCallout(perfSumUrl);
            System.debug('response from endpoint is ' + response);
            /*
            response = '[{"uuid":"merchant_qa_85deeded-28d3-4f2f-a83e-8758e75bcf5a","financeVolumeYtd": 567890234.45,"financeVolumeTtm": 12342235.56,' +
                    '"financeVolumeLtd": 876422223.76,"fundedLoans30": 1235,"fundedLoans60": 23455,"fundedLoans90": 98723,"fundedLoansLtd": 92821,' +
                    '"dateOfLastApplication": "2019-05-31T18:26:38.564Z","totalContractorFeesYtd": 76534.23,"totalContractorFeesTtm": 827365.45,' +
                    '"totalContractorFeesLtd": 9383435.23,"averageContractorFeesLtd": 983737.45,"averageLoanSize": 93874445.34,"averageFicoOnApprovedLoansLtd": 771,' +
                    '"averageFicoOnFundedLoansLtd": 851,"approvalRateLtd": 0.02,"approvalRate90": 0.02,"approvalRateTtm": 0.02,"lossesCount": 9877,' +
                    '"lossesInDollars": 938335.34,"lossRateCount": 0.02,"lossRateInDollars": 0.02,"dqRateLtd": 0.02,"6MNoNoCount": 26,"6MNoNoInDollars": 43},{' +
                    '"uuid":"merchant_qa_feaac2dd-9133-461d-b29b-73722af90504","financeVolumeYtd": 567890235.45,"financeVolumeTtm": 12342235.56}]';
             */
            List<Performance_Summary__c> psList = createSummaryList(response);
            upsertSummaryObject(psList);
        } catch (CalloutException ce) {
            String errorMessage = 'Exception occured during callout ' + ce.getMessage() + ' \n stack trace is ' + ce.getStackTraceString();
            System.debug(errorMessage);
            util.insertErrorLog('PerformanceSummaryHelper','upsertSummaryObject',errorMessage);

        } catch (Exception ex) {
            String errorMessage1 = 'Exception occured during callout ' + ex.getMessage() + ' \n stack trace is ' + ex.getStackTraceString();
            System.debug(errorMessage1);
            util.insertErrorLog('PerformanceSummaryHelper','upsertSummaryObject',errorMessage1);
        }
    }

}