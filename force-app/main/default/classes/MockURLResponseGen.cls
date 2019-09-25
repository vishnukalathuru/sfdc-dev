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
global class MockURLResponseGen implements HttpCalloutMock {
// Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
// Optionally, only send a mock response for a specific endpoint
// and method.
//System.assertEquals('http://example.com/example/test', req.getEndpoint());
//System.assertEquals('GET', req.getMethod());

// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '{"link":"https://qa.rockloans.com/merchant-application/index.html#/?partnerUuid=partner_qa_4f696b92-8d38-4a5f-96b7-e2e9ebc7cc9c&encryptedMetadata=9dFOHWNC9jXeV1Y44QYXcDo%2B7Q7SG2bUWwYcv63vGLBTtzu30dSCa%2B8qANKLBcCvQ589Vt30ejj5DX%2Bv2cO08gecq68WVgnVwcs7l2AMQMT%2B9ceOrNUR2dNGZI6bV%2FSfhfuZyBfzFXMtmUTOQ%2FpvVYB5ks8Z7z8QqoSVeo1wv%2FTYfOmHgpNDibWUmwW%2B9EWRKAW995n8Ss6V%2BNyF2DF%2BvA%3D%3D"}';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}