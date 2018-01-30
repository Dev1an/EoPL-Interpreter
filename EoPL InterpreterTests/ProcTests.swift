//
//  ProcTests.swift
//  EoPL InterpreterTests
//
//  Created by Damiaan on 6/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import XCTest
@testable import EoPL_Interpreter

class ProcTests: XCTestCase {
	var zxDifference, minus100: Expression!

	override func setUp() {
		zxDifference = .proc(
			variable: "z",
			body: .difference(
				.variable("z"),
				.variable("x")
			)
		)
		
		minus100 = .let(
			"x", .constant(200),
			body: .let(
				"f", zxDifference,
				body: .let(
					"x", .constant(100),
					body: .let(
						"g", zxDifference,
						body: .difference(
							.call(proc: .variable("f"), argument: .constant(1)),
							.call(proc: .variable("g"), argument: .constant(1))
						)
					)
				)
			)
		)
	}
	
	func testProc() {
		XCTAssertEqual(
			try valueOf(program: minus100),
			.number(-100)
		)
	}
	
	func testTranslatedNameless(expression: Expression) {
		do {
			let original = try valueOf(program: expression)
			let translated =
				try translate(
					expression: expression,
					environment: StaticEnvironment.extend("i", .extend("v", .extend("x", .extend("f", .end))))
				).value(
					in: [.number(1), .number(5), .number(10), .boolean(false)]
				)
			XCTAssertTrue(original == translated, "expected \(original) but found \(translated)")
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
	func testNamelessProc() {
		testTranslatedNameless(expression: minus100)
	}
	
	func testNamelessEnv() {
		testTranslatedNameless(expression: .variable("i"))
		testTranslatedNameless(expression: .variable("v"))
		testTranslatedNameless(expression: .variable("x"))
		testTranslatedNameless(expression: .variable("f"))
	}
}

func ==(lhs: Expression.Value, rhs: LexicalExpression.Value) -> Bool {
	switch (lhs, rhs) {
	case (.boolean(let left), .boolean(let right)): return left == right
	case ( .number(let left),  .number(let right)): return left == right
	default: return false
	}
}
