/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : CaseHelperTest
 * @Description        : 
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-11
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-11                    Initial Version
**/
@istest
public with sharing class CaseHelperTest {

    @isTest
    public static void testInsertClientInfoForLoan() {
        Account acct = new Account();
        acct.merchant_uuid__c = 'Meruu1234';
        acct.name = 'ABCCorp';
        acct.AccountNumber = 'lonuu987654333';
        insert acct;

        Account acct1 = [select Id from account where merchant_uuid__c = 'Meruu1234'];
        Case case1 = new Case();
        case1.AccountId = acct1.Id;
        case1.account__c = 'lonuu987654333';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLoanResponseGenerator());
        insert case1;
        Test.stopTest();
    }
  }