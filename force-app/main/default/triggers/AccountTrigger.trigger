/**
 * Created by sanjeev.karanwal on 2019-06-08.
 */

/**
 * @File Name          : AccountTrigger
 * @Description        : 
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-08
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-08                    Initial Version
**/
trigger AccountTrigger on Account (before insert,before update,after insert,after update) {
    if(Trigger.isBefore){
        Map<Id,Account> oldMap = Trigger.isUpdate ? Trigger.oldMap:null;
        AccountTriggerHandler.prePopulateInitialDraw(Trigger.new,oldMap);  
    }
    if(Trigger.isAfter) {
        Map<Id,Account> oldMap = Trigger.isUpdate ? Trigger.oldMap:null;
        AccountTriggerHandler.updateAccountToDynamo(Trigger.NewMap, Trigger.oldMap);
    }
}