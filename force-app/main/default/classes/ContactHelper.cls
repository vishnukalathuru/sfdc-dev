/**
 * Created by sanjeev.karanwal on 2019-05-17.
 */

/**
 * @File Name          : ContactHelper
 * @Description        : This class contains the helper methods for Contact object
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : Sanjeev Karanwal
 * @Last Modified On   : 6/17/2019, 11:01:33 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-05-17                    Initial Version
**/
public without sharing class ContactHelper {
    public static final String SPIDURL = 'salespeople';
    /* Name: upsertContact
     * Parameter name:
     *          ctList (List<Contact> ). List of contact objects
     *          merchantId (String) Merchant id
     * Description: This method upserts the contact based on Contact_UUID__c. Contact_UUID__c is defined as unique external id on contact object.
     *              MerchantId is used to identfy the account to which these contacts would be associated to.
     * Return Type: String.  Code and message is returned in JSON format
     */
    public static String upsertContact(List<Contact> ctList, String merchantId) {
        Id acctId;
        String returnVal;
        Schema.DescribeFieldResult F = Contact.Contact_UUID__c.getDescribe();
        Schema.SObjectField spidExternalField = F.getSobjectField();
        if (merchantId != null && merchantId != '') {
            // Get the account corresponding to the merchant id
            Account acct = [select Id, Merchant_ID__c from Account where Merchant_ID__c = :merchantId LIMIT 1][0];
            acctId = acct.Id;
            List<Contact> upsertConList = new List<Contact>();
            if (ctList != null && ctList.size() > 0) {
                for (Contact varCon : ctList) {
                    // associated the contact to the account obtained above
                    varCon.AccountId = acctId;
                    upsertConList.add(varCon);
                }
            }

            if (upsertConList.size() > 0) {
                // upsert contact based on Contact_UUID__c field
                Database.UpsertResult[] srList = Database.upsert(upsertConList, spidExternalField, false);
                for (Database.UpsertResult sr : srList) {
                    if (!sr.isSuccess()) {
                        Database.Error[] errLst = sr.getErrors();
                        String errMessage = '';
                        for (Database.Error varErr : errLst) {
                            errMessage = errMessage + varErr.getMessage() + '\n  ' ;
                        }

                        System.debug(errMessage);

                        Util.insertErrorLog('ContactHelper','upsertContact',errMessage);
                        returnVal = '{ "success" : false, "code" : 402, "error" : { ' +
                                ' "message" : " ' + errMessage + '" } }';
                    } else {

                        returnVal = '{ "success" : true, "code" : 200, "message" : "successfully upserted contacts"}';
                    }
                }
            } else {
                returnVal = '{ "success" : false, "code" : 401, "error" : { ' +
                        ' "message" : "Contact/MID/SPID list is empty" } }';
                Util.insertErrorLog('ContactHelper','upsertContact','Contact/MID/SPID list is empty');
            }
        } else {
            returnVal = '{ "success" : false, "code" : 401, "error" : { ' +
                    ' "message" : "Merchant Id is empty" } }';
            Util.insertErrorLog('ContactHelper','upsertContact','Merchant Id is empty');
        }

        return returnVal;

    }

    /* Name: upsertSPID
     * Parameter name:
     *          spidJSONStr (String) JSON string returned by callout to SPID url from dynamo
     * Description: This method parses the JSON string obtained from SPID callout and creates SPID contacts. The JSON string contains array of SPID.
     *               This method grabs each element of the array  and checks the Status node. If the status equals either SALESPERSON_CREATED or SALESPERSON_UPDATED,
     *               it creates a contact with below information from JSON
     *               enabled. If this is true, set the isActive flag to true, else false.
     *               Set the Contact_Type__c to 'SPID'
     *               Groups
     *               GroupName. If it contains cl-merchant-group, Contact_Type__c is set to 'MID'
     *               It parses the attributes node to get the name and value for the below:
     *               sub : contains uuid
     *               custom:merchant_id': contains merchant ID
     *               name: contains firstName
     *               phone_number: contains Phone
     *               family_name : contains lastName
     *               email: contains email
     *               
     *               This method gets the account corresponding to the merchant id and associates the contacts to that account. Finally it upserts the contact based on Contact_Type__c
     *
     * Return Type: None.  
     */

    public static void upsertSPID(String spidJSONStr) {
        List<Contact> spidList = new List<Contact>();
        if (spidJSONStr != null && spidJSONStr != '') {
            // Map to hold mapping between contact uuid and merchant id
            Map<String, String> merchantUUIDMap = new Map<String, String>();

            //Map to hold mapping between merchant id and account Id
            Map<String, String> uuidAccountMap = new Map<String, String>();

            List<Object> objList = (List<Object>) JSON.deserializeUntyped(spidJSONStr);
            for (Object varObj : objList) {
                Map<String, Object> spidMap = (Map<String, Object>) varObj;
                if (spidMap != null) {
                    String statusStr = (String) spidMap.get('Status');
                    if (statusStr == 'SALESPERSON_CREATED' || statusStr == 'SALESPERSON_UPDATED') {
                        Contact varCon = new Contact();
                        String spidActive = (String) spidMap.get('enabled');
                        if (spidActive == 'true') varCon.isActive__c = true;
                        if (spidActive == 'false') varCon.isActive__c = false;
                        //Set the contact as SPID
                        varCon.Contact_Type__c = 'SPID';
                        List<Object> groupList = (List<Object>) spidMap.get('Groups');
                        Set<String> GroupNameSet = new Set<String>();
                        for (Object varGObj : groupList) {
                            Map<String, Object> groupMap = (Map<String, Object>) varGObj;
                            /*
                            if(groupMap.keySet().contains('cl-merchant-group')) {
                                varCon.Contact_Type__c = 'MID';
                            }
                             */
                            if (groupMap != null) {
                                String contactTypeStr = (String) groupMap.get('GroupName');
                                GroupNameSet.add(contactTypeStr);
                            }
                        }
                        // if cl-merchant-group is present, set the contact as MID
                        if (GroupNameSet.contains('cl-merchant-group')) varCon.Contact_Type__c = 'MID';
                        List<Object> attrObjList = (List<Object>) spidMap.get('Attributes');
                        String uuidStr;
                        String merchantIdStr;
                        String firstNameStr;
                        String lastNameStr;
                        String phoneNbrStr;
                        String emailStr;
                        for (Object varAttrObj : attrObjList) {
                            if (varAttrObj != null) {
                                String nameStr;
                                String valueStr;
                                Map<String, Object> attrMap = (Map<String, Object>) varAttrObj;
                                nameStr = (String) attrMap.get('Name');
                                switch on nameStr {
                                    when 'sub' {
                                        uuidStr = (String) attrMap.get('Value');
                                    }
                                    when 'custom:merchant_id' {
                                        merchantIdStr = (String) attrMap.get('Value');
                                    }
                                    when 'name' {
                                        firstNameStr = (String) attrMap.get('Value');
                                    }
                                    when 'phone_number' {
                                        phoneNbrStr = (String) attrMap.get('Value');
                                    }
                                    when 'family_name' {
                                        lastNameStr = (String) attrMap.get('Value');
                                    }
                                    when 'email' {
                                        emailStr = (String) attrMap.get('Value');
                                    }
                                }
                            }

                        }
                        varCon.FirstName = firstNameStr;
                        varCon.LastName = lastNameStr;
                        varCon.Phone = phoneNbrStr;
                        varCon.Email = emailStr;
                        varCon.Contact_UUID__c = uuidStr;
                        // grab the uuid and merchant id and put them in map with key as uuid
                        if (uuidStr != null && uuidStr != '' && merchantIdStr != null && merchantIdStr != '') {
                            merchantUUIDMap.put(uuidStr, merchantIdStr);
                        }
                        spidList.add(varCon);
                    }
                }
            }

            if (merchantUUIDMap.size() > 0) {
                List<String> acctIdLst = merchantUUIDMap.values();
                // Get all accounts corresponding to the merchant ids and store the value in map with key as merchant id and value as account id
                if (acctIdLst.size() > 0) {
                    List<Account> acctLst = [select Id, Merchant_ID__c from Account Where Merchant_ID__c IN :acctIdLst];
                    for (Account varAcct : acctLst) {
                        uuidAccountMap.put(varAcct.Merchant_ID__c, varAcct.Id);
                    }
                }
            }

            for (Contact varCon1 : spidList) {
                // associate contacts with corresponding accounts using merchant id
                varCon1.AccountId = uuidAccountMap.get(merchantUUIDMap.get(varCon1.Contact_UUID__c));
            }
        }
        // Insert MID-SPID
        Schema.DescribeFieldResult ContactUUID = Contact.Contact_UUID__c.getDescribe();
        Schema.SObjectField ContactUUIDField = ContactUUID.getSobjectField();
        if (spidList.size() > 0) {
            Database.UpsertResult[] srList = Database.upsert(spidList, ContactUUIDField, false);
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()) {
                    Database.Error[] errLst = sr.getErrors();
                    String errMessage = '';
                    for (Database.Error varErr : errLst) {
                        errMessage = errMessage + varErr.getMessage() + '\n  ' ;
                    }
                    System.debug('Error occured while inserting MID-SPID. Error message is : ' + errMessage);
                    Util.insertErrorLog('ContactHelper','upsertSPID',errMessage);

                } else {

                    System.debug('MID-SPID upserted successfully');
                }
            }
        } else {
            System.debug('SPID list is empty');
            Util.insertErrorLog('ContactHelper','upsertSPID','SPID list is empty');
        }
    }

    /* Name: performSPIDUpdateCallout
     * Parameter name:
     *          spidUpdateUrl (String) JSON string containing Put response for making PUT callout to dynamo for updating MID/SPID. 
     * Description: This method calls the performPutCallout method of CalloutHelper class and passes the Put request JSON string.
     * Return Type: None.  
     */

    @future(callout=true)
    public static void performSPIDUpdateCallout(String spidUpdateUrl) {
        try {
            String response = CalloutHelper.performPutCallout(spidUpdateUrl, null);
            String message = 'Response for SPID activation/deactivation is ' + response;
            Util.insertErrorLog('ContactHelper','performSPIDUpdateCallout',response);
            System.debug('Response for SPID activation/deactivation is ' + response);

        } catch (CalloutException ce) {
            String errorMessage = 'Exception occured during callout ' + ce.getMessage() + ' \n stack trace is ' + ce.getStackTraceString();
            System.debug(errorMessage);
            Util.insertErrorLog('ContactHelper','performSPIDUpdateCallout',errorMessage);

        } catch (Exception ex) {
            String errorMessage1 = 'Exception occured after inserting case ' + ex.getMessage() + ' \n stack trace is ' + ex.getStackTraceString();
            System.debug(errorMessage1);
            Util.insertErrorLog('ContactHelper','performSPIDUpdateCallout',errorMessage1);
        }
    }

     /* Name: performContactUpdateCallout
     * Parameter name:
     *          contactURL (String) JSON string containing Put response for making PUT callout to dynamo for updating contact. 
     * Description: This method calls the performPutCallout method of CalloutHelper class and passes the Put request JSON string.
     * Return Type: None.  
     */
    @future(callout=true)
    public static void performContactUpdateCallout(String contactURL, String contactPutReq) {
        try {
             String response = CalloutHelper.performPutCallout(contactURL, contactPutReq);
             String message = 'Response for SPID activation/deactivation is ' + response;
             Util.insertErrorLog('ContactHelper','performContactUpdateCallout',response);
        } catch (CalloutException ce) {
            String errorMessage = 'Exception occured during callout ' + ce.getMessage() + ' \n stack trace is ' + ce.getStackTraceString();
            System.debug(errorMessage);
            Util.insertErrorLog('ContactHelper','performContactUpdateCallout',errorMessage);

        } catch (Exception ex) {
            String errorMessage1 = 'Exception occured after inserting case ' + ex.getMessage() + ' \n stack trace is ' + ex.getStackTraceString();
            System.debug(errorMessage1);
            Util.insertErrorLog('ContactHelper','performContactUpdateCallout',errorMessage1);
        }

}
/*
    public static void updateContactToDynamo(List<Contact> conLst, Map<Id, Contact> conOldMap) {

        if (conLst.size() < 2) {
            Contact varCon = conLst[0];
                if ((varCon.FirstName != conOldMap.get(varCon.Id).FirstName) ||
                        (varCon.LastName != conOldMap.get(varCon.Id).LastName) ||
                        (varCon.Email != conOldMap.get(varCon.Id).Email) ||
                        (varCon.Phone != conOldMap.get(varCon.Id).Phone) ||
                        (varCon.Birthdate != conOldMap.get(varCon.Id).Birthdate) ||
                        (varCon.Primary_Contact__c != conOldMap.get(varCon.Id).Primary_Contact__c) ||
                        (varCon.Owner_Since__c != conOldMap.get(varCon.Id).Owner_Since__c) ||
                        (varCon.Ownership__c != conOldMap.get(varCon.Id).Ownership__c) ||
                        (varCon.SSN__c != conOldMap.get(varCon.Id).SSN__c) ||
                        (varCon.Owner__c != conOldMap.get(varCon.Id).Owner__c) ||
                        (varCon.Contact_Type__c != conOldMap.get(varCon.Id).Contact_Type__c) ||
                        (varCon.Title_With_Company__c != conOldMap.get(varCon.Id).Title_With_Company__c) ||
                        (varCon.IsApplicant__c != conOldMap.get(varCon.Id).IsApplicant__c) ||
                        (varCon.Signature_Authority__c != conOldMap.get(varCon.Id).Signature_Authority__c) ||
                        (varCon.isActive__c != conOldMap.get(varCon.Id).isActive__c) ||
                        (varCon.MailingStreet != conOldMap.get(varCon.Id).MailingStreet) ||
                        (varCon.MailingCity != conOldMap.get(varCon.Id).MailingCity) ||
                        (varCon.MailingState != conOldMap.get(varCon.Id).MailingState) ||
                        (varCon.MailingPostalCode != conOldMap.get(varCon.Id).MailingPostalCode)
                        ) {
                    Account acct = [select Id, Merchant_ID__c, merchant_uuid__c from Account where Id = :varCon.AccountId];
                    String merchantId;
                    String merchantuuid;
                    String contactPutReq;
                    if(acct != null) {
                        merchantId = acct.Merchant_ID__c;
                        merchantuuid = acct.merchant_uuid__c;
                    }

                    System.debug('Inside updateContactToDynamo the merchantid is ' + merchantId);
                    System.debug('Inside updateContactToDynamo the merchant uuid is ' + merchantuuid);
                    String conResState = Util.changeStateToAbbrev(varCon.MailingState);
                    contactPutReq = '{ "merchantId": "' + merchantId + '"' ;

                    if (varCon.Owner__c) {
                        contactPutReq = contactPutReq + '",owners": [ { ' ;
                        if (varCon.Owner_Since__c != null) {
                            contactPutReq = contactPutReq + '"uuid" : "' + varCon.Contact_UUID__c + '","ownerSince": { "month": ' +
                                    varCon.Owner_Since__c.month() + ', "year": ' +
                                    varCon.Owner_Since__c.year() + ', "day": ' + varCon.Owner_Since__c.day() + ' },';
                        }
                        contactPutReq = contactPutReq + '"personalInformation": { "firstName": "' +
                                varCon.FirstName + '", "lastName": "' + varCon.LastName + '"' ;

                        if (varCon.Birthdate != null) {
                            contactPutReq = contactPutReq + ',"dateOfBirth": { "month": ' + varCon.Birthdate.month() +
                                    ', "year": ' + varCon.Birthdate.year() + ', "day": ' + varCon.Birthdate.day() + '}';
                        }
                        if(varCon.Phone != null) {
                            contactPutReq = contactPutReq + ',"mobileNumber":' + Util.replaceNonNumChars(varCon.Phone);
                        }
                        if(varCon.SSN__c != null) {
                            contactPutReq = contactPutReq +
                                    ',"socialSecurityNumber": ' + Util.replaceNonNumChars(varCon.SSN__c);
                        }
                        contactPutReq = contactPutReq +
                                ', "email": "' + varCon.Email + '" },"residentialAddress": { "zip": "' +
                                varCon.MailingPostalCode + '","state": "' + Util.changeStateToAbbrev(conResState) + '","city": "' + varCon.MailingCity + '","street": "'
                                + varCon.MailingStreet + '"}' ;
                        if(varCon.Ownership__c != null) {
                            contactPutReq = contactPutReq + ',"ownershipPercentage":' + varCon.Ownership__c ;
                        }
                        contactPutReq = contactPutReq + '}]';

                    }

                    if (varCon.IsApplicant__c) {
                        contactPutReq = contactPutReq + ',"applicantInformation": { "authorityToBindCompany": ' + varCon.Signature_Authority__c +
                                ',"titleWithCompany": "' + varCon.Title_With_Company__c + '","firstName": "' + varCon.FirstName + '","lastName": "' +
                                varCon.LastName + '","isOwner":' + varCon.Owner__c + ',"email": "' + varCon.Email + '"}';
                    }

                    if (varCon.Primary_Contact__c) {
                        contactPutReq = contactPutReq + ',{ "businessInformation": { "primaryContactForFinancingInformation": { "firstName": "' + varCon.FirstName + '","lastName":"' +
                                varCon.LastName + '","email":"' + varCon.Email + '"}}';
                    }
                    System.debug('Contact Type is ' + varCon.Contact_Type__c);
                    if( (varCon.Contact_Type__c != conOldMap.get(varCon.Id).Contact_Type__c) ||
                        (varCon.isActive__c != conOldMap.get(varCon.Id).isActive__c)) {
                        System.debug('Contact Type is ' + varCon.Contact_Type__c);
                        if (varCon.Contact_Type__c == 'MID' || varCon.Contact_Type__c == 'SPID') {
                            String spid_baseurl = SPIDURL + '/' + varCon.Contact_UUID__c + '/';
                            if (varCon.isActive__c) {
                                spid_baseurl = spid_baseurl + 'enable';
                            } else {
                                spid_baseurl = spid_baseurl + 'disable';
                            }
                            System.debug('spid_baseurl is ' + spid_baseurl);
                            performSPIDUpdateCallout(spid_baseurl);

                        }
                    }

                    contactPutReq = contactPutReq + '}';

                            System.debug('Put response for contact change is ' + contactPutReq);

                    String contactURL = 'merchants/' + merchantuuid;
                    performContactUpdateCallout(contactURL, contactPutReq);

                }

        } else {
            System.debug('Mass updates of Contacts can not be sent to dynamo');
            Util.insertErrorLog('ContactHelper','updateContactToDynamo','Mass updates of Contacts can not be sent to dynamo');
        }


    }    */


}