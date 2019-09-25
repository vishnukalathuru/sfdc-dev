/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : ContactHelperTest
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
public with sharing class ContactHelperTest {

    @isTest
    public static void testUpsertContact() {
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
        List<Contact> ctList = new List<Contact>();
        ctList.add(con1);
        ctList.add(con2);
        ctList.add(con3);
        ContactHelper.upsertContact(ctList,'99');

    }

    @isTest
    public static void testUpsertSPID() {
        Account acct = new Account();
        acct.name = 'ABCCorp';
        acct.TaxID__c = 'fedtax1234';
        acct.merchant_uuid__c = '222222';
        acct.Merchant_ID__c = '99';
        insert acct;

        String jsonStr = ' [{"Username": "21c33ce9-bae8-4674-aca8-ce36c1c58232","Attributes": [{"Name": "sub","Value": "21c33ce9-bae8-4674-aca8-ce36c1c58232"' +
                '},{"Name": "email_verified","Value": "true"},{ "Name": "custom:merchant_id","Value": "3001"},{"Name": "name","Value": "Toms"},{"Name": "phone_number","Value": "+15554443333"},{"Name": "family_name","Value": "Wash"},{'
                + '"Name": "email","Value": "tommyjohn2006+salesforce2@gmail.com"}],"UserCreateDate": "2019-06-06T13:37:18.469Z","UserLastModifiedDate": "2019-06-07T10:31:19.206Z",'+
                '"Enabled": false,"UserStatus": "FORCE_CHANGE_PASSWORD","Groups": [{"GroupName": "cl-merchant-group","UserPoolId": "us-west-2_KoQ0vg0X7","Description": "Group for users who have merchant-level access in the merchant app",' +
                '"Precedence": 0,"LastModifiedDate": "2019-04-08T18:14:02.801Z","CreationDate": "2019-04-08T18:14:02.801Z"},{"GroupName": "cl-spid-group","UserPoolId": "us-west-2_KoQ0vg0X7",' +
                '"Description": "Group for users who have spid-level access in the merchant app","Precedence": 0,"LastModifiedDate": "2019-04-08T18:14:40.277Z",' +
                '"CreationDate": "2019-04-08T18:14:40.277Z"}],"Status": "SALESPERSON_CREATED"}]';
        ContactHelper.upsertSPID(jsonStr);
   }



    @isTest
    public static void testUpdateContactToDynamoNONSPID(){

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
        con2.AccountId = acct.Id;
        Contact con3 = new Contact();
        con3.lastName = 'Last3';
        con3.Owner__c = true;
        con3.AccountId = acct.Id;
        insert con1;
        insert con2;
        insert con3;
        List<Contact> ctList = new List<Contact>();
        con1.MailingPostalCode = '44552';
        update con1;
        con2.MailingPostalCode = '33333';
        con2.isActive__c = true;
        update con2;
    }
    @isTest
    public static void testUpdateContact() {
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
        con1.firstName = 'First1';
        con1.Email = 'abc@def.com';
        con1.Birthdate = Date.newInstance(2001,06,06);
        con1.Owner_Since__c = Date.newInstance(2015,01,01);
        con1.Primary_Contact__c = true;
        con1.IsApplicant__c = true;
        con1.MailingState = 'Michigan';
        insert con1;

        Contact cont = [select Id, lastName from Contact where lastName = 'Last1'];
        cont.lastName = 'NewLast1';
    }
}