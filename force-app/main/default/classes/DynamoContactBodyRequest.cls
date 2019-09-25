public with sharing class DynamoContactBodyRequest {
    public String merchantId;	 
    public List<Owners> owners;
    public DynamoTypes.ApplicantInformation applicantInformation;
    public DynamoTypes.BusinessInformation businessInformation;

    public class Owners {
		public String uuid;	 
		public DynamoTypes.InBusinessSince ownerSince;
		public PersonalInformation personalInformation;
		public Decimal ownershipPercentage;	 
		public DynamoTypes.PostalAddress residentialAddress;
	}

    public class PersonalInformation {
        public String firstName;	 
        public String lastName;	 
        public DynamoTypes.DateOfBirth dateOfBirth;
        public String socialSecurityNumber;	 
        public String email;	 
        public Long mobileNumber;	 
    }
    public DynamoContactBodyRequest() {

    }
}
