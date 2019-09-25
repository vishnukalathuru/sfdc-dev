public with sharing class MerchantApplicationRequest {
    public MerchantApplicationRequest() { }
    public String topic;	 
	public Resource resource;
	public class Resource {
		public DynamoTypes.BusinessInformation businessInformation;
		public DynamoTypes.Metadata metadata;
		public boolean isActive;
		public String ipAddress;	 
		public String status;	 
		public String createdAt;	 
		public String partnerUuid;	 
		public String uuid;	 
		public DynamoTypes.ApplicantInformation applicantInformation;
		public Integer merchantId;	
        public String updatedAt;
        public List<DynamoTypes.Owners>  owners;
        public ClientAgreement clientAgreement;
        public DynamoTypes.BankInformation bankInformation;
	}
  
    public class ClientAgreement {
		public boolean violationDisclosure;
		public boolean programAgreement;
	}
    
}
