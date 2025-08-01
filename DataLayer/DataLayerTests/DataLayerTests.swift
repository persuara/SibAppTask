//
//  DataLayerTests.swift
//  DataLayerTests
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

@testable import DataLayer
import XCTest
import Model
import SwiftData

final class DataLayerUnitTests: XCTestCase {
    
    var repository: PersistentWordCardRepositoryProtocol?
    var container: ModelContainer?
    
    override func setUpWithError() throws {
        do {
            container = try ContainerFactory.build(isStoredInMemoryOnly: true)
            repository = PersistentWordCardRepository(container: container!)
        } catch {
            XCTFail("Failed to create container")
        }
    }
    
    override func tearDownWithError() throws {
        repository = nil
        container = nil
    }
    
    func testInsertNewCard() {
        XCTAssertNotNil(repository)
        let model = mockData()
        do {
            try repository!.insert(model)
            let retrievedData = try repository?.retrieve(model.id)
            XCTAssertNotNil(retrievedData)
        } catch {
            XCTFail("Either failed to insert or failed to catch")
        }
    }
    
    func testDeleteNewCard() {
        XCTAssertNotNil(repository)
        let model = mockData()
        do {
            try repository!.insert(model)
            let retrievedData = try repository?.retrieve(model.id)
            XCTAssertNotNil(retrievedData)
            try repository!.delete(model.id)
            let data = try repository?.retrieve(model.id)
            XCTAssertNil(data)
        } catch {
            XCTFail("Either failed to delete or failed to catch")
        }
    }
    
    func testUpdateCardStatus() {
        XCTAssertNotNil(repository)
        let model = mockData()
        do {
            try repository!.insert(model)
            try repository!.update(model.id, status: .correct)
            let data = try repository?.retrieve(model.id)
            XCTAssertNotNil(data)
            XCTAssert(data!.status == .correct)
        } catch {
            XCTFail("Either failed to update or failed to catch")
        }
    }
    
    func testRetrieveAllCards() {
        XCTAssertNotNil(repository)
        
        let model  = mockData()
        let model2 = mockData()
        let model3 = mockData()
        
        do {
            try repository!.insert(model)
            try repository!.insert(model2)
            try repository!.insert(model3)
            
            let data = try repository?.retreiveAll(order: .forward)
            XCTAssertEqual(3, data!.count)
        } catch {
            XCTFail("Either failed to insert or failed to catch")
        }
    }
}

extension DataLayerUnitTests {
    
    public func mockData() -> WordCard {
        return WordCard(word: "swift", meaning: "language")
    }
}
