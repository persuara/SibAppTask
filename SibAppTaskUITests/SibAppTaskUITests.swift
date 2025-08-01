//
//  SibAppTaskUITests.swift
//  SibAppTaskUITests
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import XCTest
import DataLayer
import Logic
import SwiftData

final class SibAppTaskUITests: XCTestCase {
    
    var app: XCUIApplication!

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testOpeningAddCardSheet() {
        let addButton = app.buttons["AddNewCard"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3), "'Add new card' button in the toolbar does not exist.")
        addButton.tap()
        
        let wordTextField = app.textFields["WordField"]
        XCTAssertTrue(wordTextField.waitForExistence(timeout: 3))
        wordTextField.tap()
        wordTextField.typeText("swift")
        
        let meaningTextField = app.textFields["MeaningField"]
        XCTAssertTrue(meaningTextField.waitForExistence(timeout: 3))
        meaningTextField.tap()
        meaningTextField.typeText("language")
        
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "Save Button Not found")
        saveButton.tap()
    }
}
