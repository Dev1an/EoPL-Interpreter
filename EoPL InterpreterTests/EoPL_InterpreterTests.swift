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
    
    func testZero() {
		XCTAssertEqual(
			valueOf(program:
				.isZero(.constant(9))
			),
			.boolean(false)
		)
		XCTAssertEqual(
			valueOf(program:
				.isZero(
					.difference( .constant(9), .constant(9) )
				)
			),
			.boolean(true)
		)
	}
	
	func testIfExpression() {
		XCTAssertEqual(
			valueOf(program:
				.if(condition: .isZero(.variable("x")), positive: .constant(55), negative: .constant(99))
			),
			.number(99)
		)
		XCTAssertEqual(
			valueOf(program:
				.if(condition: .isZero(.constant(0)), positive: .constant(55), negative: .constant(99))
			),
			.number(55)
		)
	}
	
	func testLet() {
		XCTAssertEqual(
			valueOf(program:
				.let(
					"cijfer", .difference(.variable("x"), .constant(1)),
					body: .variable("cijfer")
				)
			),
			.number(9)
		)
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension ExpressedValue: Equatable {
	public static func ==(lhs: ExpressedValue, rhs: ExpressedValue) -> Bool {
		switch (lhs, rhs) {
		case (.boolean(let left), .boolean(let right)): return left == right
		case ( .number(let left),  .number(let right)): return left == right
		default: return false
		}
	}
}
