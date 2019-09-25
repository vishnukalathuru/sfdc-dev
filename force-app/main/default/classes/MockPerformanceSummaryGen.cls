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
global class MockPerformanceSummaryGen implements HttpCalloutMock {
// Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
// Optionally, only send a mock response for a specific endpoint
// and method.
//System.assertEquals('http://example.com/example/test', req.getEndpoint());
//System.assertEquals('GET', req.getMethod());

// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String response = '[{"uuid":"merchant_qa_85deeded-28d3-4f2f-a83e-8758e75bcf5a","financeVolumeYtd": 567890234.45,"financeVolumeTtm": 12342235.56,' +
                '"financeVolumeLtd": 876422223.76,"fundedLoans30": 1235,"fundedLoans60": 23455,"fundedLoans90": 98723,"fundedLoansLtd": 92821,' +
                '"dateOfLastApplication": "2019-05-31T18:26:38.564Z","totalContractorFeesYtd": 76534.23,"totalContractorFeesTtm": 827365.45,' +
                '"totalContractorFeesLtd": 9383435.23,"averageContractorFeesLtd": 983737.45,"averageLoanSize": 93874445.34,"averageFicoOnApprovedLoansLtd": 771,' +
                '"averageFicoOnFundedLoansLtd": 851,"approvalRateLtd": 0.02,"approvalRate90": 0.02,"approvalRateTtm": 0.02,"lossesCount": 9877,' +
                '"lossesInDollars": 938335.34,"lossRateCount": 0.02,"lossRateInDollars": 0.02,"dqRateLtd": 0.02,"6MNoNoCount": 26,"6MNoNoInDollars": 43},{' +
                '"uuid":"merchant_qa_feaac2dd-9133-461d-b29b-73722af90504","financeVolumeYtd": 567890235.45,"financeVolumeTtm": 12342235.56}]';
        res.setBody(response);
        res.setStatusCode(200);
        return res;
    }
}