/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : LeadHelperTest
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
@isTest
public with sharing class LeadHelperTest {

    @isTest
    public static void testDuplicateLead(){
        Lead newLead = new Lead();
        newLead.FirstName = 'First1';
        newLead.LastName = 'Last1';
        newLead.Email = 'abc@def.com';
        newLead.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead.Status = 'Unassigned';
        newLead.Company = 'ABCcorp';
        newLead.Phone = '1112223333';
        newLead.Merchant_Id__c = '12345';
        insert newLead;

        Lead newLead1 = new Lead();
        newLead1.FirstName = 'First1';
        newLead1.LastName = 'Last1';
        newLead1.Email = 'abc@def.com';
        newLead1.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead1.Status = 'Unassigned';
        newLead1.Company = 'ABCcorp';
        newLead1.Phone = '1112223333';
        newLead1.Merchant_Id__c = '12345';
        boolean dupLead = LeadHelper.isDuplicateLead(newLead1);
        System.assertEquals(true,dupLead);


    }

    @isTest
    public static void testCreateLeadAndURL() {
        Lead newLead1 = new Lead();
        newLead1.FirstName = 'First2';
        newLead1.LastName = 'Last2';
        newLead1.Email = 'abc@def1.com';
        newLead1.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead1.Status = 'Unassigned';
        newLead1.Company = 'ABCcorp1';
        newLead1.Phone = '1112223334';
        newLead1.Merchant_Id__c = '123456';
        Leadhelper.createLead(newLead1);
        System.assertNotEquals(null, newLead1.Id);


        Lead newLead = new Lead();
        newLead.FirstName = 'Fsome1';
        newLead.LastName = 'LSome1';
        newLead.Email = 'abcnoneqer@def.com';
        newLead.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead.Status = 'Unassigned';
        newLead.Company = 'ABCcorp235322';
        newLead.Phone = '1112224433';
        //newLead.Merchant_Id__c = '12345';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockURLResponseGen());
        insert newLead;
        Test.stopTest();
        //System.assertNotEquals(newLead.Application_URL__c,null);
    }

    @isTest
    public static void testPerformLeadConverion() {

        Lead newLead = new Lead();
        newLead.FirstName = 'First1';
        newLead.LastName = 'Last1';
        newLead.Email = 'abc@def.com';
        newLead.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead.Status = 'Unassigned';
        newLead.Company = 'ABCcorp';
        newLead.Phone = '1112223333';
        newLead.Merchant_Id__c = '12345';

        String appMerchantId = '12345';
        String appMerchantUUID = 'xyzabc12345';
        boolean appIsActive = true;
        String federalTaxId = 'fed12345';
        String physicalStreet = '123 woodward st';
        String physicalCity = 'La la land';
        String physicalState = 'MI';
        String physicalZip = '44222';
        String physicalCountry = 'United States';
        String mailingStreet = '234 cass ave';
        String mailingCity = 'Detroit';
        String mailingState = 'MI';
        String mailingZip = '22333';
        String mailingCountry = 'United States';
        String businessLicense = 'bislic12345';
        String contractorLicense = 'conlic12345';
        String doingBusinessAs = 'Contractor1';
        Date inBusinessSince = Date.newInstance(2002,05,04);
        String businessStructure = 'Partnership';
        String mainService = 'Lighting';
        String website = 'www.abc.com';
        Decimal annualSalesRevenue = 12345.68;
        Decimal annualConsumerFinRev = 23456.79;
        String bankAcctNumber = '123456780';
        String bankRoutingNbr  = '23456780';
        String appIPAddress = '125.87.98.12';
        String appBusName = 'Test Account ABC';
        List<Contact> contactLst = new List<Contact>();
        Contact con1 = new Contact();
        con1.lastName = 'Last1';
        con1.Owner__c = true;
        con1.firstName = 'First1';
        con1.Email = 'abc@def.com';
        con1.Birthdate = Date.newInstance(2001,06,06);
        con1.Owner_Since__c = Date.newInstance(2015,01,01);
        con1.Primary_Contact__c = true;
        con1.IsApplicant__c = true;
        con1.MailingState = 'Michigan';
        Contact con2 = new Contact();
        con2.lastName = 'Last2';
        con2.Contact_Type__c = 'MID';
        con2.Owner__c = true;
        Contact con3 = new Contact();
        con3.lastName = 'Last3';
        con3.Owner__c = true;
        contactLst.add(con1);
        contactLst.add(con2);
        contactLst.add(con3);
        LeadHelper.performLeadConverion(newLead,appMerchantUUID,appMerchantId,appIsActive,federalTaxId,physicalStreet,
        physicalCity,physicalState, physicalZip, physicalCountry,
        mailingStreet,mailingCity,mailingState, mailingZip,
        mailingCountry,businessLicense,contractorLicense,doingBusinessAs,
        inBusinessSince,businessStructure,mainService,
        website,annualSalesRevenue,annualConsumerFinRev,
        bankAcctNumber,bankRoutingNbr,contactLst,appIPAddress,appBusName);


        Lead newLead1 = new Lead();
        newLead1.FirstName = 'John1';
        newLead1.LastName = 'Doe1';
        newLead1.Email = 'John.Doe@def.com';
        newLead1.Title_With_Company__c = 'contractor';
        // newLead.Owner__c = appIsOwner;
        // newLead.hasSignAuth__c = appIsSignAuth;
        newLead1.Status = 'Unassigned';
        newLead1.Company = 'XYZComp';
        newLead1.Phone = '7772223333';
        newLead1.Merchant_Id__c = '11111';
        insert newLead1;
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
        acct.Merchant_ID__c = '11111';
        acct.IP_Address__c = '125.87.98.12';
        
        insert acct;

        try{
            LeadHelper.performLeadConverion(newLead1,'222222','11111',appIsActive,federalTaxId,physicalStreet,
                    physicalCity,physicalState, physicalZip, physicalCountry,
                    mailingStreet,mailingCity,mailingState, mailingZip,
                    mailingCountry,businessLicense,contractorLicense,doingBusinessAs,
                    inBusinessSince,'somestr','General',
                    website,annualSalesRevenue,annualConsumerFinRev,
                    bankAcctNumber,bankRoutingNbr,contactLst,appIPAddress,'ABCCorp');
        } catch (DMLException ex) {
            System.assertNotEquals(null, ex);
        }



    }

}