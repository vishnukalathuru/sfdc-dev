public class IpAddressGeoLocation {
    public static String apiKey = '0f3563fa11f3984d4c76bfd2ac140282bb7d08f75021a56e5229b459';
 //   @future(callout=true)
    public static void getLocationDetails(String ipAddress){
        try{
            HttpRequest req = new HttpRequest();
        	req.setEndpoint('callout:ipdata/'+ipAddress+'?api-key='+apiKey);
        	req.setMethod('GET');
			Http http = new Http();
			HTTPResponse res = http.send(req);
        	IpAdressGeoLocationResponse ipaddressGeolocation =  (IpAdressGeoLocationResponse)JSON.deserialize(res.getBody(),IpAdressGeoLocationResponse.class);
            if(String.isBlank(ipaddressGeolocation.message)){
            	System.debug(':::::res-line-1:::::'+ipaddressGeolocation.time_zone.abbr+';'+ipaddressGeolocation.asn.asn+';'+ipaddressGeolocation.count+';'+ipaddressGeolocation.asn.type+';'+ipaddressGeolocation.asn.domain);
        		System.debug(':::::res-line-2:::::'+ipaddressGeolocation.city+';'+ipaddressGeolocation.region+';'+ipaddressGeolocation.country_name+';'+ipaddressGeolocation.postal);     
            }else{
                System.debug('::::::resp:::::'+ipaddressGeolocation.message);
            }
        }catch(Exception ex){
            system.debug('::::exception message:::'+ex.getMessage());
            system.debug('::::exception message:::'+ex.getStackTraceString());
        }
    }   
}