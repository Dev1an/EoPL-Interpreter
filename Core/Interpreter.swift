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
		case .constant(let value):
			return .number(value)
		case .variable(let identifier):
			return try environment.find(identifier)
		}
	}
}
