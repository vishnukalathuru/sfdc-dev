/**
 * @File Name          : LeadHelper
 * @Description        : This class contains the helper methods for Lead object
 * @Author             : sanjeev.karanwal
 * @Group              :
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-05-17
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-05-17                    Initial Version
 **/
public without sharing class LeadHelper {
  /*
   *   Name: isDuplicateLead
   *   Parameter name:
   *          newLead:  (Lead). This is the current lead object.
   *   Description: This method takes the current lead object as input parameter and checks whether the lead already exists
   *                with the same information. The below fields are compared to checking duplicates
   *                a) First Name
   *                b) Last Name
   *                c) Email
   *                d) Phone
   *                e) Company
   *                f) Title With Company
   *   NOTE: THIS METHOD IS NOT BULKIFIED AS THERE IS NO REQUIREMENT AS OF NOW. IN CASE THE REQUIREMENT COMES IN FUTURE, PLEASE
   *          CREATE A SEPARATE METHOD FOR THE SAME.
   *   Return Type: Boolean.  This indicates whether the lead is a duplicate lead. True signifies duplicate lead.
   */

  public static Id sales_queue_id;
    
    
  public static boolean isDuplicateLead(Lead newLead) {
      List<Lead> leadList = [select Id FROM Lead WHERE FirstName =:newLead.FirstName AND LastName=:newLead.LastName AND Email=:newLead.Email AND Phone=:newLead.Phone AND Company=:newLead.Company AND Title_With_Company__c=:newLead.Title_With_Company__c ];  
      return leadList!= null&&leadList.size() > 0 ? true:false;   
  }

  /*
   *   Name: createLead
   *   Parameter name:
   *          newLead:  (Lead). This is the current lead object.
   *   Description: This method takes the current lead object as input parameter and checks whether the lead already exists
   *                with the same information. If this is not a duplicate lead, it upserts the lead in Salesforce with Merchant_Id__c
   *                as external ID
   *   NOTE: THIS METHOD IS NOT BULKIFIED AS THERE IS NO REQUIREMENT AS OF NOW. IN CASE THE REQUIREMENT COMES IN FUTURE, PLEASE
   *          CREATE A SEPARATE METHOD FOR THE SAME.
   *   Return Type: String.  This indicates the status code of upsert operation. If successful, a code of 200 is returned.
   *                         If unsuccessful, a code of 402 is returned along with error message if error occured during upsert.
   *                         It will return a code of 401 along with error message if it is a duplicate lead or lead is empty.
   *   The JSON will look like below for success
   *   {
   *       "success" : true,
   *       "code" : 200
   *       "message" : "successfully created lead"
   *       "lead Id" : <leadid>
   *   }
   *
   *   The JSON will look like below for failures
   *   {
   *       "success" : false,
   *       "code" : 401 or 402,
   *       "error" : {
   *           "message" : <errMessage>
   *        }
   *   }
   */
  public static void createLead(Lead newLead) {
      if (newLead != null) {
          try{
              insert newLead;
          }catch(Exception ex){
              system.debug('::::exception::::'+ex.getMessage());
          }
      }
  }
 /*
  public static String performLeadConverion(
    Lead newLead,
    String appMerchantUUID,
    String appMerchantId,
    boolean appIsActive,
    String federalTaxId,
    String physicalStreet,
    String physicalCity,
    String physicalState,
    String physicalZip,
    String physicalCountry,
    String mailingStreet,
    String mailingCity,
    String mailingState,
    String mailingZip,
    String mailingCountry,
    String businessLicense,
    String contractorLicense,
    String doingBusinessAs,
    Date inBusinessSince,
    String businessStructure,
    String mainService,
    String website,
    Decimal annualSalesRevenue,
    Decimal annualConsumerFinRev,
    String bankAcctNumber,
    String bankRoutingNbr,
    List<Contact> contactLst,
    String appIPAddress,
    String appBusName,
    String partnerUuid,
    String partnerName
  ) {
    //boolean appIsOwner;
    //boolean appIsSignAuth;
    String returnVal;
    //String appBusName;
    Id leadId;
    if (newLead != null && !newLead.IsConverted) {
      System.debug('newLead id is ' + newLead.Id);
      if (newLead.Id != null) {
        System.debug('Lead is created in Salesforce. Do not update');
        //update newLead;
      } else {
        if (newLead.Merchant_Id__c != null && newLead.Merchant_Id__c != '') {
          //Schema.SObjectField merchantIdField = Lead.Fields.Merchant_Id__c;
          upsert newLead Merchant_Id__c;
          //upsert newLead;
        }
      }
      leadId = newLead.Id;
      System.debug('Lead id is ' + leadId);
      System.debug('Lead Converted is ' + newLead.IsConverted);
      if (leadId != null && !newLead.IsConverted) {
        List<Contact> ctList = new List<Contact>();
        List<sObject> sObjectList = new List<sObject>();
        Database.LeadConvert leadCon = new Database.LeadConvert();
        leadCon.setLeadId(newLead.Id);
        LeadStatus convertStatus = [
          SELECT Id, MasterLabel
          FROM LeadStatus
          WHERE IsConverted = true
          LIMIT 1
        ];
        leadCon.setConvertedStatus(convertStatus.MasterLabel);

        // Built in method in the Database Class
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
        // Converts a lead into an account and contact, as well as (optionally) an opportunity.
        Database.LeadConvertResult lcr = Database.convertLead(leadCon);
        if (lcr.isSuccess()) {
          Id accountId = lcr.getAccountId();
          Account acct = new Account(id = accountId);

          // delete contact created through the lead conversion process
          String contactId = [SELECT Id FROM Contact WHERE AccountId = :accountId LIMIT 1].id;
          Contact duplicate = new Contact(Id = contactId);
          delete duplicate;

          acct.Name = appBusName;
          acct.TaxId__c = federalTaxId;
          acct.BillingStreet = physicalStreet;
          acct.BillingCity = physicalCity;
          if (physicalState != null && physicalState != '')
            physicalState = Util.changeStateToFullName(physicalState);
          acct.BillingState = physicalState;
          acct.BillingPostalCode = physicalZip;
          acct.BillingCountry = physicalCountry;
          acct.ShippingStreet = mailingStreet;
          acct.ShippingCity = mailingCity;
          if (mailingState != null && mailingState != '')
            mailingState = Util.changeStateToFullName(mailingState);
          acct.ShippingState = mailingState;
          acct.ShippingPostalCode = mailingZip;
          acct.ShippingCountry = mailingCountry;
          acct.Business_License__c = businessLicense;
          acct.Contractor_License__c = contractorLicense;
          acct.Doing_Business_As__c = doingBusinessAs;
          acct.In_Business_Since__c = inBusinessSince;
          acct.Business_Structure__c = businessStructure;
          acct.Main_Service__c = mainService;
          acct.website = website;
          acct.AnnualRevenue = annualSalesRevenue;
          acct.Annual_Consumer_Finance_Volume__c = annualConsumerFinRev;
          acct.Bank_Account_Number__c = bankAcctNumber;
          acct.Bank_Routing_Number__c = bankRoutingNbr;
          acct.merchant_uuid__c = appMerchantUUID;
          acct.Merchant_ID__c = appMerchantId;
          acct.IP_Address__c = appIPAddress;
          acct.Partner_UUID__c = partnerUuid;
          acct.Partner_Name__c = partnerName;  
          //sObjectList.add(acct);

          if (contactLst != null && contactLst.size() > 0) {
            for (Contact varCon : contactLst) {
                //Associate the contacts to account
              varCon.AccountId = accountId;
            }
          }
            /*
                This code has been commented out to remove duplicate check from inside the code.
            */
          /*    
                            System.debug('Checking for duplicate contact information between applicantInformation object and owners array.');
                            for(Contact varCon : contactLst) {
                                Id contactId = lcr.getContactId();
                                Contact contactFromSalesforce = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id=:contactId LIMIT 1];
                                Boolean matchFound = false;

                                System.debug('Filtering owners by ssn != blank');
                                if(varCon.SSN__c != null) {
                                    System.debug('Found and owner');
                                    if(varCon.Email == contactFromSalesforce.Email) {
                                        matchFound = true;
                                    } else if((varCon.FirstName + ' ' + varCon.LastName) == (contactFromSalesforce.FirstName + ' ' + contactFromSalesforce.LastName)) {
                                        matchFound = true;
                                    }
                                    if(matchFound == true) {
                                        System.debug('Applicant match has been found in owners list, updating existing applicant info contact');
                                        contactFromSalesforce = varCon;
                                        contactFromSalesforce.Id = contactId;
                                        update contactFromSalesforce;
                                    }
                                }                            
                            }
                            */

    /*  Database.SaveResult sr = Database.update(acct);
          if (!sr.isSuccess()) {
            System.debug('Error occured while updating the account');
            Database.Error[] errLst = sr.getErrors();
            String errMessage = '';
            for (Database.Error varErr : errLst) {
              errMessage = errMessage + varErr.getMessage() + '\n  ';
            }

            System.debug(
              '{ "success" : false, "code" : 402, "error" : { ' +
              ' "message" : " Error occured while updating the account ' +
              errMessage +
              '" } }'
            );
            util.insertErrorLog(
              'LeadHelper',
              'performLeadConverion',
              errMessage
            );

            returnVal =
              '{ "success" : false, "code" : 402, "error" : { ' +
              ' "message" : " Error occured while updating the account  ' +
              errMessage +
              '" } }';
          }

          // I think this enforces contact de-dupe rules
          // https://rocketloans.lightning.force.com/lightning/setup/MatchingRules/home
          System.debug('Before inserting contacts through lead conversion process, the size of the contact list is ' + contactLst.size());
          for(Contact varCon1 : contactLst) {
            System.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
            System.debug('First Name is ' + varCon1.FirstName);
            System.debug('Last Name is ' + varCon1.LastName);
            System.debug('Email is ' + varCon1.Email);
            System.debug('is Owner is ' + varCon1.Owner__c);
            System.debug('uuid is ' + varCon1.Contact_UUID__c);
          }
          // changing insert to upsert
          /*
          Database.SaveResult[] srInsert = Database.insert(contactLst, false);
          for (Database.SaveResult varSr : srInsert) {
            if (!varSr.isSuccess()) {
              System.debug('Error occured while inserting the contact');
              Database.Error[] errLst = varSr.getErrors();
              String errMessage = '';
              for (Database.Error varErr : errLst) {
                errMessage = errMessage + varErr.getMessage() + '\n  ';
              }
              System.debug(
                '{ "success" : false, "code" : 402, "error" : { ' +
                ' "message" : " Error occured while inserting the contact list ' +
                errMessage +
                '" } }'
              );
              util.insertErrorLog(
                'LeadHelper',
                'performLeadConverion',
                errMessage
              );
              returnVal =
                '{ "success" : false, "code" : 402, "error" : { ' +
                ' "message" : " Error occured while inserting the contact list  ' +
                errMessage +
                '" } }';
            }
          }
          */
    /*      Schema.SObjectField contactUUID = Contact.Fields.Contact_UUID__c;
          Database.UpsertResult[] srUpsert = Database.upsert(contactLst, contactUUID, false);
          for (Database.UpsertResult varSr : srUpsert) {
            if (!varSr.isSuccess()) {
              System.debug('Error occured while inserting the contact');
              Database.Error[] errLst = varSr.getErrors();
              String errMessage = '';
              for (Database.Error varErr : errLst) {
                errMessage = errMessage + varErr.getMessage() + '\n  ';
              }
              System.debug(
                '{ "success" : false, "code" : 402, "error" : { ' +
                ' "message" : " Error occured while inserting the contact list ' +
                errMessage +
                '" } }'
              );
              util.insertErrorLog(
                'LeadHelper',
                'performLeadConverion',
                errMessage
              );
              returnVal =
                '{ "success" : false, "code" : 402, "error" : { ' +
                ' "message" : " Error occured while inserting the contact list  ' +
                errMessage +
                '" } }';
            }
          }

        } else {
          Database.Error[] errList = lcr.getErrors();
          String errMessage = '';
          for (Database.Error varErr : errList) {
            errMessage = errMessage + varErr.getMessage() + '\n  ';
          }

          System.debug(
            '{ "success" : false, "code" : 402, "error" : { ' +
            ' "message" : " Error occured while converting the lead ' +
            errMessage +
            '" } }'
          );
          util.insertErrorLog('LeadHelper', 'performLeadConverion', errMessage);
          returnVal =
            '{ "success" : false, "code" : 402, "error" : { ' +
            ' "message" : " Error occured while converting the lead  ' +
            errMessage +
            '" } }';
          System.debug('Error occured while converting lead ');
          // System.debug('Error code is ' + errList[0].getStatusCode() + ' Error Message is ' + errList[0].getMessage());
        }
      } else {
        returnVal =
          '{ "success" : false, "code" : 401, "error" : { ' +
          ' "message" : "Lead id or merchant id is empty" } }';
        util.insertErrorLog(
          'LeadHelper',
          'performLeadConverion',
          'Lead id or merchant id is empty'
        );
      }
    } else {
      returnVal =
        '{ "success" : false, "code" : 401, "error" : { ' +
        ' "message" : "Lead is empty" } }';
      util.insertErrorLog(
        'LeadHelper',
        'performLeadConverion',
        'Lead is empty'
      );
    }

    return returnVal;
  }    */
}