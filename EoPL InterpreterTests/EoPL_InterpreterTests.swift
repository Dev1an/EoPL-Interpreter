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
						.extend("x", .number(10),
								.extend("f", .boolean(false), .end)
						)
			)
	)
	
	func valueOf(program: Expression) throws -> ExpressedValue {
		return try program.value(in: initialEnvironment)
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
			try valueOf(program:
				.isZero(.constant(9))
			),
			.boolean(false)
		)
		XCTAssertEqual(
			try valueOf(program:
				.isZero(
					.difference( .constant(9), .constant(9) )
				)
			),
			.boolean(true)
		)
	}
	
	func testIfExpression() {
		XCTAssertEqual(
			try valueOf(program:
				.if(condition: .isZero(.variable("x")), positive: .constant(55), negative: .constant(99))
			),
			.number(99)
		)
		XCTAssertEqual(
			try valueOf(program:
				.if(condition: .isZero(.constant(0)), positive: .constant(55), negative: .constant(99))
			),
			.number(55)
		)
	}
	
	func testLet() {
		XCTAssertEqual(
			try valueOf(program:
				.let(
					"cijfer", .difference(.variable("x"), .constant(1)),
					body: .variable("cijfer")
				)
			),
			.number(9)
		)
	}
	
	func testUnknownVariable() {
		XCTAssertThrowsError(try valueOf(program: .variable("z") ), "variable z should not be in the initial environment") { error in
			XCTAssertTrue(error is Environment.Error, "expected Environment error but found \(error)")
		}
	}
	
	func testIncompatibleTypes() {
		XCTAssertThrowsError(
			try valueOf(program: .isZero(.variable("f")) ),
			"executing isZero on a boolean should throw an error"
		) { error in
			XCTAssertTrue(error is ExpressedValue.Error, "expected Conversion error but found \(error)")
		}
		XCTAssertThrowsError(
			try valueOf(program:
				.if(condition: .variable("i"),
					positive: .constant(1),
					negative: .constant(2)
				)
			),
			"passing a number as condition should throw an error"
		) { error in
			XCTAssertTrue(error is ExpressedValue.Error, "expected Conversion error but found \(error)")
		}
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
