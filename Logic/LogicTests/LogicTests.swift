//
//  LogicTests.swift
//  LogicTests
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

@testable import Logic
import XCTest
import DataLayer
import SwiftData
import Model

final class LogicUnitTesting: XCTestCase {
    
    private var vm: WordCardViewModel?

    override func tearDownWithError() throws {
        vm = nil
    }

    @MainActor
    func testInsertAndCheckCORRECT() async throws {
        let container = try ContainerFactory.build(isStoredInMemoryOnly: true)
        vm = WordCardViewModel(container: container, incrementaionPoint: 10)
        XCTAssertNotNil(vm)
        let model = vm?.addCard(word: "Swift", meaning: "Language")
        
        if let model {
            let result = vm?.checkAnswer(for: model, userInput: "lAnguAge") ?? false
            XCTAssertTrue(result)
        }
    }
    
    @MainActor
    func testInsertAndCheckINCORRECT() async throws {
        let container = try ContainerFactory.build(isStoredInMemoryOnly: true)
        vm = WordCardViewModel(container: container, incrementaionPoint: 10)
        XCTAssertNotNil(vm)
        let model = vm?.addCard(word: "Swift", meaning: "Language")
        
        if let model {
            let result = vm?.checkAnswer(for: model, userInput: "6LANGuagse") ?? false
            XCTAssertFalse(result)
        }
    }
}
