//
//  Translator.swift
//  EoPL Interpreter
//
//  Created by Damiaan on 30/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

public func translate(expression: Expression, environment: StaticEnvironment) throws -> LexicalExpression {
	switch expression {
	case let .difference(left, right):
		return try .difference(
			translate(expression: left,  environment: environment),
			translate(expression: right, environment: environment)
		)
	case .isZero(let argument):
		return .isZero(try translate(expression: argument, environment: environment) )
	case let .if(condition, positive, negative):
		return try .if(
			condition: translate(expression: condition, environment: environment),
			positive:  translate(expression: positive,  environment: environment),
			negative:  translate(expression: negative,  environment: environment)
		)
	case let .let(identifier, value, body):
		return .let(
			try translate(expression: value, environment: environment),
			body: try translate(expression: body, environment: .extend(identifier, environment))
		)
	case let .proc(variable, body):
		return .proc(
			body: try translate(expression: body, environment: .extend(variable, environment))
		)
	case let .call(proc, argument):
		return .call(
			proc: try translate(expression: proc, environment: environment),
			argument: try translate(expression: argument, environment: environment)
		)
	case .constant(let value):
		return .constant(value)
	case .variable(let identifier):
		return .variable(try environment.address(of: identifier))
	}
}

extension StaticEnvironment {
	func address(of variable: Expression.Identifier) throws -> LexicalExpression.Identifier {
		switch self {
		case .end:
			throw Expression.Environment.Error.identifierNotFound(variable)
		case let .extend(identifier, environment):
			if identifier == variable {
				return 0
			} else {
				return try 1 + environment.address(of: variable)
			}
		}
	}
}
