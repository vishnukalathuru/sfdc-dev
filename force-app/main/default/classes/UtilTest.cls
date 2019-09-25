/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : UtilTest
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
public with sharing class UtilTest {
    @isTest
    public static void testChangeStateToAbbrev() {
        String shortName = Util.changeStateToAbbrev('Michigan');
        System.assertEquals('MI',shortName);
    }

    @isTest
    public static void testChangeStateToFullName(){
        String longName = Util.changeStateToFullName('MI');
        System.assertEquals('Michigan',longName);

    }

    @isTest
    public static void testReplaceNonNumChars(){
        String numericStr = Util.replaceNonNumChars('111-222-3333');
        System.assertEquals('1112223333',numericStr);

    }

    @isTest
    public static void testInsertErrorLog() {
        String className = 'ClassABC';
        String methodname = 'Met123';
        String erroMessage = 'Hello';
        Test.startTest();
        Util.insertErrorLog(className, methodname, erroMessage);
        Test.stopTest();

        ErrorLog__c errMsg = [select Class_Name__c, Error_Date_Time__c, Error_Description__c, Method_Name__c from ErrorLog__c LIMIT 1];
        System.assertEquals('ClassABC',errMsg.Class_Name__c);
        System.assertEquals('Met123',errMsg.Method_Name__c);
        System.assertEquals('Hello',errMsg.Error_Description__c);
    }

}