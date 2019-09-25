public class DynamoAccountBodyRequest{
	public DynamoTypes.BankInformation bankInformation;
	public DynamoTypes.BusinessInformation businessInformation;
	public boolean isActive;
	public String status;	 
	public String uuid;	 
	public String merchantId;	 
	public Decimal maxFirstDrawPercent;  
	
	
	public DynamoAccountBodyRequest(){}
}