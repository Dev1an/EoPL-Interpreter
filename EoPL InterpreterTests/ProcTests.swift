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
	
	let zxDifference = Expression.proc(
		variable: "z",
		body: .difference(
			.variable("z"),
			.variable("x")
		)
	)
	
	func testProc() {
		XCTAssertEqual(
			try valueOf(program:
				.let(
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
			),
			.number(-100)
		)
	}
}
