/**
 * Created by sanjeev.karanwal on 2019-06-01.
 */

/**
 * @File Name          : Util
 * @Description        :
 * @Author             : sanjeev.karanwal
 * @Group              :
 * @Last Modified By   : Sanjeev Karanwal
 * @Last Modified On   : 6/17/2019, 12:53:39 PM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-01                    Initial Version
**/
public with sharing class Util {
    private static Map<String,String> stateMap_toAbbrev = new Map<String,String>{ 'Alabama'=>'AL','Alaska'=>'AK','Arizona'=>'AZ','Arkansas'=>'AR',
    'California'=>'CA','Colorado'=>'CO','Connecticut'=>'CT',
    'Delaware'=>'DE','District of Columbia'=>'DC','Florida'=>'FL',
    'Georgia'=>'GA','Guam'=>'GU','Hawaii'=>'HI',
    'Idaho'=>'ID','Illinois'=>'IL','Indiana'=>'IN',
    'Iowa'=>'IA','Kansas'=>'KS','Kentucky'=>'KY',
    'Louisiana'=>'LA','Maine'=>'ME','Maryland'=>'MD',
    'Massachusetts'=>'MA','Michigan'=>'MI','Minnesota'=>'MN',
    'Mississippi'=>'MS','Missouri'=>'MO','Montana'=>'MT',
    'Nebraska'=>'NE','Nevada'=>'NV','New Hampshire'=>'NH',
    'New Jersey'=>'NJ','New Mexico'=>'NM','New York'=>'NY',
    'North Carolina'=>'NC','North Dakota'=>'ND','Ohio'=>'OH',
    'Oklahoma'=>'OK','Oregon'=>'OR','Pennsylvania'=>'PA',
    'Puerto Rico'=>'PR','Rhode Island'=>'RI',
    'South Carolina'=>'SC','South Dakota'=>'SD',
    'Tennessee'=>'TN','Texas'=>'TX','Utah'=>'UT',
    'Vermont'=>'VT','Virginia'=>'VA','Washington'=>'WA',
    'West Virginia'=>'WV','wisconsin'=>'WI','wyoming'=>'WY' };
    private static Map<String,String> stateMap_toName = new Map<String,String>{ 'AL'=>'Alabama','Ak'=>'Alaska','AZ'=>'Arizona','AR'=>'Arkansas',
    'CA'=>'California','CO'=>'Colorado','CT'=>'Connecticut',
    'DE'=>'Delaware','DC'=>'District of Columbia','FL'=>'Florida',
    'GA'=>'Georgia','GU'=>'Guam','HI'=>'Hawaii','ID'=>'Idaho',
    'IL'=>'Illinois','IN'=>'Indiana','IA'=>'Iowa','KS'=>'Kansas',
    'KY'=>'Kentucky','LA'=>'Louisiana','ME'=>'Maine','MD'=>'Maryland',
    'MA'=>'Massachusetts','MI'=>'Michigan','MN'=>'Minnesota',
    'MS'=>'Mississippi','MO'=>'Missouri','MT'=>'Montana','NE'=>'Nebraska',
    'NV'=>'Nevada','NH'=>'New Hampshire','NJ'=>'New Jersey',
    'NM'=>'New Mexico','NY'=>'New York','NC'=>'North Carolina',
    'ND'=>'North Dakota','OH'=>'Ohio','OK'=>'Oklahoma','OR'=>'Oregon',
    'PA'=>'Pennsylvania','PR'=>'Puerto Rico','RI'=>'Rhode Island',
    'SC'=>'South Carolina','SD'=>'South Dakota','TN'=>'Tennessee',
    'TX'=>'Texas','UT'=>'Utah','VT'=>'Vermont','VA'=>'Virginia',
    'WA'=>'Washington','WV'=>'West Virginia','WI'=>'Wisconsin','WY'=>'Wyoming' };


    /* Name: changeStateToAbbrev
     * Parameter name: state_name (String): The full name of the state 
     * Description: This method takes the full name of the state and returns the 2 letter state code
     * Return Type: String  
     */

    public static String changeStateToAbbrev(String state_name){
        if(String.isBlank(state_name)){ return NULL; }
        String state_name_lCase = state_name.trim(); // lower case and trim for better matching.
        return stateMap_toAbbrev.containsKey(state_name_lCase) ? stateMap_toAbbrev.get(state_name_lCase) : state_name; // return a match if there is one.
    }


   /* Name: changeStateToFullName
     * Parameter name: state_abbv (String): The 2 letter state code 
     * Description: This method takes the 2 letter state code and returns the full name of the state
     * Return Type: String  
     */
    public static String changeStateToFullName(String state_abbv){
        if(state_abbv==NULL){ return NULL; }
        String state_name = state_abbv.toUpperCase().trim(); // lower case and trim for better matching.
        return stateMap_toName.containsKey(state_name) ? stateMap_toName.get(state_name) : state_name; // return a match if there is one.
    }

    /* Name: replaceNonNumChars
     * Parameter name: phoneNbr (String): The string representation of phone 
     * Description: This method takes the strng representation of phone or any string and returns just the numeric digits
     * Return Type: String  
     */

    public static String replaceNonNumChars(String phoneNbr) {
        String numPhoneNbr = '';
        if(phoneNbr != null && phoneNbr != '') {
            numPhoneNbr = phoneNbr.replaceAll('\\D+','');
        }
        return numPhoneNbr;
    }


    /* Name: insertErrorLog
     * Parameter name: className (String): The name of the class for which the information has to be saved
     *                 methodName (String) : The name of the method for which the information has to be saved
     *                 errorDesc (String) : The error description which has to be saved
     * Description: This method inserts the error information in ErrorLog__c object
     * Return Type: None  
     */


    public static void insertErrorLog(String className, String methodName, String errorDesc) {
        ErrorLog__c el = new ErrorLog__c();
        el.Class_Name__c = className;
        el.Error_Date_Time__c = System.now();
        el.Error_Description__c = errorDesc;
        el.Method_Name__c = methodName;
        insert el;
    }
    
    public static Boolean isIntegrationProfile(){
        String profileName = [SELECT Name FROM Profile WHERE Id=:UserInfo.getProfileId()].Name;
        return profileName == RLConstants.INTEGRATION_PROFILE_NAME;
    }
    
     public static boolean isValueChanged(SObject OldRecord , SObject newRecord, String fieldName) {
        boolean isChanged = false;
        if (fieldName != null) {
            if (OldRecord != null && OldRecord.get(fieldName) != newRecord.get(fieldName)) {
                isChanged = true;
            } else if (newRecord.get(fieldName) != null) {
                isChanged = true; 
            }
        }
        return isChanged;
    }

    public static String verifyString(String paramValue){
        if(String.isBlank(paramValue)){
            paramValue = 'null';
        }
        return paramValue;
    }

    public static Decimal verifyNumber(Decimal paramValue){
        if(paramValue == null){
            paramValue = 0;
        }
        return paramValue;
    }

    public static DynamoTypes.InBusinessSince getInBusinessSince(Date datevalue){
        DynamoTypes.InBusinessSince businessSince = null;
        if(datevalue != null){
            businessSince = new DynamoTypes.InBusinessSince();
            //  businessSince.day = datevalue.day();
            businessSince.month = datevalue.month();
            businessSince.year = datevalue.year();
        }
        return businessSince;
    }

    public static DynamoTypes.DateOfBirth getDOB(Date dobDate){
        DynamoTypes.DateOfBirth dob = new DynamoTypes.DateOfBirth();
        if(dobDate != null){
            dob.month = dobDate.month();
            dob.day = dobDate.day();
            dob.year = dobDate.year();
        }
        return dob;
    }

    public static DynamoTypes.PostalAddress getAddressFields(SObject sObjrecord,String type){
        DynamoTypes.PostalAddress address = new DynamoTypes.PostalAddress();
        address.street = (String)sObjrecord.get(type+RLConstants.STREET);
        address.city   = (String)sObjrecord.get(type+RLConstants.CITY);
        address.state  = (String)sObjrecord.get(type+RLConstants.STATE);
        address.zip    = (String)sObjrecord.get(type+RLConstants.POSTALCODE);
        return address;
    }
    
    
}