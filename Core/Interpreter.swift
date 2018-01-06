//
//  Interpreter.swift
//  eopl
//
//  Created by Damiaan on 4/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

extension Expression {
	public func value(in environment: Environment) throws -> ExpressedValue {
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
		case let .let(identifier, expression, body):
			return try body.value(in: .extend(
				identifier, expression.value(in: environment),
				environment)
			)
		case let .letrec(identifier, argument, expression, body):
			return try body.value(in: .recursiveExtend(identifier, argument, expression, environment))
		case let .proc(variable, body):
			return .procedure(variable: variable, body: body, environment)
		case let .call(procedure, argument):
			guard case let .procedure(variable, body, capturedEnvironment) = try procedure.value(in: environment)
				else {
					fatalError("call to non procedure expression")
			}
			return try body.value(in:
				.extend(
					variable,
					argument.value(in: environment),
					capturedEnvironment
				)
			)
		case .constant(let value):
			return .number(value)
		case .variable(let identifier):
			return try environment.find(identifier)
		}
	}
}

extension Environment {
	func find(_ query: Identifier) throws -> ExpressedValue {
		switch self {
		case let .extend(identifier, value, rest):
			return identifier == query ? value : try rest.find(query)
		case let .recursiveExtend(identifier, argument, expression, rest):
			if query == identifier {
				return .procedure(variable: argument, body: expression, self)
			} else {
				return try rest.find(query)
			}
		case .end: throw Error.identifierNotFound(query)
		}
	}
	
	enum Error: Swift.Error {
		case identifierNotFound(Identifier)
	}
}

extension ExpressedValue {
	func toInt() throws -> Int {
		guard case .number(let number) = self else {throw Error.expectedIntButFound(self)}
		return number
	}
	
	func toBool() throws -> Bool {
		guard case .boolean(let boolean) = self else {throw Error.expextedBoolButFound(self)}
		return boolean
	}
	
	enum Error: Swift.Error {
		case expectedIntButFound(ExpressedValue)
		case expextedBoolButFound(ExpressedValue)
	}
}
