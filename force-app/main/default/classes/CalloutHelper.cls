/**
 * @File Name          : CalloutHelper
 * @Description        : This is a helper class to make GET, POST and PUT callouts to specified endpoints. The base url of endpoint
 *                        is configured in Dynamo_Config__mdt metadata type.
 * @Author             : sanjeev.karanwal
 * @Group              : 
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-05-24
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-05-24                    Initial Version
**/
public without sharing class CalloutHelper {

    public static String apiKey;
    public static String basePartnerUrl;

/*
 *  Since the base url of endpoint is static, get this base url in a static block and reuse it. The baseurl is configured
 *  in custom metadata type under partner_base_url__c field with developer name as 'Dynamo'.
 */
    static {

        Dynamo_Config__mdt apiMetadata = [SELECT  Id,Key__c,DeveloperName,partner_base_url__c
                                            FROM Dynamo_Config__mdt
        WHERE DeveloperName = 'Dynamo' LIMIT 1][0];
        if(apiMetadata != null) {
            apiKey = 'Bearer ' + apiMetadata.Key__c;
            basePartnerUrl = apiMetadata.partner_base_url__c;
            if(apiKey == null) {
                System.debug('API Key not specified');
                Util.insertErrorLog('CalloutHelper','init','API Key not specified');
            }
            if(basePartnerUrl == null) {
                System.debug('Base Partner URL not specified');
                Util.insertErrorLog('CalloutHelper','init','Base Partner URL not specified');
            }
        } else {
            System.debug('API Key metadata type not specified');
            Util.insertErrorLog('CalloutHelper','init','API Key metadata type not specified');
        }
    }

    /*
        *   Name: performGetCallout
        *   Parameter name:
        *          calloutUrl (String). This is the endpoint url relative to base url. i,e if the endpoint is
        *           'https://partnerapi.qa.rockloans.com/v1/merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c', this parameter
        *           will contain 'merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c'
        * Description: This method takes the relative url as parameter and calls the performCallout method with relative url, 'GET' as
        *               callout method and body as null.
        * Return Type: String.  This is the response from the endpoint.
   */
    public static String performGetCallout(String calloutUrl) {
        return performCallout(calloutUrl,'GET',null);
    }



    /*
         *   Name: performPostCallout
         *   Parameter name:
         *          calloutUrl: (String). This is the endpoint url relative to base url. i,e if the endpoint is
         *           'https://partnerapi.qa.rockloans.com/v1/merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c', this parameter
         *           will contain 'merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c'
         *          calloutBody: (String). This is the post method body containing information for creating the resource in dynamo
         * Description: This method takes the relative url as parameter and calls the performCallout method with relative url, 'POST' as
         *               callout method and body as calloutBody.
         * Return Type: String.  This is the response from the endpoint.
    */
    public static String performPostCallout(String calloutUrl, String calloutBody) {
        return performCallout(calloutUrl,'POST',calloutBody);
    }



    /*
         *   Name: performPutCallout
         *   Parameter name:
         *          calloutUrl: (String). This is the endpoint url relative to base url. i,e if the endpoint is
         *           'https://partnerapi.qa.rockloans.com/v1/merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c', this parameter
         *           will contain 'merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c'
         *          calloutBody: (String). This is the put method body containing updates to be sent to dynamo
         * Description: This method takes the relative url as parameter and calls the performCallout method with relative url, 'PUT' as
         *               callout method and body as calloutBody.
         * Return Type: String.  This is the response from the endpoint.
    */
    public static String performPutCallout(String calloutUrl, String calloutBody) {
        return performCallout(calloutUrl,'PUT',calloutBody);
    }


    /*
            *   Name: performCallout
            *   Parameter name:
            *          calloutUrl: (String). This is the endpoint url relative to base url. i,e if the endpoint is
            *           'https://partnerapi.qa.rockloans.com/v1/merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c', this parameter
            *           will contain 'merchants/merchant_qa_12345678-8d38-4a5f-96b7-e2e9ebc7cc9c'
            *           calloutMethod: (String). This is the method used for callout. It can be GET, PUT or POST.
            *           calloutBody: (String). This is the put method body containing updates to be sent to dynamo if method is PUT,
            *                       information to create the resource in dynamo if the method is GET and null if method is GET
            * Description: This method takes the relative url as parameter and calls the performCallout method with relative url,
            *               callout method and calloutBody.
            * Return Type: String.  This is the response from the endpoint.
       */
    public static String performCallout(String calloutUrl, String calloutMethod, String calloutBody ) {
        HttpRequest request = new HttpRequest();
        String returnVal;
        String statusStr;
        String endpointURL = basePartnerUrl +  calloutUrl;
        System.debug('endpointurl is ' + endpointURL);
        request.setEndpoint(endpointURL);
        request.setMethod(calloutMethod);
        if(calloutMethod == 'POST' || calloutMethod == 'PUT') {
            if(calloutBody != null) {
                request.setBody(calloutBody);
            }

        }
        request.setHeader('Auth', apiKey);
        System.debug('api key is ' + apikey);
        request.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HttpResponse res = http.send(request);
        returnVal = res.getBody();
        statusStr = res.getStatus();
        System.debug('response is ' + res.getBody());
        return res.getBody();
    }




}