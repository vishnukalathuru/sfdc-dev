/**
 * Created by sanjeev.karanwal on 2019-05-14.
 */

/**
 * @File Name          : UnderwriterController
 * @Description        : This class contains methods used by Underwriter component
 * @Author             : sanjeev.karanwal
 * @Group              :
 * @Last Modified By   : Sanjeev Karanwal
 * @Last Modified On   : 6/17/2019, 12:47:45 PM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0                                   2019-05-14                    Initial Version
**/
public with sharing class UnderwriterController {

    // Underwriting Queue Developer Name
    private static final String UNDERWRITING_QUEUE = 'Underwriting_Queue';
    private static Id uwqueueid;

    // Get the id of the UnderWriting Queue
    static {
        Group UWQueueGroup = [SELECT Id, DeveloperName FROM Group WHERE type='queue' AND DeveloperName = :UNDERWRITING_QUEUE];
        if(UWQueueGroup != null) uwqueueid = UWQueueGroup.Id;
    }

    /* Name: getPickListVal
    * Parameter name: None
    * Description: This method gets the picklist values for the below picklists to be displayed on UnderWriter component
    *                  Underwriting_Status__c
    *                   X1UP_Review_Status__c
    *                  Financial_Reputational_Risk__c.
    *                  Policy_Exception_Reasons__c
    *                  Decline_Reasons__c
    *              It creates a map with below:
    *              Key:'UWS'  Value: 'Underwriting_Status__c' list
    *              Key:'X1UPRS'  Value: 'X1UP_Review_Status__c' list
    *              Key:'FRR'  Value: 'Financial_Reputational_Risk__c' list
    *              Key:'PER'  Value: 'Policy_Exception_Reasons__c' list
    *              Key:'DR'  Value: 'Decline_Reasons__c' list
    * Return Type: Map<String, List<String>>.
    */
    @auraenabled
    public static Map<String, List<String>> getPickListVal() {
        Map<String, List<String>> picklistMap = new Map<String, List<String>>();
        Schema.DescribeFieldResult UWSResult = Underwriting__c.Underwriting_Status__c.getDescribe();
        Schema.DescribeFieldResult X1UPResult = Underwriting__c.X1UP_Review_Status__c.getDescribe();
        Schema.DescribeFieldResult FRRResult = Underwriting__c.Financial_Reputational_Risk__c.getDescribe();
        Schema.DescribeFieldResult PERResult = Underwriting__c.Policy_Exception_Reasons__c.getDescribe();
        Schema.DescribeFieldResult DRResult = Underwriting__c.Decline_Reasons__c.getDescribe();
        picklistMap.put('UWS', getListValues(UWSResult));
        picklistMap.put('X1UPRS', getListValues(X1UPResult));
        picklistMap.put('FRR', getListValues(FRRResult));
        picklistMap.put('PER', getListValues(PERResult));
        picklistMap.put('DR', getListValues(DRResult));
        return picklistMap;
    }



/* Name: getListValues
 * Parameter name: fieldResult(Schema.DescribeFieldResult)
 * Description: This method gets the list of String corresponding to the fieldResult
 * Return Type: List<String>.
 */
    public static List<String> getListValues(Schema.DescribeFieldResult fieldResult) {
        List<String> valList = new List<String>();
        List<Schema.PickListEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PickListEntry varple : ple) {
            valList.add(varple.getValue());
        }
        return valList;

    }



/* Name: getUnderWritterRecord
 * Parameter name: uwRecordId (String): The id of the underwriting object
 * Description: This method gets the Underwriting__c object corresponding to the uwRecordId. It also grabs all the contacts associated with the account corresponding to the
 *              underwriting object. It gets the child record only for contacts which are owner. If the underwriting object is not present, it creates one along with one Owner_UW__c
 *              record for each contact which is an owner. It creates the underwriting object and uses it's id to associate the Owner_UW__c record. It then inserts all Owner_UW__c records.
 *              When a new Underwriting record is created, the ownership is assigned to Underwriting queue
 * Return Type: Underwriting__c object
 */


    @auraenabled
    public static Underwriting__c getUnderWritterRecord(String uwRecordId) {
        System.debug('Inside getUnderWritterRecord method');
        List<Underwriting__c> underWritingObjLst = new List<Underwriting__c>();
        Underwriting__c underWritingObj;
        List<Owner_UW__c> ownerUWList = new List<Owner_UW__c>();
        List<Owner_UW__c> ownerListToInsert = new List<Owner_UW__c>();

        underWritingObjLst = [
                SELECT Account_Name__c,Account_Name__r.Name,Bank_Account_Number_NA__c,Bank_Account_Number_Notes__c,Bank_Account_Number_Pended__c,
                        Bank_Account_Number_PE__c,Bank_Account_Number_Verified__c,BBB_Rating_NA__c,BBB_Rating_Notes__c,
                        BBB_Rating_Pended__c,BBB_Rating_PE__c,BBB_Rating_Verified__c,Business_Address_NA__c,Business_Address_Notes__c,
                        Business_Address_Pended__c,Business_Address_PE__c,Business_Address_Verified__c,Business_Bankruptcy_NA__c,
                        Business_Bankruptcy_Notes__c,Business_Bankruptcy_Pended__c,Business_Bankruptcy_PE__c,Business_Entity_Notes__c,
                        Business_Bankruptcy_Verified__c,Business_Entity_NA__c,Business_Entity_Pended__c,Business_Entity_PE__c,
                        Business_Entity_Verified__c,Business_Name_NA__c,Business_Name_Notes__c,Business_Name_Pended__c,Business_Name_PE__c,
                        Business_Name_Verified__c,Business_Phone_NA__c,Business_Phone_Notes__c,Business_Phone_Pended__c,
                        Business_Phone_PE__c,Business_Phone_Verified__c,Business_S_L_J_NA__c,Business_S_L_J_Notes__c,Business_S_L_J_Pended__c,
                        Business_S_L_J_PE__c,Business_S_L_J_Verified__c,Domain_History_NA__c,Domain_History_Notes__c,Domain_History_Pended__c,
                        Domain_History_PE__c,Domain_History_Verified__c,Due_Diligence_Summary__c,Financial_Reputational_Risk__c,
                        Id,IP_Geolocation_NA__c,
                        IP_Geolocation_Notes__c,IP_Geolocation_Pended__c,IP_Geolocation_PE__c,IP_Geolocation_Verified__c,License_Verification_NA__c,
                        License_Verification_Notes__c,License_Verification_Pended__c,License_Verification_PE__c,
                        License_Verification_Verified__c,LOTB_NA__c,LOTB_Notes__c,LOTB_Pended__c,LOTB_PE__c,LOTB_Verified__c,Name,
                        OFAC_SDN_NA__c,OFAC_SDN_Notes__c,OFAC_SDN_Pended__c,OFAC_SDN_PE__c,OFAC_SDN_Verified__c,
                        OwnerId,Owner.Name,Pay_History_NA__c,Pay_History_Notes__c,Pay_History_Pended__c,Pay_History_PE__c,
                        Pay_History_Verified__c,Policy_Exception_Reasons__c,Decline_Reasons__c,Decline_Email_Sent__c,Prohibited_Industry_NA__c,Prohibited_Industry_Notes__c,Prohibited_Industry_Pended__c,
                        Prohibited_Industry_PE__c,Prohibited_Industry_Verified__c,Risk_Class__c,Routing_Number_NA__c,Routing_Number_Notes__c,
                        Routing_Number_Pended__c,Routing_Number_PE__c,Routing_Number_Verified__c,Tax_ID_NA__c,Tax_ID_Notes__c,Tax_ID_Pended__c,
                        Tax_ID_PE__c,Tax_ID_Verified__c,Underwriting_Status__c,X1UP_Review_Status__c, LastModifiedDate,(
                        select Address_NA__c,Address_Notes__c,Address_Pended__c,Address_PE__c,Address_Verified__c,Bankruptcy_NA__c,
                                Bankruptcy_Notes__c,Bankruptcy_Pended__c,Bankruptcy_PE__c,Bankruptcy_Verified__c,Contact__c,
                                Criminal_History_NA__c,Criminal_History_Notes__c,Criminal_History_Pended__c,Criminal_History_PE__c,
                                Criminal_History_Verified__c,Date_of_Birth_NA__c,Date_of_Birth_Notes__c,Date_of_Birth_Pended__c,
                                Date_of_Birth_PE__c,Date_of_Birth_Verified__c,FICO_NA__c,FICO_Notes__c,FICO_Pended__c,FICO_PE__c,FICO_Verified__c,
                                FirstName__c,Id,LastName__c,Legal_Name_NA__c,Legal_Name_Notes__c,Legal_Name_Pended__c,
                                Legal_Name_PE__c,Legal_Name_Verified__c,MiddleName__c,Name,Pay_History_NA__c,Pay_History_Notes__c,
                                Pay_History_Pended__c,Pay_History_PE__c,Pay_History_Verified__c,Phone_NA__c,Phone_Notes__c,Phone_Pended__c,
                                Phone_PE__c,Phone_Verified__c,Social_Security_Number_NA__c,Social_Security_Number_Notes__c,Social_Security_Number_Pended__c,
                                Social_Security_Number_PE__c,Social_Security_Number_Verified__c,S_L_J_NA__c,S_L_J_Notes__c,S_L_J_Pended__c,
                                S_L_J_PE__c,S_L_J_Verified__c,Ownership_Notes__c, Ownership_Verified__c,Ownership_NA__c,Ownership_Pended__c,Ownership_PE__c,
                                Underwriting__c, contact__r.FirstName, contact__r.LastName, contact__r.MiddleName,
                                contact__r.SSN__c, contact__r.Birthdate, contact__r.MailingStreet, contact__r.MailingCity, contact__r.MailingState,
                                contact__r.MailingPostalCode, contact__r.MailingCountry, contact__r.MobilePhone, contact__r.Contact_Type__c,contact__r.Ownership__c
                        FROM Owner_UWs__r where Contact__r.Owner__c = true
                )
                FROM Underwriting__c
                WHERE Account_Name__c = :uwRecordId order by LastModifiedDate DESC limit 1
        ];

        List<Contact> ctList = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :uwRecordId AND Owner__c = true
        ];


        if(underWritingObjLst != null && underWritingObjLst.size() > 0) {
            underWritingObj = underWritingObjLst[0];
            ownerUWList = underWritingObj.Owner_UWs__r;
            Set<String> ownerSet = new Set<String>();
            for(Owner_UW__c varOwner : ownerUWList) {
                ownerSet.add(varOwner.Contact__c);
            }

            for(Contact varCon : ctList) {
                if(!ownerSet.contains(varCon.Id)) {
                    Owner_UW__c ow = new Owner_UW__c();
                    ow.Contact__c = varCon.Id;
                    ow.Underwriting__c = underWritingObj.Id;
                    ownerListToInsert.add(ow);

                }
            }

            if(ownerListToInsert.size() > 0) {
                insert ownerListToInsert;
            }

        } else {

            System.debug('Underwriter object is null');
            underWritingObj = new Underwriting__c();
            underWritingObj.Account_Name__c = uwRecordId;
            underWritingObj.OwnerId = UserInfo.getUserId();
           // if(uwqueueid != null) underWritingObj.OwnerId = uwqueueid;
            System.debug('Before inserting underwriting obj the DML limit is ' + Limits.getDmlStatements() + ' Limit is '
                    + Limits.getLimitDmlRows() + ' get limit dml statements ' + Limits.getLimitDmlStatements());
            insert underWritingObj;
            List<Owner_UW__c> insertUWListNew = new List<Owner_UW__c>();
            for (Contact varCon : ctList) {
                Owner_UW__c varUW = new Owner_UW__c();
                varUW.Contact__c = varCon.Id;
                varUW.Underwriting__c = underWritingObj.Id;
                insertUWListNew.add(varUW);
            }
            insert insertUWListNew;
        }

        return underWritingObj;

    }


   /* Name: setUnderWritter
    * Parameter name: underWritingObj (Underwriting__c): The underwriting object which has to be saved
    *                 OwnerUWObjLst (List<Owner_UW__c>): List of child Owner_UW__c records
    * Description: This method saves the Underwriting object along with the child Owner_UW__c records
    * Return Type: None
    */
    @auraenabled
    public static void setUnderWritter(Underwriting__c underWritingObj, List<Owner_UW__c> OwnerUWObjLst) {
        System.debug('Before saving the underwriting object is ' + underWritingObj);
        System.debug('Before saving the Owner UW object is ' + OwnerUWObjLst);
        try {
            if (underWritingObj != null) {
                update(underWritingObj);
            }

            if (OwnerUWObjLst != null && OwnerUWObjLst.size() > 0) {
                update(OwnerUWObjLst);
            }

        } catch (DmlException e) {
            String msg;
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg = +e.getDmlMessage(i) + '\n' ;
            }
            throw new AuraHandledException(msg);
        }


    }


    /* Name: createNewtUnderWritterRecord
     * Parameter name: uwRecordId (String): The id of the underwriting object
     * Description: This method creates the Underwriting__c object corresponding to the uwRecordId. It also grabs all the contacts associated with the account corresponding to the
     *              underwriting object. It creates one along with one Owner_UW__c record for each contact which is an owner. It creates
     *              the underwriting object and uses it's id to associate the Owner_UW__c record. It then inserts all Owner_UW__c records.
     * Return Type: Underwriting__c object
     */
    @auraenabled
    public static Underwriting__c createNewtUnderWritterRecord(String uwRecordId)  {
        Underwriting__c underWritingObj = new Underwriting__c();
        underWritingObj.Account_Name__c = uwRecordId;
        System.debug('Before inserting underwriting obj the DML limit is ' + Limits.getDmlStatements() + ' Limit is '
                + Limits.getLimitDmlRows() + ' get limit dml statements ' + Limits.getLimitDmlStatements());
        //underWritingObj.OwnerId=uwqueueid;
        underWritingObj.OwnerId=UserInfo.getUserId();
        insert underWritingObj;
        List<Owner_UW__c> insertUWListNew = new List<Owner_UW__c>();
        List<Contact> ctList = [
                SELECT Id
                FROM Contact
                WHERE AccountId = :uwRecordId AND Owner__c = true
        ];
        for (Contact varCon : ctList) {
            Owner_UW__c varUW = new Owner_UW__c();
            varUW.Contact__c = varCon.Id;
            varUW.Underwriting__c = underWritingObj.Id;
            insertUWListNew.add(varUW);
        }
            insert insertUWListNew;
            return underWritingObj;
        }


    /* Name: getUsersForAssignment
     * Parameter name: getUsersForAssignment (String): The ownerid of the underwriting object
     * Description: This method gets all users assigned to the underwriting queue except the current owner of the underwriting record and returns
     *              the list of users
     * Return Type: List of user objects
     */

    @auraenabled
    public static List<User> getUsersForAssignment(String uwOwnerId) {
        List<GroupMember> roleGroupList = [select Id, UserOrGroupId from GroupMember where GroupId = :uwqueueid];
        List<Id> rList = new List<id>();
        for(GroupMember vargm : roleGroupList) {
            rList.add(vargm.UserOrGroupId);
        }


        List<Group> roleList = [select Id, RelatedId from Group where Id IN :rList];

        List<Id> roleIdList = new List<Id>();
        for(Group varG : roleList) {
            roleIdList.add(varG.RelatedId);
        }

        List<User> uwUserList = [select Id, Name, ProfileId from User where IsActive = true AND Id != :uwOwnerId AND UserRole.Id IN
        :roleIdList];
        return uwUserList;

        }

    /* Name: assignOwnership
     * Parameter name: uwRecId (String): The id of the underwriting object
     *                  uwUserId (String): The user id to which the record has to be assigned
     * Description: This method takes the Underwriting record id, queries the Owner id of underwriting record for that record id
     *              and assigns the ownership to the user id. It changes the underwriting status to 'In Review'
     * Return Type: None
     */

    @auraenabled
    public static void assignOwnership(String uwRecId, String uwUserId) {
        System.debug('Inside assignOwnership uwrecid is ' + uwRecId + ' : User Id is ' + uwUserId);
        Underwriting__c uwRec = [select Id, OwnerId, Underwriting_Status__c from Underwriting__c WHERE Id = :uwRecId];
        if(uwRec != null) {
            uwRec.OwnerId = uwUserId;
            uwRec.Underwriting_Status__c = 'In Review';
        }

        update uwRec;
    }

  }