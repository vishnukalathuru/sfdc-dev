/**
 * Created by sanjeev.karanwal on 2019-06-08.
 */

/**
 * @File Name          : Leadtrigger
 * @Description        : 
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : VishnuVardhan Kalathuru
 * @Last Modified On   : 2019-06-08
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-08               Initial Version
 * 2.0                                   2019-09-10               Second Version
**/
trigger Leadtrigger on Lead (after insert, after update) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate )) {
        Map<Id,Lead> oldLeadMap = Trigger.isUpdate ? Trigger.oldMap:null;
        if(!Util.isIntegrationProfile()){
            LeadTriggerUtility.createApplicationURL(Trigger.newMap,oldLeadMap);
        }
    }
     
}