//
//  LetRecTests.swift
//  EoPL InterpreterTests
//
//  Created by Damiaan on 6/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import XCTest
@testable import EoPL_Interpreter

class LetRecTests: XCTestCase {
	
	func double(of number: Int) -> Expression {
		return Expression.letrec(
			"Double", argument: "n",
				.if(condition: .isZero(.variable("n")),
					positive: .constant(0),
					negative: .difference(
						.call(
							proc: .variable("Double"),
							argument: .difference(
								.variable("n"),
								.constant(1)
							)
						),
						.variable("minusTwo")
					)
				),
			body: .call(proc: .variable("Double"), argument: .constant(number))
		)
	}
	
	func testLetRec() {
		XCTAssertEqual(
			try valueOf( program: double(of: 6) ),
			.number(12)
		)
		XCTAssertEqual(
			try valueOf( program: double(of: 0) ),
			.number(0)
		)
		XCTAssertEqual(
			try valueOf( program: double(of: 10) ),
			.number(20)
		)
	}
}
