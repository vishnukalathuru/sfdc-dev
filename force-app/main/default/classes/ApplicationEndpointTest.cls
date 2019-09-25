/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : ApplicationEndpointTest
 * @Description        : 
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-11
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-06-11                    Initial Version
**/
@isTest
public with sharing class ApplicationEndpointTest {

    @isTest
    public static void testCreateApplicationStart() {
    String jsonStrAppStarted = '{"topic":"MERCHANT_APPLICATION_STARTED","resource":{"bankInformation":{"accountNumber":"123456789","routingNumber":"123456789"},"createdAt":"2019-06-03T14:55:34.011Z",' +
          '"disclosures":{"merchant-application-disclosures":{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom","lastName":"Wash","timestamp":"2019-06-03T14:55:34.264Z"},"merchant-guidebook"' +
            ':{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom","lastName":"Wash","timestamp":"2019-06-03T14:55:34.265Z"},"merchant-loan-technology-program-agreement":{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom",' +
        '"lastName":"Wash","timestamp":"2019-06-03T14:55:34.265Z"}},"businessInformation":{"website":"tomwash.com","federalTaxId":"123456789","annualConsumerFinanceVolume":50000,"contractorLicenseNumber":"123456789",' +
            '"mailingAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"},"businessStructure":"S-Corporation",' +
            '"physicalAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"},"legalBusinessName":"Toms Merchant",' +
            '"businessLicenseNumber":"123456789","businessPhone":2486573019,"typeOfServiceOrProductOffered":"Appliance Service and Repair","primaryContactForFinancingInformation":{"name":"Tom Wash",' +
            '"email":"tomwash@rocketloans.com"},"allTradeNames":["WIndows"],"annualSalesRevenue":50000,"inBusinessSince":{"month":7,"day":29,"year":1988}},' +
            '"isActive":false,"owners":[{"disclosure":{"name":"owner-authorization","signed":true},"ownerSince":{"month":7,"day":29,"year":1988},' +
            '"personalInformation":{"firstName":"Tom","lastName":"Wash","dateOfBirth":{"month":7,"day":29,"year":1988},"mobileNumber":2486573019,"socialSecurityNumber":777713205,"email":"tomwash@rocketloans.com"},'
            + '"ownershipPercentage":100,"residentialAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"}}],' +
            '"updatedAt":"2019-06-03T14:55:34.265Z","uuid":"merchant_qa-cl_5f3508cc-0270-466d-881e-92e4659332af","applicantInformation":{"titleWithCompany"' +
            ':"software engineer","authorityToBindCompany":true,"firstName":"Tom","lastName":"Wash","isOwner":true,"email":"tomwash@rocketloans.com"},"merchantId":8}}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/v1/Application/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonStrAppStarted);
        RestContext.request = req;
        RestContext.response= res;
        ApplicationEndpoint.createApplication();
        Test.stopTest();
    }

    @isTest
    public static void testCreateApplicationComp(){
        String jsonStrAppComp = '{"topic":"MERCHANT_APPLICATION_PENDING_DECISION","resource":{"bankInformation":{"accountNumber":"123456789","routingNumber":"123456789"},"createdAt":"2019-06-03T14:55:34.011Z",' +
                '"disclosures":{"merchant-application-disclosures":{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom","lastName":"Wash","timestamp":"2019-06-03T14:55:34.264Z"},"merchant-guidebook"' +
                ':{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom","lastName":"Wash","timestamp":"2019-06-03T14:55:34.265Z"},"merchant-loan-technology-program-agreement":{"ipAddress":"12.165.188.171","signed":true,"firstName":"Tom",' +
                '"lastName":"Wash","timestamp":"2019-06-03T14:55:34.265Z"}},"businessInformation":{"website":"tomwash.com","federalTaxId":"123456789","annualConsumerFinanceVolume":50000,"contractorLicenseNumber":"123456789",' +
                '"mailingAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"},"businessStructure":"S-Corporation",' +
                '"physicalAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"},"legalBusinessName":"Toms Merchant",' +
                '"businessLicenseNumber":"123456789","businessPhone":2486573019,"typeOfServiceOrProductOffered":"Appliance Service and Repair","primaryContactForFinancingInformation":{"name":"Tom Wash",' +
                '"email":"tomwash@rocketloans.com"},"allTradeNames":["WIndows"],"annualSalesRevenue":50000,"inBusinessSince":{"month":7,"day":29,"year":1988}},' +
                '"isActive":false,"owners":[{"disclosure":{"name":"owner-authorization","signed":true},"ownerSince":{"month":7,"day":29,"year":1988},' +
                '"personalInformation":{"firstName":"Tom","lastName":"Wash","dateOfBirth":{"month":7,"day":29,"year":1988},"mobileNumber":2486573019,"socialSecurityNumber":"777713205","email":"tomwash@rocketloans.com"},'
                + '"ownershipPercentage":100,"residentialAddress":{"zip":"48226","state":"MI","city":"Detroit","street":"28 Grand River Ave"}}],' +
                '"updatedAt":"2019-06-03T14:55:34.265Z","uuid":"merchant_qa-cl_5f3508cc-0270-466d-881e-92e4659332af","applicantInformation":{"titleWithCompany"' +
                ':"software engineer","authorityToBindCompany":true,"firstName":"Tom","lastName":"Wash","isOwner":true,"email":"tomwash@rocketloans.com"},"merchantId":8}}';

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
        newLead1.Merchant_Id__c = '8';
        insert newLead1;
        Test.startTest();
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/v1/Application/';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(jsonStrAppComp);
        RestContext.request = req1;
        RestContext.response= res1;
        ApplicationEndpoint.createApplication();
        Test.stopTest();
    }

}