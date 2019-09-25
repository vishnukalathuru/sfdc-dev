public with sharing class DynamoTypes {

    public class ApplicantInformation {
        public boolean authorityToBindCompany;
        public String titleWithCompany;	 
        public String firstName;	 
        public String lastName;	 
        public Long phone;
        public boolean isOwner;	 
        public String uuid;	 
        public String email;
    }

    public class BankInformation{
        public String accountNumber;	 
	    public String routingNumber;
    }

    public class BusinessInformation {
        public String federalTaxId;	 
        public PostalAddress mailingAddress;
        public String businessStructure;	 
        public PostalAddress physicalAddress;
        public String legalBusinessName;	 
        public Long businessPhone;	 
        public String contractorLicenseNumber;	 
        public String typeOfServiceOrProductOffered;	 
        public List<String> allTradeNames;
        public Decimal annualSalesRevenue;	 
        public InBusinessSince inBusinessSince;	
        public ContactInfo primaryContactForFinancingInformation;
        public String website;
        public Decimal annualConsumerFinanceVolume;
        public String businessLicenseNumber;  
    }

    public class ContactInfo {
        public String firstName;
        public String lastName;
        public String name;	 
        public String uuid;
        public String email;
    }

    public class DateOfBirth {
        public Integer month;	 
        public Integer day;	 
        public Integer year;	 
    }

    public class Disclosure {
		public String name;	//owner-authorization
		public boolean signed;
	}

    public class InBusinessSince {
		public Integer month;	 
		public Integer year;	 
    }

    public class Metadata {
		public boolean authorityToBindCompany;
		public String lastName;	
		public String firstName;	 
		public boolean isOwner;
		public String titleWithCompany;
		public String legalBusinessName;	 
		public String businessPhone;
		public String email;
		public String leadid;	 
	}

    public class Owners {
		public Disclosure disclosure;
		public String uuid;	 
		public InBusinessSince ownerSince;
		public PersonalInformation personalInformation;
		public Decimal ownershipPercentage;	 
		public PostalAddress residentialAddress;
	}

    public class PersonalInformation {
        public String firstName;	 
        public String lastName;	 
        public DateOfBirth dateOfBirth;
        public String socialSecurityNumber;	 
        public String email;	 
        public Long mobileNumber;	 
        public String titleWithCompany;
    }
   
    public class PostalAddress {
        public String zip;	 
        public String state;	 
        public String city;	 
        public String street;
    }
    public DynamoTypes() {}
}
