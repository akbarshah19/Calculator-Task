//
//  MainIOWorker_Test.swift
//  New Calculator_Tests
//
//  Created by Akbarshah Jumanazarov on 3/25/25.
//

@testable import New_Calculator
import XCTest

final class MainIOWorker_Test: XCTestCase {
    
    var sut: MainWorker!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainWorker()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testAppendSymbol_WhenStartingWithZero_ShouldReplaceZero() {
            // Given
            let initialText = "0"
            let input = "5"
            var result = ""
            
            // When
            result = sut.appendSymbol(labelText: initialText, input: input)
            
            // Then
            XCTAssertEqual(result, "5")
        }
        
        func testAppendSymbol_WhenZeroAfterOperator_ShouldHandleCorrectly() {
            // Given
            let initialText = "2+0"
            let input = "5"
            var result = ""
            
            // When
            result = sut.appendSymbol(labelText: initialText, input: input)
            
            // Then
            XCTAssertEqual(result, "2+5")
        }
        
        func testAppendSymbol_WhenNormalNumber_ShouldAppendCorrectly() {
            // Given
            let initialText = "20"
            let input = "5"
            var result = ""
            
            // When
            result = sut.appendSymbol(labelText: initialText, input: input)
            
            // Then
            XCTAssertEqual(result, "205")
        }
        
        func testCalculate_SimpleAddition_ShouldReturnCorrectResult() {
            // Given
            let expression = "2+2"
            var result = ""
            var resultExpression = ""
            
            // When
            let (res, expr) = sut.calculate(expression: expression)
            result = res
            resultExpression = expr
            
            // Then
            XCTAssertEqual(result, "4")
            XCTAssertEqual(resultExpression, "2+2")
        }
}
