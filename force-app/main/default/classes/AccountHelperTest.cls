/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : AccountHelperTest
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
@IsTest
public with sharing class AccountHelperTest {
    @IsTest
    public static void testUpdateAccountToDynamo() {
        Account acct = new Account();
        acct.name = 'ABCCorp';
        acct.TaxID__c = 'fedtax1234';
        acct.BillingStreet='100 woodward st';
        acct.BillingCity = 'Detroit';
        acct.BillingState = 'Michigan';
        acct.BillingPostalCode = '48448';
        acct.ShippingStreet = '200 Park Ave';
        acct.ShippingState = 'Ohio';
        acct.ShippingPostalCode = '23423';
        acct.ShippingCity = 'Dayton';
        acct.Business_License__c = 'BisLic1234';
        acct.Contractor_License__c = 'ConLic1234';
        acct.Doing_Business_As__c = 'Contractor';
        acct.In_Business_Since__c = Date.newInstance(2002,05,05);
        acct.Business_Structure__c = 'LLC';
        acct.Main_Service__c = 'Landscaping';
        acct.Website = 'www.google.com';
        acct.AnnualRevenue = 12345.67;
        acct.Annual_Consumer_Finance_Volume__c = 23456.78;
        acct.Bank_Account_Number__c = '123456789';
        acct.Bank_Routing_Number__c = '23456789';
        acct.Phone = '1111111111';
        acct.merchant_uuid__c = '222222';
        acct.Merchant_ID__c = '99';
        insert acct;

        Account acct1 = [select Id, Name, TaxID__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,ShippingStreet,ShippingState,
                ShippingPostalCode, ShippingCity,Business_License__c, Contractor_License__c,Doing_Business_As__c, In_Business_Since__c,
                Business_Structure__c,Main_Service__c,Website,AnnualRevenue, Annual_Consumer_Finance_Volume__c, Bank_Account_Number__c,
                Bank_Routing_Number__c,Phone, merchant_uuid__c, Merchant_ID__c from Account where Merchant_ID__c = '99'];
        Map<Id,Account> oldAccountMap = new Map<Id,Account>([select Id, Name, TaxID__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,ShippingStreet,ShippingState,
        ShippingPostalCode, ShippingCity,Business_License__c, Contractor_License__c,Doing_Business_As__c, In_Business_Since__c,
        Business_Structure__c,Main_Service__c,Website,AnnualRevenue, Annual_Consumer_Finance_Volume__c, Bank_Account_Number__c,
        Bank_Routing_Number__c,Phone, merchant_uuid__c, Merchant_ID__c from Account where Merchant_ID__c = '99']);

        /*
        acct1.TaxID__c = 'fedtax5678';
        acct1.name = 'ABCCorp';
        acct1.TaxID__c = 'fedtax12341';
        acct1.BillingStreet='100 woodward st1';
        acct1.BillingCity = 'Royal Oak';
        acct1.BillingState = 'Colorado';
        acct1.BillingPostalCode = '48449';
        acct1.ShippingStreet = '200 Park Ave1';
        acct1.ShippingState = 'Utah';
        acct1.ShippingPostalCode = '23421';
        acct1.ShippingCity = 'Dayton1';
        acct1.Business_License__c = 'BisLic12341';
        acct1.Contractor_License__c = 'ConLic12341';
        acct1.Doing_Business_As__c = 'Contractor1';
        acct1.In_Business_Since__c = Date.newInstance(2002,05,04);
        acct1.Business_Structure__c = 'Partnership';
        acct1.Main_Service__c = 'Lighting';
        acct1.Website = 'www.google1.com';
        acct1.AnnualRevenue = 12345.68;
        acct1.Annual_Consumer_Finance_Volume__c = 23456.79;
        acct1.Bank_Account_Number__c = '123456780';
        acct1.Bank_Routing_Number__c = '23456780';
        */

        acct1.Phone = '1111111112';
        update acct1;

    }

    @IsTest
    public static void testPerformAccountUpdateCallout() {

    }

}