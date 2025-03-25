//
//  Calculator_Test.swift
//  New Calculator_Tests
//
//  Created by Akbarshah Jumanazarov on 3/25/25.
//

@testable import New_Calculator
import XCTest

final class Calculator_Test: XCTestCase {
    
    var sut: Calculator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Calculator()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testBasicOperations() {
            // Test addition
            XCTAssertEqual(sut.calculate(expression: "2+2"), "4")
            
            // Test subtraction
            XCTAssertEqual(sut.calculate(expression: "5-3"), "2")
            
            // Test multiplication
            XCTAssertEqual(sut.calculate(expression: "4×3"), "12")
            
            // Test division
            XCTAssertEqual(sut.calculate(expression: "10÷2"), "5")
        }
        
        func testDivisionByZero() {
            XCTAssertEqual(sut.calculate(expression: "5÷0"), "Undefined")
        }
        
        func testDecimalNumbers() {
            // Test with comma as decimal separator
            XCTAssertEqual(sut.calculate(expression: "1,5+2,5"), "4")
            
            // Test result formatting
            XCTAssertEqual(sut.calculate(expression: "10÷4"), "2,5")
        }
        
        func testParentheses() {
            // Test basic parentheses
            XCTAssertEqual(sut.calculate(expression: "(2+3)×4"), "20")
            
            // Test nested parentheses
            XCTAssertEqual(sut.calculate(expression: "((2+3)×2)+1"), "11")
            
            // Test unbalanced parentheses
            XCTAssertEqual(sut.calculate(expression: "(2+3×2"), "8")
        }
        
        func testImplicitMultiplication() {
            // Test number followed by parentheses
            XCTAssertEqual(sut.calculate(expression: "2(3+1)"), "8")
            
            // Test parentheses followed by number
            XCTAssertEqual(sut.calculate(expression: "(2+1)3"), "9")
        }
        
        func testNegativeNumbers() {
            // Test negative number at start
            XCTAssertEqual(sut.calculate(expression: "-5+3"), "-2")
            
            // Test negative number after operator
            XCTAssertEqual(sut.calculate(expression: "2+-3"), "-1")
            
            // Test negative number in parentheses
            XCTAssertEqual(sut.calculate(expression: "2×(-3)"), "-6")
        }
        
        func testInvalidExpressions() {
            // Test empty expression
            XCTAssertEqual(sut.calculate(expression: ""), "")
            
            // Test incomplete expression
            XCTAssertEqual(sut.calculate(expression: "2+"), "2+")
        }
}
