//
//  PurrFinderTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import XCTest
@testable import PurrFinder
import Combine

final class OpenAIServiceTests: XCTestCase {

    var openAIService: OpenAIService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        openAIService = OpenAIService()
    }

    override func tearDown() {
        openAIService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testGivenAValidPrompt_WhenSendPrompt_ThenCompletionReceived() {
        let expectation = XCTestExpectation(description: "Should return a response")
        let message = "Hello, World!"

        openAIService.sendMessage(message: message)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                // Check here the content of the answer
                XCTAssertNotNil(response.choices)
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0)
    }
}
