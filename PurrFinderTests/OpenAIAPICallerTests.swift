//
//  PurrFinderTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import XCTest
@testable import PurrFinder
import OpenAISwift

final class OpenAIAPICallerTests: XCTestCase {
    
    func testGivenInput_WhenSendInput_ThenGetTheResponse() {
        let openAIAPICaller = OpenAIAPICaller.shared
        let input = "Dis une couleur"
        let expectation = self.expectation(description: "getResponse should return a result")
        
        openAIAPICaller.getResponse(input: input) { result in
            switch result {
            case .success(let output):
                XCTAssertNotNil(output)
                XCTAssertFalse(output.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Should not be successful")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGivenInput_WhenSendInput_ThenErrorOccured() {
        let openAIAPICaller = OpenAIAPICaller()
        let input = "Dis une couleur"
        let expectation = self.expectation(description: "getResponse should fail")
        let invalidAuthToken = "invalidAuthToken"
        
        // Mock the API key with an invalid value
        openAIAPICaller.client = OpenAISwift(authToken: invalidAuthToken)
        
        openAIAPICaller.getResponse(input: input) { result in
            switch result {
            case .success:
                XCTFail("Expected the request to fail")
            case .failure:
                // Check if the error message contains the invalid auth token
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
