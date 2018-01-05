//
//  DataTypes.swift
//  eopl
//
//  Created by Damiaan on 4/01/18.
//  Copyright © 2018 Devian. All rights reserved.
//

public typealias Identifier = String

public enum Expression {
	indirect case difference(Expression, Expression)
	indirect case isZero(Expression)
	indirect case `if`(condition: Expression, positive: Expression, negative: Expression)
	indirect case `let`(Identifier, Expression, body: Expression)
	case constant(Int)
	case variable(Identifier)
}

public enum Environment {
	indirect case extend(Identifier, ExpressedValue, Environment)
	case end
	
	func find(_ query: Identifier) throws -> ExpressedValue {
		switch self {
		case let .extend(identifier, value, rest):
			return identifier == query ? value : try rest.find(query)
		case .end: throw Error.identifierNotFound(query)
		}
	}
	
	enum Error: Swift.Error {
		case identifierNotFound(Identifier)
	}
}

public enum ExpressedValue {
	case number(Int)
	case boolean(Bool)
	
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
