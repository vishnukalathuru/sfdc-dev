public class IpAdressGeoLocationResponse{
	public String ip;	//75.143.188.23
	public boolean is_eu;
	public String city;	//Morganton
	public String region;	//North Carolina
	public String region_code;	//NC
	public String country_name;	//United States
	public String country_code;	//US
	public String continent_name;	//North America
	public String continent_code;	//NA
	public Double latitude;	//35.7319
	public Double longitude;	//-81.7091
	public String postal;	//28655
	public String calling_code;	//1
	public String flag;	//https://ipdata.co/flags/us.png
	public String emoji_flag;	//🇺🇸
	public String emoji_unicode;	//U+1F1FA U+1F1F8
	public IPAsn asn;
	public IPLanguages[] languages;
//	public IPcurrency currency;
	public IPTimeZone time_zone;
	public IPThreat threat;
	public String count;	//6
    public String message;
    
    public class IPAsn {
        public String asn;	//AS20115
        public String name;	//Charter Communications
        public String domain;	//spectrum.com
        public String route;	//75.143.160.0/19
        public String type;	//isp
    }
    public class IPLanguages {
        public String name;	//English
        public String native;	//English
    }
    public class IPcurrency {
        public String name;	//US Dollar
        public String code;	//USD
        public String symbol;	//$
        public String native;	//$
        public String plural;	//US dollars
    }
    public class IPTimeZone {
        public String name;	//America/New_York
        public String abbr;	//EDT
        public String offset;	//-0400
        public boolean is_dst;
        public String current_time;	//2019-09-09T14:06:43.012099-04:00
    }
    public class IPThreat {
        public boolean is_tor;
        public boolean is_proxy;
        public boolean is_anonymous;
        public boolean is_known_attacker;
        public boolean is_known_abuser;
        public boolean is_threat;
        public boolean is_bogon;
    }
}