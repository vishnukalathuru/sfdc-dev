/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : PerformaceSummarySchedulerTest
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
public with sharing class PerformaceSummarySchedulerTest {
    @isTest
    public static void testPerformanceShedule() {
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('SchedulePerformanceClassTest',  CRON_EXP, new PerformaceSummaryScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);


        //PerformaceSummaryScheduler.
    }

}