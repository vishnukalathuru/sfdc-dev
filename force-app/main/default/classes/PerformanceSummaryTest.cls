/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : PerformanceSummaryTest
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
public with sharing class PerformanceSummaryTest {

    @isTest
    public static void testPerformSummaryCallout() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockPerformanceSummaryGen());
        PerformanceSummaryHelper.performSummaryCallout();
        Test.stopTest();
    }

}