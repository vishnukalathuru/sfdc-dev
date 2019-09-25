/**
 * Created by sanjeev.karanwal on 2019-06-08.
 */

/**
 * @File Name          : ContactTrigger
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
trigger ContactTrigger on Contact (after update) {
    if(Trigger.isAfter) {
        if(trigger.isUpdate) {
            ContactTriggerHandler.updateContactToDynamo(Trigger.newMap,Trigger.oldMap);
        }
    }

}