/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : UnderwriterControllerTest
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
public without sharing class UnderwriterControllerTest {
    @isTest
    public static void testGetPickListVal() {
        Map<String, List<String>> pickListMap = UnderwriterController.getPickListVal();
        System.assertEquals(pickListMap.size(),5);
    }

    @isTest
    public static void testGetUnderWritterRecord() {
        Account acct = new Account();
        acct.name = 'ABCCorp';
        acct.TaxID__c = 'fedtax1234';
        acct.merchant_uuid__c = '222222';
        acct.Merchant_ID__c = '99';
        insert acct;
        Contact con1 = new Contact();
        con1.lastName = 'Last1';
        con1.Owner__c = true;
        con1.AccountId = acct.Id;
        Contact con2 = new Contact();
        con2.lastName = 'Last2';
        con2.Owner__c = true;
        con2.AccountId = acct.Id;
        Contact con3 = new Contact();
        con3.lastName = 'Last3';
        con3.Owner__c = true;
        con3.AccountId = acct.Id;
        insert con1;
        insert con2;
        insert con3;

        Underwriting__c uw = new Underwriting__c();
        uw.Account_Name__c = acct.Id;
        insert uw;
        List<Owner_UW__c> OwnerUWObjLst = new List<Owner_UW__c>();
        Owner_UW__c ouw1 = new Owner_UW__c();
        ouw1.Underwriting__c = uw.Id;
        ouw1.Contact__c = con1.Id;
        Owner_UW__c ouw2 = new Owner_UW__c();
        ouw2.Underwriting__c = uw.Id;
        ouw2.Contact__c = con2.Id;
        insert ouw1;
        insert ouw2;

        Underwriting__c uw1 = UnderWriterController.getUnderWritterRecord(acct.Id);
        System.assertNotEquals(null,uw1);


        Underwriting__c uw2 = UnderWriterController.createNewtUnderWritterRecord(acct.Id);
        System.assertNotEquals(null,uw2);

        Account acct1 = new Account();
        acct1.name = 'ABCCorp1';
        acct1.TaxID__c = 'fedtax12341';
        acct1.merchant_uuid__c = '2222221';
        acct1.Merchant_ID__c = '991';
        insert acct1;
        Contact con11 = new Contact();
        con11.lastName = 'Last11';
        con11.Owner__c = true;
        con11.AccountId = acct1.Id;
        insert con11;

        Underwriting__c uw3 = UnderWriterController.getUnderWritterRecord(acct1.Id);
        System.assertNotEquals(null,uw3);
    }

    @isTest
    public static void testSetUnderWritter() {
        Account acct = new Account();
        acct.name = 'ABCCorp';
        acct.TaxID__c = 'fedtax1234';
        acct.merchant_uuid__c = '222222';
        acct.Merchant_ID__c = '99';
        insert acct;
        Underwriting__c uw = new Underwriting__c();
        uw.Account_Name__c = acct.Id;
        insert uw;
        List<Owner_UW__c> OwnerUWObjLst = new List<Owner_UW__c>();
        Owner_UW__c ouw1 = new Owner_UW__c();
        ouw1.Underwriting__c = uw.Id;
        Owner_UW__c ouw2 = new Owner_UW__c();
        ouw2.Underwriting__c = uw.Id;
        insert ouw1;
        insert ouw2;
        OwnerUWObjLst.add(ouw1);
        OwnerUWObjLst.add(ouw2);
        UnderwriterController.setUnderWritter(uw,OwnerUWObjLst);

    }

    @isTest
    public static void testOwnerAssignment() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr1 = new User(Alias = 'standm', Email='son11@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='son11@testorg.com');

        insert usr1;

        User usr2 = new User(Alias = 'standu', Email='son22@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='son22@testorg.com');

        insert usr2;


        Group uwQueueGrp = new group();
        uwQueueGrp.name = 'UnderWritingQueue11';
        uwQueueGrp.DeveloperName = 'UnderWriting_Queue11';
        uwQueueGrp.Type='Queue';
        insert uwQueueGrp;

        GroupMember uwGM = new GroupMember();
        uwGM.GroupId = uwQueueGrp.Id;
        uwGM.UserOrGroupId = usr1.Id;
        insert uwGM;

        GroupMember uwGM1 = new GroupMember();
        uwGM1.GroupId = uwQueueGrp.Id;
        uwGM1.UserOrGroupId = usr2.Id;
        insert uwGM1;

        List<User> queueUsr =  UnderwriterController.getUsersForAssignment(usr1.Id);
        //System.assertEquals(queueUsr.size() > 0,true);


        Account acct = new Account();
        acct.name = 'ABCCorp';
        acct.TaxID__c = 'fedtax1234';
        acct.merchant_uuid__c = '222222';
        acct.Merchant_ID__c = '99';
        Underwriting__c uw = new Underwriting__c();
        System.runAs(usr2) {
            // The following code runs as user 'u'
            insert acct;
            uw.Account_Name__c = acct.Id;
            insert uw;
            UnderwriterController.assignOwnership(uw.Id,usr1.Id);
        }


        Underwriting__c uwc = [select Id, OwnerId from Underwriting__c Where Account_Name__c = :acct.Id];
        System.assertEquals(uwc.OwnerId,usr1.Id);

    }
}