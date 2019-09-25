/**
 * Created by sanjeev.karanwal on 2019-06-11.
 */

/**
 * @File Name          : MockLoanResponseGenerator
 * @Description        :
 * @Author             : sanjeev.karanwal
 * @Group              :
 * @Last Modified By   : sanjeev.karanwal
 * @Last Modified On   : 2019-06-11
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0                                   2019-06-11                    Initial Version
**/
@isTest
global class MockLoanResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{ "Client": { "firstName" : "FName", "lastName" : "LName", "state" : "Michigan"},"Investor" : "PSC Eaglewood",' +
                '"Merchant" : { "MerchantId" : "merch1234","MerchantUuid" : "Meruu1234"},"Salesperson":{ "SalespersonId": 12345,"SalespersonUuid":"salesuud7654"},"Servicing" : { "StatusCode" : 12345, "Status" : "60DPD" }, ' +
                ' "Loan" : { "loanId" : 98765, "loanUuid" : "lonuu987654333"}} ';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}