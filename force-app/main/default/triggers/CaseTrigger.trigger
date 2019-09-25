/**
 * Created by sanjeev.karanwal on 2019-05-28.
 */

/**
 * @File Name          : CaseTrigger
 * @Description        : 
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-05-28
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-05-28                    Initial Version
**/
trigger CaseTrigger on Case (after insert) {
    if(trigger.isInsert && trigger.isAfter) {
        System.debug('Inside after trigger for case');
        List<Case> newCaseList = Trigger.new;
        CaseHelper.insertClientInfoForLoan(newCaseList[0]);
    }
}