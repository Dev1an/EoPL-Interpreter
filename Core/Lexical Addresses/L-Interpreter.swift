//
//  L-Interpreter.swift
//  EoPL Interpreter
//
//  Created by Damiaan on 30/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

extension LexicalExpression {
	public func value(in environment: Environment) throws -> LexicalExpression.Value {
		switch self {
		case let .difference(left, right):
			return try .number(
				left.value(in: environment).toInt() -
				right.value(in: environment).toInt()
			)
		case .isZero(let number):
			return try .boolean(
				number.value(in: environment).toInt() == 0
			)
		case let .if(condition, positive, negative):
			return try condition.value(in:environment).toBool() ?
				positive.value(in: environment) :
				negative.value(in: environment)
		case let .let(expression, body):
			return try body.value(
				in: [expression.value(in: environment)] + environment
			)
		case let .proc(body):
			return .procedure(body: body, environment)
		case let .call(procedure, argument):
			guard case let .procedure(body, capturedEnvironment) = try procedure.value(in: environment)
				else {
					fatalError("call to non procedure expression")
			}
			return try body.value(
				in: [argument.value(in: environment)] + capturedEnvironment
			)
		case .constant(let value):
			return .number(value)
		case .variable(let identifier):
			return environment[identifier]
		}
	}
}

extension LexicalExpression.Value {
	func toInt() throws -> Int {
		guard case .number(let number) = self else {throw Error.expectedIntButFound(self)}
		return number
	}
	
	func toBool() throws -> Bool {
		guard case .boolean(let boolean) = self else {throw Error.expextedBoolButFound(self)}
		return boolean
	}
	
	enum Error: Swift.Error {
		case expectedIntButFound(LexicalExpression.Value)
		case expextedBoolButFound(LexicalExpression.Value)
	}
}
