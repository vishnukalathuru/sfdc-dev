public class RLConstants {
	public static final String INTEGRATION_PROFILE_NAME = 'Integration Profile';
    public static final List<String> ACCOUNT_FIELD_UPDATES_TO_DYNAMO = new List<String>{'Name','TaxID__c','BillingStreet','BillingState','BillingCity','BillingPostalCode','ShippingStreet',
                                                                                         'ShippingState','ShippingCity','ShippingPostalCode','Business_License__c','Contractor_License__c',
        																				 'Doing_Business_As__c','In_Business_Since__c','Business_Structure__c','Main_Service__c','Website',
        																				 'AnnualRevenue','Annual_Consumer_Finance_Volume__c','Bank_Account_Number__c','Bank_Routing_Number__c',
        																				 'Phone','Active__c','Dynamo_Status__c','Initial_Draw__c' };
    public static final String MAIN_SERVICE = 'Main_Service__c';	
	public static final String MERCHANT_APPLICATION_STARTED = 'MERCHANT_APPLICATION_STARTED';																					 
	public static final String SALESPERSON_CREATED  = 'SALESPERSON_CREATED ';																					 
	public static final String SALESPERSON_UPDATED  = 'SALESPERSON_UPDATED ';																					 
	public static final String MERCHANT_APPLICATION_PENDING_DECISION = 'MERCHANT_APPLICATION_PENDING_DECISION';																					 
	public static final String MERCHANT_TRAINING_COMPLETE = 'MERCHANT_TRAINING_COMPLETE';																					 
    public static final String NEW_STATUS = 'New';
	public static final String UNITED_STATES = 'United States'; 
	public static final String MAILING = 'Mailing';
	public static final String BILLING = 'Billing';
	public static final String SHIPPING = 'Shipping';
	public static final String STREET = 'Street';
	public static final String CITY = 'City';
	public static final String STATE = 'State';
	public static final String POSTALCODE = 'PostalCode';
	public static final String COUNTRY = 'Country';
	public static final List<String> CONTACT_FIELD_UPDATES_TO_DYNAMO = new List<String>{'FirstName','LastName','Email','Phone','Birthdate','Primary_Contact__c','Owner_Since__c',
	                                                                                    'Ownership__c','SSN__c','Owner__c','Contact_Type__c','Title_With_Company__c','IsApplicant__c',
																						'Signature_Authority__c','isActive__c','MailingStreet','MailingCity','MailingState','MailingPostalCode' };

    public static final Set<String>	CONTACT_TYPE_SET = new Set<String>{'MID','SPID'};
	public static final String SPIDURL = 'salespeople';
}