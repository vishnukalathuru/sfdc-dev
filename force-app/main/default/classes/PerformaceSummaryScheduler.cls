/**
 * Created by sanjeev.karanwal on 2019-06-03.
 */

/**
 * @File Name          : PerformaceSummaryScheduler
 * @Description        : This is a scheduler class which is used to schedule the callouts to Dynamo to get information
 *                        for performance summary
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-03                    Initial Version
**/
public without sharing class PerformaceSummaryScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        PerformanceSummaryHelper.performSummaryCallout();
    }

}