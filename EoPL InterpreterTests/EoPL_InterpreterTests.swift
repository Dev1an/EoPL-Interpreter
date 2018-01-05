//
//  EoPL_InterpreterTests.swift
//  EoPL InterpreterTests
//
//  Created by Damiaan on 5/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import XCTest
@testable import EoPL_Interpreter

class EoPL_InterpreterTests: XCTestCase {
	
	let initialEnvironment: Environment =
		.extend("i", .number(1),
				.extend("v", .number(5),
						.extend("x", .number(10), .end)
			)
	)
	
	func valueOf(program: Expression) -> ExpressedValue {
		return program.value(in: initialEnvironment)
	}
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}