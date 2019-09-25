/**
 * Created by sanjeev.karanwal on 2019-05-20.
 */

/**
 * @File Name          : LeadEndpoint
 * @Description        : This class is exposed as REST endpoint. It contains method to be called as POST
 * @Author             : sanjeev.karanwal
 * @Group              :
 * @Last Modified By   : Sanjeev Karanwal
 * @Last Modified On   : 6/17/2019, 10:08:47 AM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-05-20                    Initial Version
 **/
@RestResource(urlmapping='/v1/Application/*')
global without sharing class ApplicationEndpoint {
  /* Name: createApplication
   * Parameter name: None
   * Description: This method takes the payload from dynamo, parses the JSON payload and performs either lead creation or lead conversion.
   *              Below is the logic involved.
   *               The payload has 'topic' and 'resource' at the root. If the 'topic' is 'MERCHANT_APPLICATION_STARTED', grab the information from 'resource' node.
   *               Under resource node, grab the leadid from metadata node. Grab the uuid which contains merchant uuid. If the leadid is present, it means that lead exists in
   *               salesforce. Otherwise create a new lead with the below information
   *               firstName;
   *               lastName;
   *               email;
   *               titleWithCompany;
   *               legalBusinessName;
   *               businessPhone;
   *               uuid;
   *               If the 'topic' contains SALESPERSON_CREATED or SALESPERSON_UPDATED, make callout to get SPID information from dynamo and upsert SPID using contacthelper class.
   *               If the 'topic' contains MERCHANT_APPLICATION_PENDING_DECISION, grab the information under 'resource' node.
   *               merchantId
   *
   *               Grab the below information from contactInformation node:
   *               phone
   *               email
   *               firstName
   *               lastName
   *               uuid
   *               address
   *               This information comes as array. For each element, create a contact and add it to contact list
   *
   *               Grab the below information from applicantInformation node:
   *               authorityToBindCompany
   *               titleWithCompany
   *               firstName
   *               lastName
   *               isOwner
   *               email
   *               uuid
   *               Create a contact with this information and add it to the contact list with isApplicant set to true
   *
   *               Grab the below information from owners node
   *               ownershipPercentage
   *               ownerSince
   *               firstName
   *               lastName,
   *               mobileNumber,
   *               socialSecurityNumber,
   *               email,
   *               dateOfBirth,
   *               residentialAddress,
   *               uuid.
   *               This information comes as array. For each element, create a contact and add it to contact list with Owner__c set to true
   *
   *               Grab the below information from primaryContactForFinancingInformation node
   *               firstName
   *               lastName
   *               email uuid
   *               Create a contact with Primary_Contact__c set to true
   *
   *               Grab the below information for account:
   *               merchantId
   *               isActive
   *               accountNumber
   *               routingNumber
   *               legalBusinessName
   *               website
   *               federalTaxId
   *               annualConsumerFinanceVolume
   *               contractorLicenseNumber
   *               businessStructure
   *               legalBusinessName
   *               businessLicenseNumber
   *               businessPhone
   *               typeOfServiceOrProductOffered
   *               annualSalesRevenue
   *               mailingAddress
   *               physicalAddress
   *               allTradeNames
   *               inBusinessSince
   *
   *               If the leadid is present, grab the lead corresponding to this id, else check if merchantid is present. If merchantid is present, grab the lead corresponding to
   *               this merchantid (merchantid is defined as unique external id on lead). Update the firstname, lastname, email, titlewithcompany, businessname, businessphone.
   *               Call the performLeadConversion method of LeadClassHelper passing all this information along with the contactList.
   * Return Type: (String)
   */

  @HttpPost
  global static String createApplication() {
        RestRequest req = RestContext.request;
        String postParam = req.requestBody.toString();
        if(!String.isBlank(postParam)){
          try{
              MerchantApplicationRequest applicationRequest = (MerchantApplicationRequest)JSON.deserialize(postParam,MerchantApplicationRequest.class);
              system.debug('::::App-request:::'+applicationRequest);
              CreateApplicationUtility.processApplicationBasedOnTopic(applicationRequest);
          } Catch(Exception ex){
              Util.insertErrorLog('ApplicationEndpoint','createApplication',ex.getMessage());
              system.debug(':::::Exception:::::'+ex.getMessage() );
              system.debug(':::::Exception:::::'+ex.getStackTraceString());
          }
        }
        return null;
    }     
}